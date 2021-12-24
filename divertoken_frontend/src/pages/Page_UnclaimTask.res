open React
open MaterialUI

@react.component
let make = (~user) => {
  let onAddTask = _ => Routes.push(AddTask)

  let tasks = React.useContext(Context_Tasks.context)

  <div>
    {tasks
    ->Belt.Array.keep(t => t.status == Open)
    ->Belt.Array.mapWithIndex((i, task) => <UnclaimTaskCard key={string_of_int(i)} user task />)
    ->React.array}
    <div style={ReactDOM.Style.make(~margin="auto", ~textAlign="center", ~padding="25px", ())}>
      <Button color="primary" variant=Button.Variant.contained onClick=onAddTask>
        {string("+ Add Task")}
      </Button>
    </div>
  </div>
}
