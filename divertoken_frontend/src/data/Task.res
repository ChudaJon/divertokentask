type status =
|Open
|Claim(User.t)
|Done(User.t)
|DoneAndVerified(User.t, array<User.t>)
;

type t = {
  id: option<string>,
  content: string,
  vote: int,
  deadline: option<Js.Date.t>,
  status
}

module Database = Firebase.Database;

let path = "tasks";
let db = Firebase.Divertask.db;

let fromJson = (id:option<string>, data:Js.Json.t) => {
  open Json;
  data->(json=>{
    {
      id,
      content: Decode.field("content", Decode.string)->Decode.withDefault("?")(json),
      vote: Decode.field("vote", Decode.int)->Decode.withDefault(0)(json),
      deadline: (Decode.field("deadline", Decode.date)->Decode.optional)(json),
      status: Open
    }
  })
}

let toJson = (task:t) => {
  open Json;
  [
    ("content", task.content->Encode.string),
    ("vote", task.vote->Encode.int),
    ("status", 0->Encode.int),
  ]
  -> Js.Array.concat(
    switch(task.id){
      |Some(id) => [("id", Encode.string(id))]
      |None => []
    })
  -> Array.to_list
  -> Encode.object_
};

let createTask = (~deadline=?, content:string) => { id: None, content, vote: 0, status: Open, deadline }

let addTask = (task:t) => {
  let value = task->toJson

  db->Database.ref(~path, ())->Database.Reference.push(~value, ());
}

let vote = (task:t, vote: int, byUser:User.t) => {
  byUser->User.spendToken(vote)->ignore

  let task = {...task, vote: vote +1}
  let value = task->toJson
  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}