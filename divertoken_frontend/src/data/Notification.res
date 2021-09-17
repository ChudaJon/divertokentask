type notiType = 
  | Claimed
  | VerifyWait
  | Verify
  | Done

type t = {
  id: option<string>,
  task_id: option<string>,
  mutable notiType: notiType
};

module Database = Firebase.Database

let numbertoType = n => {
  switch(n){
    |0 => Claimed
    |1 => VerifyWait
    |2 => Verify
    |3 => Done
    |_ => Claimed
  }
}

let path = "notifications"
let db = Firebase.Divertask.db
let fromJson = (id: option<string>, data: Js.Json.t) => {
  open Json
  data->(
    json => {
      {
        id: id,
        task_id: (Decode.field("task_id", Decode.string)->Decode.optional)(json),
        notiType:  Decode.field("notiType", Decode.int)(json)->numbertoType,
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
    [    
      ("notiType", 
      switch notification.notiType {
          | Claimed => 0
          | VerifyWait => 1
          | Verify => 2
          | Done => 3
      }->Encode.int),
    ]
  )
  ->Js.Array.concat(
    notification.task_id->Belt.Option.mapWithDefault([], x => [("task_id", Encode.string(x))]),
  )
  ->Array.to_list
  ->Encode.object_
}

let createNotification = (~taskId: option<string>, ~notificationType) => {
  id: None,
  task_id: taskId,
  notiType: notificationType
}

let addNotification = (notification: t) => {
  let value = notification->toJson

  db->Database.ref(~path="notifications", ())->Database.Reference.push(~value, ())
}

let onSave = (~task_id : option<string>, ~notificationType) =>{
  createNotification(~taskId=task_id, ~notificationType)
  -> addNotification
  -> ignore
}

let allNotifications = (task: Task.t, byUser: User.t, notificationType) => {
  
  // Check who voted on the task & create notification for that user on this task id
  let taskEntries = Js.Dict.entries(task.voted)
  for x in 0 to Array.length(taskEntries)-1 {
    let (thisUser, voted) = taskEntries[x]
    if (voted == 1) {
      onSave(~task_id=task.id, ~notificationType=notificationType)
    }
  }
}

// Function to get task by taskID, change status of that task to DoneAndVerified & notification type to Done
let handlePressVerify = (/*task: Task.t, */byUser: User.t, notificationType) => {

  notificationType.notiType = Done
}