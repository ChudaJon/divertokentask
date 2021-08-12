type t = string
module Database = Firebase.Database;

let addTask = (task:t) => {
  let db = Firebase.Divertask.db;
  let path = "tasks"

  db->Database.ref(~path, ())->Database.Reference.push(~value=task,());
}

let fromJson = (data:Js.Json.t) => {
  Js.Json.decodeString(data)
}