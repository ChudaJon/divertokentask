type context = {tasks: list<Task.t>}
let defaultContext = {
  tasks: list{},
}
let context: React.Context.t<context> = React.createContext(defaultContext)

let logMsg = msg => Js.log(`[Tasks context]: ${msg}`)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (tasks: list<Task.t>, setTaskList) = React.useState(_ => list{})
    let onData = (id: option<string>, data: Js.Json.t) => {
      Js.log2("task in context", data)
      let task = Task.fromJson(id, data)
      Js.log2("task in context after", task)

      setTaskList(prevTasks => list{task, ...prevTasks})
    }

    React.useEffect0(() => {
      let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData, ())

      let uninstall = () => {
        stopListen()
      }

      Some(uninstall)
    })

    let contextVal = {
      tasks: tasks,
    }
    React.createElement(provider, {"value": contextVal, "children": children})
  }
}
