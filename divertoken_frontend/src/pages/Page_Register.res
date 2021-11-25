open MaterialUI
open Data

module Item = Grid.Item

type registration = {
  email: string,
  password: string,
  confirmedPassword: string,
}

let defaultRegistration = {
  email: "",
  password: "",
  confirmedPassword: "",
}

@react.component
let make = () => {
  let (registration, setRegistration) = React.useState(() => defaultRegistration)
  let (_error, setError) = React.useState(_ => "")

  let handleSubmit = evt => {
    ReactEvent.Synthetic.preventDefault(evt)
    if registration.password !== registration.confirmedPassword {
      setError(_ => "Passwords do not match")
    }

    Firebase.Divertask.auth
    ->Firebase.Auth.createUserWithEmailAndPassword(
      ~email=registration.email,
      ~password=registration.password,
    )
    ->Promise.then(({user: {uid, email} as firebaseUser}) => {
      Js.log2("Register result", firebaseUser)
      let user: user = {
        id: uid,
        displayName: registration.email,
        token: 10,
        email: email->Js.Nullable.toOption->Belt.Option.getWithDefault(""),
      }

      User.addUser(~user)->ignore
      Routes.push(Login)
      Promise.resolve()
    })
    ->Promise.catch(err => Js.log2("Register error", err)->Promise.resolve)
    ->ignore
  }

  let onChange = (evt: ReactEvent.Form.t) => {
    let t = ReactEvent.Form.target(evt)

    setRegistration(r => {
      switch t["name"] {
      | "email" => {...r, email: t["value"]}
      | "password" => {...r, password: t["value"]}
      | "cpassword" => {...r, confirmedPassword: t["value"]}
      | _ => r
      }
    })
  }

  <Layout_FormPage>
    <Form title="Register to Divertask">
      <Form.TextInput label="Email" name="email" onChange autoFocus=true />
      <Form.TextInput label="Password" _type="password" name="password" onChange />
      <Form.TextInput label="Confirm Password" _type="password" name="cpassword" onChange />
      <Form.SubmitButton onClick=handleSubmit />
      <Form.TextLink text="Log in" onClick={_ => Routes.push(Login)} />
    </Form>
  </Layout_FormPage>
}
