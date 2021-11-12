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

  let usernameRef = React.useRef("")
  let emailRef = React.useRef("")
  let passwordRef = React.useRef("")
  let passwordConfirmRef = React.useRef("")
  let (error, setError) = React.useState(_ => "")

  let handleSubmit = evt => {
    ReactEvent.Synthetic.preventDefault(evt)
    if passwordRef !== passwordConfirmRef {
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

    User.addUser(
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

  <div
    style={ReactDOM.Style.make(
      ~padding="50px 0px 0px 0px",
      ~display="flex",
      ~justifyContent="center",
      (),
    )}>
    <div
      style={ReactDOM.Style.make(
        ~backgroundColor="#FFFFFF",
        ~borderRadius="3px 3px",
        ~width="30%",
        (),
      )}>
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
            <a href="/"> {string("Log in")} </a>
          </div>
        </Container>
      </Grid.Container>
    </div>
  </div>
}
