@react.component
let make = (~user) => {
  let {tasks} = React.useContext(Context_Tasks.context)

  <div>
    {tasks->Belt.List.keep(t => t.status == Claim || t.status == Done)
    |> Array.of_list
    |> Js.Array.mapi((task, i) => <ClaimedTaskCard key={"task-" ++ string_of_int(i)} user task />)
    |> React.array}
  </div>
}
