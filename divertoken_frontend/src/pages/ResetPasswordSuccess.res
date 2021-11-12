open React
open MaterialUI
module Item = Grid.Item

@react.component
let make = () => {
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
            {string("Password Saved")}
          </div>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~textAlign="left",
              ~padding="0px 16px 30px 16px",
              ~fontFamily="Arial",
              ~fontSize="17px",
              (),
            )}>
            {string("You have successfully reset your password.")}
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
            // onClick=back to login
              color="primary" variant=Button.Variant.contained size="large">
              {string("Go to Login")}
            </Button>
          </div>
        </Container>
      </Grid.Container>
    </div>
  </div>
}
