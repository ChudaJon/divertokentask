open Types

open React
open Routes

module RouterNoAuth = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()

    {
      switch url->Routes.url2route {
      | Register => <Page_Register />
      | ForgotPassword => <Page_ForgotPassword />
      | ForgotPasswordSuccess => <Page_ForgotPasswordSuccess />
      | ResetPassword => <Page_ResetPassword />
      | _ => <Page_Login />
      }
    }
  }
}

module RouterWithAuth = {
  @react.component
  let make = (~user: User.t, ~onLogout) => {
    let tokenCount = {
      user.token != 1
        ? <div> {string(`You have  ${Js.Int.toString(user.token)} tokens`)} </div>
        : <div> {string(`You have  ${Js.Int.toString(user.token)} token`)} </div>
    }

    let (notificationBadge, setNotificationBadge) = useState(() => 0)

    let url = RescriptReactRouter.useUrl()

    React.useEffect1(() => {
      switch url->Routes.url2route {
      | Logout => onLogout()
      | _ => ()
      }
      None
    }, [url])

    <Context_Tasks.Provider>
      {switch url->Routes.url2route {
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
      | Logout => <div> {string("Logging out")} </div>
      | _ =>
        <Layout_Main tokenCount notificationBadge setNotificationBadge title="Unclaimed Tasks">
          <Page_UnclaimTask user notificationBadge setNotificationBadge />
        </Layout_Main>
      }}
    </Context_Tasks.Provider>
  }
}

@react.component
let make = () => {
  let (maybeUser, setUser) = useState(() => Loading)
  let (auth, _setAuth) = useState(() => "proto-user-0")

  let onLogout = () => setUser(_ => Success(None))

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

  switch maybeUser {
  | Loading => <div> {string("Loading")} </div>
  | Success(Some(user)) => <RouterWithAuth user />
  | _ => <RouterNoAuth />
  }
}
