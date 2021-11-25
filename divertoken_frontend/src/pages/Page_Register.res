open React
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

  let textFieldStyle = ReactDOM.Style.make(
    ~fontSize="25px",
    ~display="flex",
    ~justifyContent="center",
    ~margin="16px 0px",
    (),
  )

  <Layout_FormPage>
    <Grid.Container>
      <Container>
        <div
          style={ReactDOM.Style.make(
            ~margin="auto",
            ~textAlign="center",
            ~padding="100px 16px 30px 16px",
            ~fontFamily="Arial",
            ~fontSize="25px",
            (),
          )}>
          {string("Register to Divertask")}
        </div>
        <div style=textFieldStyle>
          // <Item> <TextField label="Username" name="username" value=registration.username variant=TextField.Variant.outlined onChange /> </Item>
          <Item>
            <TextField
              label="Username" name="username" variant=TextField.Variant.outlined onChange
            />
          </Item>
        </div>
        <div style=textFieldStyle>
          // <Item> <TextField label="Username" name="username" value=registration.username variant=TextField.Variant.outlined onChange /> </Item>
          <Item>
            <TextField
              label="Email Address" name="email" variant=TextField.Variant.outlined onChange
            />
          </Item>
        </div>
        <div style=textFieldStyle>
          // <Item> <TextField label="Username" _type="password" name="username" value=registration.username variant=TextField.Variant.outlined onChange /> </Item>
          <Item>
            <TextField
              label="Password"
              _type="password"
              name="password"
              variant=TextField.Variant.outlined
              onChange
            />
          </Item>
        </div>
        <div style=textFieldStyle>
          // <Item> <TextField label="Confirm Password" _type="password" name="cpassword" value=registration.confirmedPassword variant=TextField.Variant.outlined onChange /> </Item>
          <Item>
            <TextField
              label="Confirm Password"
              _type="password"
              name="cpassword"
              variant=TextField.Variant.outlined
              onChange
            />
          </Item>
        </div>
        <div
          style={ReactDOM.Style.make(
            ~margin="auto",
            ~textAlign="center",
            ~borderRadius="4px",
            ~cursor="pointer",
            ~padding="25px",
            (),
          )}>
          <Button
            onClick=handleSubmit color="primary" variant=Button.Variant.contained size="large">
            {string("Register")}
          </Button>
        </div>
        <div
          style={ReactDOM.Style.make(
            ~margin="auto",
            ~color="#26212E",
            ~textAlign="center",
            ~borderRadius="4px",
            ~padding="10px 0px 50px 0px",
            ~fontFamily="Arial",
            ~fontSize="14px",
            ~textDecoration="none",
            (),
          )}>
          // route to login
          <Button onClick={_ => RescriptReactRouter.push(Routes.Login->Routes.route2Str)}>
            {string("Log in")}
          </Button>
        </div>
      </Container>
    </Grid.Container>
  </Layout_FormPage>
}
