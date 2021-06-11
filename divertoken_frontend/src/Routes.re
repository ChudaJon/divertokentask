type routes =
  | Register
  | UnclaimTask
  | TaskList
  | Notification
  | AddTask;

let url2route = (url: ReasonReactRouter.url) =>
  switch (url.path) {
  | ["register"] => Register
  | ["unclaim-task"] => UnclaimTask
  | ["task-list"] => TaskList
  | ["notification"] => Notification
  | ["add-task"] => AddTask
  | _ => UnclaimTask
  };

let route2Str = route =>
  switch (route) {
  | Register => "/register"
  | UnclaimTask => "/unclaim-task"
  | TaskList => "/task-list"
  | Notification => "/notification"
  | AddTask => "/add-task"
  };
