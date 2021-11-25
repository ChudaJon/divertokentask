open React
open MaterialUI
open Data

@react.component
let make = (~user, ~notificationBadge, ~setNotificationBadge) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let tasksFromContext = React.useContext(Context_Tasks.context)

  let (tasks: list<task>, setTaskList) = useState(_ => list{})

  let onDataAdded = (id: option<string>, data: Js.Json.t) => {
    let task = data->Task.fromJson(id, _)
    setTaskList(prevTasks => list{task, ...prevTasks})
  }

  let onDataChange = (id: option<string>, data: Js.Json.t) => {
    // Js.log3("task has changed", data, `with ID = ${id->Belt.Option.getWithDefault("no-id")}`)
    setTaskList(taskList =>
      taskList->Belt.List.map(t =>
        if t.id == id {
          data->Task.fromJson(id, _)
        } else {
          t
        }
      )
    )
  }

  let onDataRemove = (id: option<string>, data: Js.Json.t) => {
    let task = data->Task.fromJson(id, _)
    // Keep only ones that did not get deleted
    setTaskList(prevTasks => Belt.List.keep(prevTasks, t => t.id != task.id))
  }

  useEffect0(() => {
    open Firebase.Divertask
    let stopListen = listenToPath("tasks", ~eventType=#child_added, ~onData=onDataAdded, ())
    let stopListen2 = listenToPath("tasks", ~eventType=#child_changed, ~onData=onDataChange, ())
    let stopListen3 = listenToPath("tasks", ~eventType=#child_removed, ~onData=onDataRemove, ())

    let uninstall = () => {
      stopListen()
      stopListen2()
      stopListen3()
    }

    Some(uninstall)
  })

  Js.log2("task from context:: ", tasksFromContext)

  <div>
    {tasks->Belt.List.keep(t => t.status == Open)
    |> Array.of_list
    |> Js.Array.mapi((task, i) =>
      <UnclaimTaskCard
        key={"task-" ++ string_of_int(i)} user task notificationBadge setNotificationBadge
      />
    )
    |> React.array}
    <div style={ReactDOM.Style.make(~margin="auto", ~textAlign="center", ~padding="25px", ())}>
      <Button color="primary" variant=Button.Variant.contained onClick={_ => onAddTask()}>
        {string("+ Add Task")}
      </Button>
    </div>
  </div>
}
