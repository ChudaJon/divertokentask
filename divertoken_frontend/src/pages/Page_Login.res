open MaterialUI

module Item = Grid.Item

type login = {
  username: string,
  password: string,
}

let defaultLogin = {
  username: "",
  password: "",
}

@react.component
let make = () => {
  let (login, setLogin) = React.useState(() => defaultLogin)

  let onChange = (evt: ReactEvent.Form.t) => {
    let t = ReactEvent.Form.target(evt)

    setLogin(r =>
      switch t["name"] {
      | "username" => {...r, username: t["value"]}
      | "password" => {...r, password: t["password"]}
      | _ => r
      }
    )
  }

  let onLogin = _evt => {
    Firebase.Divertask.auth
    ->Firebase.Auth.signInWithEmailAndPassword(~email=login.username, ~password=login.password)
    ->Promise.then(x => {
      Js.log2("sign in result", x)
      let user = x["user"]
      Js.log2("user", user)

      let displayName = user["displayName"]
      let email = user["email"]

      Routes.push(UnclaimTask)
      Promise.resolve()
    })
    ->ignore
  }

  <Layout_FormPage>
    <Form title="Sign In to Divertask">
      <Form.TextInput label="Username" name="username" onChange />
      <Form.TextInput label="Password" _type="password" name="password" onChange />
      <Form.SubmitButton text="Sign In" onClick=onLogin />
      <Form.TextLink text="Register" onClick={_ => Routes.push(Register)} />
      <Form.TextLink text="Forgot password" onClick={_ => Routes.push(ForgotPassword)} />
    </Form>
  </Layout_FormPage>
}
