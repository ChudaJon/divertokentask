open React;
open Routes;

[@react.component]
let make = () => {
  let (tasks, setTasks) = useState(() => []);

  let url = ReasonReactRouter.useUrl();

  let onUnclaimedTask = () => {
    ReasonReactRouter.push(Routes.route2Str(UnclaimTask));
  };
  let onTaskList = () => {
    ReasonReactRouter.push(Routes.route2Str(TaskList));
  };
  let onNotification = () => {
    ReasonReactRouter.push(Routes.route2Str(Notification));
  };

  Js.log2("URL >> ", url);

  <div>
    {switch (url->Routes.url2route) {
     | Register => <Register />
     | UnclaimTask => <UnclaimTask tasks />
     | TaskList => <TaskList />
     | Notification => <Notification />
     | AddTask => <AddTask setTasks />
     }}
    <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button>
    <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
    <button onClick={_ => onNotification()}>
      {string("Notification")}
    </button>
  </div>;
};
