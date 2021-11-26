open React
open Data

@react.component
let make = (~user) => {
  let (notifications: array<notification>, setNotifications) = useState(_ => [])

  useEffect0(() => {
    open Firebase.Divertask

    let onDataAdded = (id: option<string>, data) => {
      let notification = Notification.fromJson(id, data)

      setNotifications(prevNotications => [notification]->Belt.Array.concat(prevNotications))
    }

    let onDataChange = (id: option<string>, data) =>
      setNotifications(notifications =>
        notifications->Belt.Array.map(t => t.id == id ? data->Notification.fromJson(id, _) : t)
      )
    let stopListen = listenToPath("notifications", ~eventType=#child_added, ~onData=onDataAdded, ())
    let stopListen2 = listenToPath(
      "notifications",
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

  <div>
    {notifications
    ->Belt.Array.mapWithIndex((i, notification) =>
      <NotificationCard key={string_of_int(i)} user notification />
    )
    ->React.array}
  </div>
}
