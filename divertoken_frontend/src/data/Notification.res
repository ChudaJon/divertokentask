type t = {
  id: option<string>,
  task_id: option<string>,
};

module Database = Firebase.Database

let path = "notifications"
let db = Firebase.Divertask.db
let fromJson = (id: option<string>, data: Js.Json.t) => {
  open Json
  data->(
    json => {
      {
        id: id,
        task_id: (Decode.field("task_id", Decode.string)->Decode.optional)(json),
      }
    }
  )
}

let toJson = (notification: t) => {
  open Json
  switch notification.id {
  | Some(id) => [("id", Encode.string(id))]
  | None => []
  }
  ->Js.Array.concat(
    notification.task_id->Belt.Option.mapWithDefault([], x => [("deadline", Encode.string(x))]),
  )
  ->Array.to_list
  ->Encode.object_
}

let createNotification = (~taskId: option<string>) => {
    id: None,
    task_id: taskId
}

let claimNotification = (task: Task.t, byUser: User.t) => {

    // Check who voted on the task & create notification for that user on this task id
    let taskEntries = Js.Dict.entries(task.voted)
    for x in 0 to Array.length(taskEntries) {
        Js.log(x)
    }
}