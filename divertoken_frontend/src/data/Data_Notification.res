type userName = string
type notiType =
  | Claimed(userName)
  | Complete
  | Verifying(userName)
  | Verified(userName)

type t = {
  id: option<string>,
  task_id: option<string>,
  mutable notiType: notiType,
}

module Database = Firebase.Database

let path = "notifications"
let db = Firebase.Divertask.db
let fromJson = (notiId: option<string>, data: Js.Json.t) => {
  open Json.Decode
  let notiType = json =>
    switch field("notiType", int)->withDefault(0)(json) {
    | 0 => Claimed(field("user", string->optional)(json)->Belt.Option.getWithDefault("Some user"))
    | 1 => Complete
    | 2 => Verifying(field("user", string->optional)(json)->Belt.Option.getWithDefault("Some user"))
    | 3 => Verified(field("user", string->optional)(json)->Belt.Option.getWithDefault("Some user"))
    | _ => Claimed(field("user", string->optional)(json)->Belt.Option.getWithDefault("Some user"))
    }

  data->(
    json => {
      {
        id: notiId,
        task_id: (field("task_id", string)->optional)(json),
        notiType: json->notiType,
      }
    }
  )
}

let toJson = (notification: t) => {
  open Json.Encode
  switch notification.id {
  | Some(id) => [("id", string(id))]
  | None => []
  }
  ->Js.Array.concat(
    switch notification.notiType {
    | Claimed(user) => [("notiType", 0->int), ("user", user->string)]
    | Complete => [("notiType", 1->int)]
    | Verifying(user) => [("notiType", 2->int), ("user", user->string)]
    | Verified(user) => [("notiType", 3->int), ("user", user->string)]
    },
  )
  ->Js.Array.concat(
    notification.task_id->Belt.Option.mapWithDefault([], x => [("task_id", string(x))]),
  )
  ->Array.to_list
  ->object_
}

let createNotification = (~taskId: option<string>, ~notificationType) => {
  id: None,
  task_id: taskId,
  notiType: notificationType,
}

let addNotification = (notification: t) => {
  let value = notification->toJson

  db->Database.ref(~path="notifications", ())->Database.Reference.push(~value, ())
}

let onSave = (~task_id: option<string>, ~notificationType) => {
  createNotification(~taskId=task_id, ~notificationType)->addNotification->ignore
}

let allNotifications = (task: Data_Task.t, notificationType) => {
  // Check who voted on the task & create notification for that user on this task id
  let taskEntries = Js.Dict.entries(task.voted)
  for x in 0 to Array.length(taskEntries) - 1 {
    let (_thisUser, voted) = taskEntries[x]
    if voted == 1 {
      onSave(~task_id=task.id, ~notificationType)
    }
  }
}
