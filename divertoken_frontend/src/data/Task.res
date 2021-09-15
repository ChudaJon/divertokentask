type status =
  | Open
  | Claim
  | Done
  | DoneAndVerified


type t = {
  id: option<string>,
  content: string,
  vote: int,
  deadline: option<Js.Date.t>,
  mutable status: status,
  voted: Js.Dict.t<int>
}

module Database = Firebase.Database

let numbertoStatus = n => {
  switch(n){
    |0 => Open
    |1 => Claim
    |2 => Done
    |3 => DoneAndVerified
    |_ => Open
  }
}

let path = "tasks"
let db = Firebase.Divertask.db
let fromJson = (id: option<string>, data: Js.Json.t) => {
  open Json
  data->(
    json => {
      {
        id: id,
        content: Decode.field("content", Decode.string)->Decode.withDefault("?")(json),
        vote: Decode.field("vote", Decode.int)->Decode.withDefault(0)(json),
        deadline: (Decode.field("deadline", Decode.date)->Decode.optional)(json),
        status:  Decode.field("status", Decode.int)(json)->numbertoStatus,
        voted: Decode.field("voted", Decode.dict(Decode.int))->Decode.withDefault(Js.Dict.fromList(list{("0", 0)}))(json),
      }
    }
  )
}

let toJson = (task: t) => {
  open Json
  [
    ("content", task.content->Encode.string),
    ("vote", task.vote->Encode.int),
    ("status", 
      switch task.status {
          | Open => 0
          | Claim(_) => 1
          | Done(_) => 2
          | DoneAndVerified(_) => 3
      }->Encode.int),
    ("voted", Encode.dict(Encode.int)(task.voted)),
  ]
  ->Js.Array.concat(
    switch task.id {
    | Some(id) => [("id", Encode.string(id))]
    | None => []
    },
  )
  ->Js.Array.concat(
    task.deadline->Belt.Option.mapWithDefault([], x => [("deadline", Encode.date(x))]),
  )
  ->Array.to_list
  ->Encode.object_
}

let createTask = (~deadline=?, content: string, ~user: Divertoken.User.t) => {
  id: None,
  content: content,
  vote: 1,
  status: Open,
  deadline: deadline,
  voted: Js.Dict.fromList(list{(user.id, 1)})
}

let addTask = (task: t) => {
  let value = task->toJson

  db->Database.ref(~path="tasks", ())->Database.Reference.push(~value, ())
}

let vote = (task: t, vote: int, byUser: User.t) => {

  // If the user hasn't voted
  if (Js.Dict.get(task.voted, byUser.id) == Some(0) || Js.Dict.get(task.voted, byUser.id) == None ){

    Js.Dict.set(task.voted, byUser.id, 1)
    byUser->User.spendToken(vote)->ignore
    let task = {...task, vote: task.vote + vote}
    let value = task->toJson
    let path = switch task.id {
    | Some(id) => `${path}/${id}`
    | None => `${path}/unidentified}`
    }


    db->Database.ref(~path, ())->Database.Reference.update(~value, ())
  } else { // unvote

    Js.Dict.set(task.voted, byUser.id, 0)
    byUser->User.spendToken(-1)->ignore

    let task = {...task, vote: task.vote - vote}
    let value = task->toJson
    let path = switch task.id {
    | Some(id) => `${path}/${id}`
    | None => `${path}/unidentified}`
    }

    db->Database.ref(~path, ())->Database.Reference.update(~value, ())
  }
}

let claim = (task: t, byUser: User.t) => {

  // Use user later
  task.status = Claim;
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())

}

let done = (task: t, byUser: User.t , setShowDone) => {

  task.status = Done;
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  setShowDone(_ => false)
  db->Database.ref(~path, ())->Database.Reference.update(~value, ())

}

let verify = (task: t, byUser: User.t , setShowDone) => {

  task.status = DoneAndVerified;
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())

}