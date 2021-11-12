open React
open MaterialUI
module Item = Grid.Item

@react.component
let make = () => {
  let (email, setEmail) = React.useState(_ => "")
  let textFieldStyle = ReactDOM.Style.make(
    ~fontSize="25px",
    ~justifyContent="center",
    ~margin="16px 16px",
    (),
  )

  let resetPassword = _ =>
    Firebase.Divertask.auth
    ->Firebase.Auth.sendPasswordResetEmail(
      ~email,
      ~actionCodeSetting={
        "url": "http://localhost:5050/reset-password-success", //TODO: change hostname in prod
      },
      (),
    )
    ->Js.Promise.then_(x => Js.log2("forgot password return", x)->Js.Promise.resolve, _)
    ->ignore

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
              ~textAlign="left",
              ~fontWeight="bold",
              ~padding="80px 16px 30px 16px",
              ~fontFamily="Arial",
              ~fontSize="25px",
              (),
            )}>
            {string("Forgot your password?")}
          </div>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~textAlign="left",
              ~padding="0px 16px 20px 16px",
              ~fontFamily="Arial",
              ~fontSize="17px",
              (),
            )}>
            {string(
              "Please enter the email you used to create your account. We will send you a reset password link",
            )}
          </div>
          <div style=textFieldStyle>
            <Item>
              <TextField
                label="Your Email"
                name="email"
                _type="email"
                variant=TextField.Variant.outlined
                fullWidth=true
                onChange={evt => {
                  let val = ReactEvent.Synthetic.target(evt)["value"]
                  setEmail(_ => val)
                }}
              />
            </Item>
          </div>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~textAlign="center",
              ~borderRadius="4px",
              ~cursor="pointer",
              ~padding="25px 0px 50px 0px",
              (),
            )}>
            <Button
              onClick={_ => resetPassword()}
              color="primary"
              variant=Button.Variant.contained
              size="large">
              {string("Send Me a Link")}
            </Button>
          </div>
        </Container>
      </Grid.Container>
    </div>
  </div>
}
