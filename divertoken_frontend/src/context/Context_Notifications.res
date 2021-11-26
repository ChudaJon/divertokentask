open Data
open Belt

type context = array<notification>

let defaultContext = []

let context: React.Context.t<context> = React.createContext(defaultContext)

let logMsg = msg => Js.log(`[Tasks context]: ${msg}`)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~children) => {
    let (notifications: array<notification>, setNotifications) = React.useState(_ => [])

    React.useEffect0(() => {
      open Firebase.Divertask
      let path = Notification.path

      let onDataAdded = (id, data) =>
        setNotifications(prev => [Notification.fromJson(id, data)]->Array.concat(prev))

      let onDataChange = (id, data) =>
        setNotifications(prev =>
          prev->Array.map(t => t.id == id ? data->Notification.fromJson(id, _) : t)
        )
      let onDataRemove = (id, _data) => setNotifications(prev => prev->Array.keep(t => t.id != id))
      let stopListen = listenToPath(path, ~eventType=#child_added, ~onData=onDataAdded, ())
      let stopListen2 = listenToPath(path, ~eventType=#child_changed, ~onData=onDataChange, ())
      let stopListen3 = listenToPath(path, ~eventType=#child_removed, ~onData=onDataRemove, ())

      let uninstall = () => {
        stopListen()
        stopListen2()
        stopListen3()
      }

      Some(uninstall)
    })

    React.createElement(provider, {"value": notifications, "children": children})
  }
}
