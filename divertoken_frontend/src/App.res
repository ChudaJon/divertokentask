open Types

open React
open Routes

@react.component
let make = () => {
  let (maybeUser, setUser) = useState(() => Loading)
  let (auth, _setAuth) = useState(() => "proto-user-0")
  let (notificationBadge, setNotificationBadge) = useState(() => 0)

  useEffect1(() => {
    let onData = (id: option<string>, data: Js.Json.t) => {
      let user = data->User.Codec.fromJson(id, _)

      Js.log2("Got user", user)
      setUser(_ => Success(Some(user)))
    }
    let stopListen = Firebase.Divertask.listenToPath(
      `users/${auth}`,
      ~eventType=#value,
      ~onData,
      (),
    )

    Some(stopListen)
  }, [auth])

  let url = RescriptReactRouter.useUrl()

  switch maybeUser {
  | Loading => <div> {string("Loading")} </div>
  | Success(Some(user)) =>
    let tokenCount = {
      user.token != 1
        ? <div> {string(`You have  ${Js.Int.toString(user.token)} tokens`)} </div>
        : <div> {string(`You have  ${Js.Int.toString(user.token)} token`)} </div>
    }
    <div>
      // <AuthContext.Provider>
      <Context_Tasks.Provider>
        {switch url->Routes.url2route {
        | Register => <Page_Register />
        | Login => <Page_Login />
        | ForgotPassword => <Page_ForgotPassword />
        | ForgotPasswordSuccess => <Page_ForgotPasswordSuccess />
        | ResetPassword => <Page_ResetPassword />
        | ResetPasswordSuccess => <Page_ResetPasswordSuccess />
        | UnclaimTask =>
          <Layout_Main tokenCount notificationBadge setNotificationBadge title="Unclaimed Tasks">
            <Page_UnclaimTask user notificationBadge setNotificationBadge />
          </Layout_Main>
        | TaskList =>
          <Layout_Main tokenCount notificationBadge setNotificationBadge title="Your Tasks">
            <Page_TaskList user notificationBadge setNotificationBadge />
          </Layout_Main>
        | Notification =>
          <Layout_Main tokenCount notificationBadge setNotificationBadge title="Notifications">
            <Page_NotificationList user />
          </Layout_Main>
        | AddTask =>
          <Layout_Main tokenCount notificationBadge setNotificationBadge title="Create a New Task">
            <Page_AddTask user />
          </Layout_Main>
        | ViewTask(taskId) => <Page_ViewTask taskId user notificationBadge setNotificationBadge />
        }}
      </Context_Tasks.Provider>
      // </AuthContext.Provider>
    </div>
  | _ => <Page_Login />
  }
}
