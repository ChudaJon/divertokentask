type routes =
  | Register
  | UnclaimTask
  | TaskList
  | Notification
  | AddTask
  | ViewTask(string)

let url2route = (url: RescriptReactRouter.url) =>
  switch url.path {
  | list{"register"} => Register
  | list{"unclaim-task"} => UnclaimTask
  | list{"task-list"} => TaskList
  | list{"notification"} => Notification
  | list{"add-task"} => AddTask
  | list{"view-task", taskId} => ViewTask(taskId)
  | _ => UnclaimTask
  }

let route2Str = route =>
  switch route {
  | Register => "/register"
  | UnclaimTask => "/unclaim-task"
  | TaskList => "/task-list"
  | Notification => "/notification"
  | AddTask => "/add-task"
  | ViewTask(taskId) => "/view-task/" ++ taskId
  }
