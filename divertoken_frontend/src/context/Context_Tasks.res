open Data

type context = list<task>

let defaultContext = list{}

let context: React.Context.t<context> = React.createContext(defaultContext)

let logMsg = msg => Js.log(`[Tasks context]: ${msg}`)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (tasks: list<task>, setTaskList) = React.useState(_ => list{})

    let onDataAdded = (id: option<string>, data: Js.Json.t) => {
      let task = data->Task.fromJson(id, _)
      setTaskList(prevTasks => list{task, ...prevTasks})
    }

    let onDataChange = (id: option<string>, data: Js.Json.t) =>
      setTaskList(taskList =>
        taskList->Belt.List.map(t => t.id == id ? data->Task.fromJson(id, _) : t)
      )

    React.useEffect0(() => {
      let stopListen = Firebase.Divertask.listenToPath(
        "tasks",
        ~eventType=#child_added,
        ~onData=onDataAdded,
        (),
      )
      let stopListen2 = Firebase.Divertask.listenToPath(
        "tasks",
        ~eventType=#child_changed,
        ~onData=onDataChange,
        (),
      )

      let uninstall = () => {
        stopListen()
        stopListen2()
      }

      Some(uninstall)
    })

    let contextVal = tasks

    React.createElement(provider, {"value": contextVal, "children": children})
  }
}
