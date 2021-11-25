open React
open Routes
open Data

module RouterNoAuth = {
  @react.component
  let make = (~onLoginSuccess) => {
    let url = RescriptReactRouter.useUrl()

    {
      switch url->Routes.url2route {
      | Register => <Page_Register />
      | ForgotPassword => <Page_ForgotPassword />
      | ForgotPasswordSuccess => <Page_ForgotPasswordSuccess />
      | ResetPassword => <Page_ResetPassword />
      | _ => <Page_Login onLoginSuccess />
      }
    }
  }
}

module RouterWithAuth = {
  @react.component
  let make = (~user: user, ~onLogout) => {
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
        <Layout_Main
          tokenCount
          notificationBadge
          setNotificationBadge
          title="Your Tasks"
          onLogout={_ => onLogout()}>
          <Page_TaskList user notificationBadge setNotificationBadge />
        </Layout_Main>
      | Notification =>
        <Layout_Main
          tokenCount
          notificationBadge
          setNotificationBadge
          title="Notifications"
          onLogout={_ => onLogout()}>
          <Page_NotificationList user />
        </Layout_Main>
      | AddTask =>
        <Layout_Main
          tokenCount
          notificationBadge
          setNotificationBadge
          title="Create a New Task"
          onLogout={_ => onLogout()}>
          <Page_AddTask user />
        </Layout_Main>
      | ViewTask(taskId) => <Page_ViewTask taskId user notificationBadge setNotificationBadge />
      | Logout => <div> {string("Logging out")} </div>
      | Account =>
        <Layout_Main
          tokenCount
          notificationBadge
          setNotificationBadge
          title="Create a New Task"
          onLogout={_ => onLogout()}>
          {string("Account page")}
        </Layout_Main>
      | _ =>
        <Layout_Main
          tokenCount
          notificationBadge
          setNotificationBadge
          title="Unclaimed Tasks"
          onLogout={_ => onLogout()}>
          <Page_UnclaimTask user notificationBadge setNotificationBadge />
        </Layout_Main>
      }}
    </Context_Tasks.Provider>
  }
}

@react.component
let make = () => {
  let (firebaseUser: option<Firebase.Auth.user>, setFirebaseUser) = React.useState(_ => None)
  let (user: option<user>, setUser) = React.useState(_ => None)

  React.useEffect0(() => {
    open Firebase.Divertask
    let onNext = nullableUser => {
      Js.log2("Firebase user change", nullableUser)
      nullableUser
      ->Js.Null.toOption
      ->((user: option<Firebase.Auth.User.t>) => setFirebaseUser(_ => user))
    }
    auth->Firebase.Auth.onAuthStateChanged(~nextOrObserver=onNext, ())
    None
  })

  React.useEffect1(() => {
    switch firebaseUser {
    | Some({uid, email, displayName}) =>
      let onData = (id: option<string>, data) => {
        let user = data->User.Codec.fromJson(id, _)
        Js.log2("Got user from listener", user)
        switch user {
        | Some(user) => setUser(_ => Some(user))
        | None =>
          User.addUser(
            ~user={
              id: uid,
              displayName: displayName->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
              token: 10,
              email: email->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
            },
          )->ignore
        }
      }
      let stopListen = Firebase.Divertask.listenToPath(
        `users/${uid}`,
        ~eventType=#value,
        ~onData,
        (),
      )
      Some(stopListen)
    | None =>
      setUser(_ => None)
      None
    }
  }, [firebaseUser])

  let onLogout = () =>
    Firebase.Divertask.auth
    ->Firebase.Auth.signOut
    ->Promise.then(_ => Routes.push(Login)->Promise.resolve)
    ->ignore

  let onLoginSuccess = () => Routes.push(UnclaimTask)

  <Context_Auth.Provider user>
    {switch user {
    | Some(user) => <RouterWithAuth user onLogout />
    | _ => <RouterNoAuth onLoginSuccess />
    }}
  </Context_Auth.Provider>
}
