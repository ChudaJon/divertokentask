@react.component
let make = () => {
  let notifications = React.useContext(Context_Notifications.context)

  <div>
    {notifications
    ->Belt.Array.mapWithIndex((i, notification) =>
      <NotificationCard key={string_of_int(i)} notification />
    )
    ->React.array}
  </div>
}
