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

  let onDataChange = (id: option<string>, data: Js.Json.t) => {
    // Js.log3("task has changed", data, `with ID = ${id->Belt.Option.getWithDefault("no-id")}`)
    setTaskList(taskList => taskList->Belt.List.map(t => 
    if (t.id == id){
      data->Task.fromJson(id, _)
    } else {
      t
    }))
  }


  useEffect0(() => {
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData, ())
    let stopListen2 = Firebase.Divertask.listenToPath("tasks", ~eventType=#child_changed, ~onData=onDataChange, ())

    let uninstall = () => {
      stopListen()
      stopListen2()
    }

    Some(uninstall)
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
