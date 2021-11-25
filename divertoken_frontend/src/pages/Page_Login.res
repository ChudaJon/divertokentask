open React
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

  let textLink = (text, route) =>
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
      <Button onClick={_ => Routes.route2Str(route)->RescriptReactRouter.push}>
        {string(text)}
      </Button>
    </div>

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
      Js.log2("got result", x)
      let user = x["user"]
      Js.log2("user", user)

      let displayName = user["displayName"]
      let email = user["email"]
      Js.log3(">>", displayName, email)
      RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
      Promise.resolve()
    })
    ->ignore
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
            ~padding="80px 16px 30px 16px",
            ~fontFamily="Arial",
            ~fontSize="25px",
            (),
          )}>
          {string("Sign In to Divertask")}
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
        <div
          style={ReactDOM.Style.make(
            ~margin="auto",
            ~textAlign="center",
            ~borderRadius="4px",
            ~cursor="pointer",
            ~padding="25px",
            (),
          )}>
          <Button onClick=onLogin color="primary" variant=Button.Variant.contained size="large">
            {string("Sign In")}
          </Button>
        </div>
        {textLink("Register", Register)}
        {textLink("Forgot password", ForgotPassword)}
      </Container>
    </Grid.Container>
  </Layout_FormPage>
}
