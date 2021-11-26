@module("/src/styles/TaskList.module.scss") external styles: 'a = "default"
@react.component
let make = (~user, ~setNotificationBadge) => {
  let tasks = React.useContext(Context_Tasks.context)

  <div>
    {tasks
    ->Belt.Array.keep(t =>
      switch t.status {
      | Claim(_) | Done(_) | DoneAndVerified(_) => true
      | _ => false
      }
    )
    ->Belt.Array.mapWithIndex((i, task) =>
      <ClaimedTaskCard key={string_of_int(i)} user task setNotificationBadge />
    )
    ->React.array}
  </div>
}
