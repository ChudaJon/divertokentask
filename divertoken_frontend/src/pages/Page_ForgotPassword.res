open React
open MaterialUI
module Item = Grid.Item

module Styles = {
  let descriptionText = ReactDOM.Style.make(
    ~margin="auto",
    ~textAlign="left",
    ~padding="0px 16px 20px 16px",
    ~fontFamily="Arial",
    ~fontSize="17px",
    (),
  )
}

@react.component
let make = () => {
  let (email, setEmail) = React.useState(_ => "")

  let onEmailChange = evt => {
    let val = ReactEvent.Synthetic.target(evt)["value"]
    setEmail(_ => val)
  }

  let resetPassword = _ =>
    Firebase.Divertask.auth
    ->Firebase.Auth.sendPasswordResetEmail(
      ~email,
      ~actionCodeSetting={
        "url": `${Env.host}reset-password-success`,
      },
      (),
    )
    ->Js.Promise.then_(x => Js.log2("forgot password return", x)->Js.Promise.resolve, _)
    ->ignore

  let handleResetPassword = () => {
    // Routes.push(ForgotPasswordSuccess) Redirect to this page 
    resetPassword
  }
  <Layout_FormPage>
    <Form title="Forgot your password?">
      <div style={Styles.descriptionText}>
        {string(
          "Please enter the email you used to create your account. We will send you a reset password link",
        )}
      </div>
      <Form.TextInput
        label="Your Email" name="email" _type="email" onChange=onEmailChange autoFocus=true
      />
      <Form.SubmitButton text="Send Me a Link" onClick=handleResetPassword() />
    </Form>
  </Layout_FormPage>
}
