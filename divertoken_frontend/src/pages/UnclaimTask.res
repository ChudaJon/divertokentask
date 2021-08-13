open React
open MaterialUI

@react.component
let make = (~tasks, ~setTokenCoin) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let (tasks: list<string>, setTask) = useState(_ => list{})

  let onData = (id: option<string>, data: Js.Json.t) => {
    switch data->Task.fromJson(id, _) {
    | {content, status: Open} => setTask(prevTasks => list{content, ...prevTasks})
    | _ => ()
    }
  }

  useEffect0(() => {
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData, ())

    Some(stopListen)
  })

  <div>
    {tasks
    |> Array.of_list
    |> Js.Array.mapi((task, i) =>
      <UnclaimTaskCard key={"task-" ++ string_of_int(i)} content=task setTokenCoin />
    )
    |> React.array}
    <Button color="primary" variant=Button.Variant.contained onClick={_ => onAddTask()}>
      {string("+ Add Task")}
    </Button>
  </div>
}
