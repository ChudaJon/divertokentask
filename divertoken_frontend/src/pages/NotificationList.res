open React
open MaterialUI

@react.component
let make = (~user, ~notificationBadge, ~setNotificationBadge) => {  
    
  let (notifications: list<Notification.t>, setNotificationList) = useState(_ => list{})

  let onDataAdded = (id: option<string>, data: Js.Json.t) => {
    let notification = Notification.fromJson(id, data)

    setNotificationList(prevNotication => list{notification, ...prevNotication})
  }

  let onDataChange = (id: option<string>, data: Js.Json.t) => {
    // Js.log3("task has changed", data, `with ID = ${id->Belt.Option.getWithDefault("no-id")}`)
    setNotificationList(notificationList => notificationList->Belt.List.map(t => 
    if (t.id == id){
      data->Notification.fromJson(id, _)
    } else {
      t
    }))
  }

  useEffect0(() => {
    let stopListen = Firebase.Divertask.listenToPath("notifications", ~eventType=#child_added, ~onData=onDataAdded, ())
    let stopListen2 = Firebase.Divertask.listenToPath("notifications", ~eventType=#child_changed, ~onData=onDataChange, ())

    let uninstall = () => {
      stopListen()
      stopListen2()
    }

    Some(uninstall)
  })

  <div>
    {notifications
    |> Array.of_list
    |> Js.Array.mapi((notification, i) => <NotificationCard key={"notification-" ++ string_of_int(i)} user notification notificationBadge setNotificationBadge />)
    |> React.array}
  </div>
}
