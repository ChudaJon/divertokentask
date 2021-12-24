@module("/src/styles/TaskList.module.scss") external styles: 'a = "default"
@react.component
let make = (~user, ~setNotificationBadge) => {
  let tasks = React.useContext(Context_Tasks.context)

  <div className={styles["tasklist"]}>
    {tasks
    ->Belt.Array.keep(t =>
      switch t.status {
      | Claim(_) => true
      | _ => false
      }
    )
    ->Belt.Array.reverse
    ->Belt.Array.mapWithIndex((i, task) => <ClaimedTaskCard key={string_of_int(i)} user task />)
    ->React.array}
    {tasks
    ->Belt.Array.keep(t =>
      switch t.status {
      | Done(_) => true
      | _ => false
      }
    )
    ->Belt.Array.reverse
    ->Belt.Array.mapWithIndex((i, task) => <ClaimedTaskCard key={string_of_int(i)} user task />)
    ->React.array}
    {tasks
    ->Belt.Array.keep(t =>
      switch t.status {
      | DoneAndVerified(_) => true
      | _ => false
      }
    )
    ->Belt.Array.reverse
    ->Belt.Array.mapWithIndex((i, task) => <ClaimedTaskCard key={string_of_int(i)} user task />)
    ->React.array}
  </div>
}
