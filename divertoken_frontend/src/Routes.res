type routes =
  | Register
  | Login
  | ForgotPassword
  | ForgotPasswordSuccess
  | ResetPassword
  | ResetPasswordSuccess
  | Logout
  | UnclaimTask
  | TaskList
  | Notification
  | AddTask
  | ViewTask(string)

let url2route = (url: RescriptReactRouter.url) =>
  switch url.path {
  | list{"register"} => Register
  | list{"login"} => Login
  | list{"forgot-password"} => ForgotPassword
  | list{"forgot-password-success"} => ForgotPasswordSuccess
  | list{"reset-password"} => ResetPassword
  | list{"reset-password-success"} => ResetPasswordSuccess
  | list{"logout"} => Logout
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
  | Login => "/login"
  | ForgotPassword => "/forgot-password"
  | ForgotPasswordSuccess => "forgot-password-success"
  | ResetPassword => "reset-password"
  | ResetPasswordSuccess => "reset-password-success"
  | Logout => "logout"
  | UnclaimTask => "/unclaim-task"
  | TaskList => "/task-list"
  | Notification => "/notification"
  | AddTask => "/add-task"
  | ViewTask(taskId) => "/view-task/" ++ taskId
  }

let push = route => RescriptReactRouter.push(route->route2Str)
