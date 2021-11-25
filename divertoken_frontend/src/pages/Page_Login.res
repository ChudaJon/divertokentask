open Data

type login = {
  username: string,
  password: string,
}

let defaultLogin = {
  username: "",
  password: "",
}

@react.component
let make = (~onLoginSuccess) => {
  let (login, setLogin) = React.useState(() => defaultLogin)

  let onChange = (evt: ReactEvent.Form.t) => {
    let t = ReactEvent.Form.target(evt)

    setLogin(r =>
      switch t["name"] {
      | "username" => {...r, username: t["value"]}
      | "password" => {...r, password: t["value"]}
      | _ => r
      }
    )
  }

  let onLogin = _evt => {
    Firebase.Divertask.auth
    ->Firebase.Auth.signInWithEmailAndPassword(~email=login.username, ~password=login.password)
    ->Promise.then(({user: {uid, displayName, email}}) => {
      Js.log("TODO: Set user")
      Js.log4("displayName", displayName, "email", email)

      let user: user = {
        id: uid,
        displayName: displayName,
        token: 10,
        email: email->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
      }
      onLoginSuccess(user)

      Promise.resolve()
    })
    ->Promise.catch(err => Js.log2("Login error", err)->Promise.resolve)
    ->ignore
  }

  <Layout_FormPage>
    <Form title="Sign In to Divertask">
      <Form.TextInput label="Username" name="username" onChange autoFocus=true />
      <Form.TextInput label="Password" _type="password" name="password" onChange />
      <Form.SubmitButton text="Sign In" onClick=onLogin />
      <Form.TextLink text="Register" onClick={_ => Routes.push(Register)} />
      <Form.TextLink text="Forgot password" onClick={_ => Routes.push(ForgotPassword)} />
    </Form>
  </Layout_FormPage>
}
