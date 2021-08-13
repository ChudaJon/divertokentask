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
  status
}

module Database = Firebase.Database;

let fromJson = (id:option<string>, data:Js.Json.t) => {
  open Json;
  data->(json=>{
    {
      id,
      content: Decode.field("content", Decode.string)->Decode.withDefault("?")(json),
      vote: Decode.field("vote", Decode.int)->Decode.withDefault(0)(json),
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
  -> Array.to_list
  -> Encode.object_
};

let createTask = (content:string) => { id: None, content, vote: 0, status: Open }

let addTask = (task:t) => {
  let db = Firebase.Divertask.db;
  let path = "tasks"
  let value = task->toJson

  db->Database.ref(~path, ())->Database.Reference.push(~value, ());
}

let voteTask = (task:t, _vote: int) => {
  // TODO: DVT-7 Implement voteup/down task logic that update server data.
  task
}