type userId = string
type status =
  | Open
  | Claim(userId)
  | Done(userId)
  | DoneAndVerified(array<userId>)

type t = {
  id: option<string>,
  content: string,
  vote: int,
  deadline: option<Js.Date.t>,
  mutable status: status,
  voted: Js.Dict.t<int>,
  creator: userId,
}

module Database = Firebase.Database

let path = "tasks"
let db = Firebase.Divertask.db
let fromJson = (taskId: option<string>, data: Js.Json.t) => {
  open Json.Decode
  let status = json =>
    switch field("status", int)->withDefault(0)(json) {
    | 0 => Open
    | 1 =>
      switch (field("claimedBy", string)->optional)(json) {
      | Some(userId) => Claim(userId)
      | None => Open
      }
    | 2 =>
      switch (field("claimedBy", string)->optional)(json) {
      | Some(userId) => Done(userId)
      | None => Open
      }
    | 3 => DoneAndVerified(field("verified", array(string))->withDefault([])(json))
    | _ => Open
    }
  data->(
    json => {
      id: taskId,
      content: field("content", string)->withDefault("?")(json),
      vote: field("vote", int)->withDefault(0)(json),
      deadline: (field("deadline", date)->optional)(json),
      status: status(json),
      voted: field("voted", dict(int))->withDefault(Js.Dict.fromList(list{("0", 0)}))(json),
      creator: field("creator", string)(json),
    }
  )
}

let toJson = (task: t) => {
  open Json.Encode
  let statusFields = switch task.status {
  | Open => [("status", 0->int)]
  | Claim(userId) => [("status", 1->int), ("claimedBy", userId->string)]
  | Done(userId) => [("status", 2->int), ("claimedBy", userId->string)]
  | DoneAndVerified(userIds) => [("status", 3->int), ("verified", userIds->array(string, _))]
  }
  let idField = switch task.id {
  | Some(id) => [("id", string(id))]
  | None => []
  }
  [
    ("content", task.content->string),
    ("vote", task.vote->int),
    ("voted", dict(int)(task.voted)),
    ("creator", task.creator->string),
  ]
  ->Belt.Array.concat(statusFields)
  ->Js.Array.concat(idField)
  ->Js.Array.concat(task.deadline->Belt.Option.mapWithDefault([], x => [("deadline", date(x))]))
  ->Array.to_list
  ->object_
}

let createTask = (~deadline=?, content: string, ~user: Data_User.t) => {
  id: None,
  content: content,
  vote: 1,
  status: Open,
  deadline: deadline,
  voted: Js.Dict.fromList(list{(user.id, 1)}),
  creator: user.id,
}

let addTask = (task: t, byUser: Data_User.t) => {
  let value = task->toJson

  Js.Dict.set(task.voted, byUser.id, 1)
  byUser->Data_User.spendToken(1)->ignore
  db->Database.ref(~path="tasks", ())->Database.Reference.push(~value, ())
}

let vote = (task: t, vote: int, byUser: Data_User.t) => {
  // If the user hasn't voted
  if Js.Dict.get(task.voted, byUser.id) == Some(0) || Js.Dict.get(task.voted, byUser.id) == None {
    Js.Dict.set(task.voted, byUser.id, 1)
    byUser->Data_User.spendToken(vote)->ignore
    let task = {...task, vote: task.vote + vote}
    let value = task->toJson
    let path = switch task.id {
    | Some(id) => `${path}/${id}`
    | None => `${path}/unidentified}`
    }

    db->Database.ref(~path, ())->Database.Reference.update(~value, ())
  } else {
    // unvote

    Js.Dict.set(task.voted, byUser.id, 0)
    byUser->Data_User.spendToken(-1)->ignore

    let task = {...task, vote: task.vote - vote}
    let value = task->toJson
    let path = switch task.id {
    | Some(id) => `${path}/${id}`
    | None => `${path}/unidentified}`
    }

    // Delete the task if vote count is 0
    if task.vote == 0 {
      db->Database.ref(~path, ())->Database.Reference.remove()
    } else {
      db->Database.ref(~path, ())->Database.Reference.update(~value, ())
    }
  }
}

let claim = (task: t, byUser: Data_User.t) => {
  // Use user later
  task.status = Claim(byUser.id)
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

let done = (task: t, byUser: Data_User.t, setShowDone) => {
  task.status = Done(byUser.id)
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  setShowDone(_ => false)
  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

let verify = (task: t, byUser: Data_User.t) => {
  task.status = switch task.status {
  | Done(_claimer) => DoneAndVerified([byUser.id])
  | DoneAndVerified(verifiers) => DoneAndVerified(verifiers->Belt.Array.concat([byUser.id]))
  | status => status
  }
  let task = {...task, status: task.status}
  let value = task->toJson
  let path = switch task.id {
  | Some(id) => `${path}/${id}`
  | None => `${path}/unidentified}`
  }

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

let verifyByTaskId = (taskId: string) => {
  // tasks/<taskId>/status

  let value = list{("status", 3->Json.Encode.int)}->Json.Encode.object_
  let path = `tasks/${taskId}`

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

// Function to give user who claimed task tokens equal to the number of votes when task is DoneAndVerified
let giveToken = (user: Data_User.t, task: t) => {
  user->Data_User.spendToken(-task.vote)->ignore
}
