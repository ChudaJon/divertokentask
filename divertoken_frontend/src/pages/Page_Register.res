open MaterialUI

module Item = Grid.Item

type registration = {
  username: string,
  email: string,
  password: string,
  confirmedPassword: string,
}

let defaultRegistration = {
  username: "",
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

    //try
    // AuthContext.Provider.signup(~email="song@divertise.asia", ~password="123456+")
    // ->ignore
    Firebase.Divertask.auth
    ->Firebase.Auth.createUserWithEmailAndPassword(
      ~email=registration.email,
      ~password=registration.password,
    )
    ->Promise.then(userCredential => {
      Js.log2("got result", userCredential)

      Js.log2("got result", userCredential.user)
      Promise.resolve()
    })
    ->ignore

    Data.User.addUser(
      ~user={
        id: "id" ++ registration.username,
        displayName: registration.username,
        token: 10,
        email: registration.email,
      },
    )->ignore

    // catch

    ()
  }

  let onChange = (evt: ReactEvent.Form.t) => {
    let t = ReactEvent.Form.target(evt)

    setRegistration(r => {
      switch t["name"] {
      | "username" => {...r, username: t["value"]}
      | "email" => {...r, email: t["value"]}
      | "password" => {...r, password: t["value"]}
      | "cpassword" => {...r, confirmedPassword: t["value"]}
      | _ => r
      }
    })
  }

  <Layout_FormPage>
    <Form title="Register to Divertask">
      <Form.TextInput label="Username" name="username" onChange />
      <Form.TextInput label="Password" _type="password" name="password" onChange />
      <Form.TextInput label="Confirm Password" _type="password" name="cpassword" onChange />
      <Form.SubmitButton onClick=handleSubmit />
      <Form.TextLink text="Log in" onClick={_ => Routes.push(Login)} />
    </Form>
  </Layout_FormPage>
}
