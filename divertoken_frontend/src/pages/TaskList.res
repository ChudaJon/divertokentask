open React
@react.component
let make = (~user, ~notificationBadge, ~setNotificationBadge) => {  
  
  let {tasks} = React.useContext(Context_Tasks.context)

  let (tasks: list<Task.t>, setTaskList) = useState(_ => list{})

  let onData = (id: option<string>, data: Js.Json.t) => {
    let task = Task.fromJson(id, data)

    setTaskList(prevTasks => list{task, ...prevTasks})
  }

  useEffect0(() => {
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData, ())
    // let stopListen2 = Firebase.Divertask.listenToPath("tasks", ~eventType=#child_changed, ~onData=onDataChange, ())

    let uninstall = () => {
      stopListen()
      // stopListen2()
    }

    Some(uninstall)
  })

  <div>
    {tasks->Belt.List.keep(t => t.status == Claim || t.status == Done)
    |> Array.of_list
    |> Js.Array.mapi((task, i) => <ClaimedTaskCard key={"task-" ++ string_of_int(i)} user task notificationBadge setNotificationBadge />)
    |> React.array}
  </div>
}
