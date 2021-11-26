open Data
open Belt

type context = array<task>

let defaultContext = []

let context: React.Context.t<context> = React.createContext(defaultContext)

let logMsg = msg => Js.log(`[Tasks context]: ${msg}`)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (tasks: array<task>, setTasks) = React.useState(_ => [])

    React.useEffect0(() => {
      open Firebase.Divertask
      let onTaskAdded = (id, data) =>
        setTasks(prevTasks => prevTasks->Array.concat([data->Task.fromJson(id, _)]))
      let onTaskChange = (id, data) =>
        setTasks(taskList => taskList->Array.map(t => t.id == id ? data->Task.fromJson(id, _) : t))
      let onTaskRemove = (id, _data) =>
        setTasks(prevTasks => prevTasks->Array.keep(t => t.id != id))

      let stopListen = listenToPath("tasks", ~eventType=#child_added, ~onData=onTaskAdded, ())
      let stopListen2 = listenToPath("tasks", ~eventType=#child_changed, ~onData=onTaskChange, ())
      let stopListen3 = listenToPath("tasks", ~eventType=#child_removed, ~onData=onTaskRemove, ())

      let uninstall = () => {
        stopListen()
        stopListen2()
        stopListen3()
      }

      Some(uninstall)
    })

    let contextVal = tasks

    React.createElement(provider, {"value": contextVal, "children": children})
  }
}
