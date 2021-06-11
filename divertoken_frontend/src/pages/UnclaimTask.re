open React;

[@react.component]
let make = (~tasks) => {
  let onAddTask = () => {
    ReasonReactRouter.push(Routes.route2Str(AddTask));
  };

  <div>
    {tasks
     ->Belt.List.map(task => {<UnclaimTaskCard content=task />})
     ->Array.of_list
     ->React.array}
    <button onClick={_ => onAddTask()}> {string("+ Add Task")} </button>
  </div>;
};
