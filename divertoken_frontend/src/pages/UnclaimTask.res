open React
open MaterialUI

@react.component
let make = (~user) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let (tasks: list<Task.t>, setTaskList) = useState(_ => list{})

  let onData = (id: option<string>, data: Js.Json.t) => {
    Js.log2("task", data)
    let task = data->Task.fromJson(id, _)
    setTaskList(prevTasks => list{task, ...prevTasks})
  }

  useEffect0(() => {
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData, ())

    Some(stopListen)
  })

  <div>
    {tasks
    |> Array.of_list
    |> Js.Array.mapi((task, i) => <UnclaimTaskCard key={"task-" ++ string_of_int(i)} user task />)
    |> React.array
    }
    <Button color="primary" variant=Button.Variant.contained onClick={_ => onAddTask()}>
      {string("+ Add Task")}
    </Button>
  </div>
}
