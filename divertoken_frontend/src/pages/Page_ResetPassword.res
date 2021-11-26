open React
open MaterialUI
module Item = Grid.Item

@react.component
let make = () => {
  let textFieldStyle = ReactDOM.Style.make(
    ~fontSize="25px",
    ~justifyContent="center",
    ~margin="16px 16px",
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
              ~textAlign="left",
              ~fontWeight="bold",
              ~padding="80px 16px 30px 16px",
              ~fontFamily="Arial",
              ~fontSize="25px",
              (),
            )}>
            {string("Password Reset")}
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
            {string("Please enter your new password and we will reset it for you.")}
          </div>
          <div style=textFieldStyle>
            <Item>
              <TextField
                label="New Password"
                _type="password"
                name="password"
                variant=TextField.Variant.outlined
                fullWidth=true
              />
            </Item>
          </div>
          <div style=textFieldStyle>
            <Item>
              <TextField
                label="New Password Confirmation"
                _type="password"
                name="password"
                variant=TextField.Variant.outlined
                fullWidth=true
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
            // onClick=save password
              color="primary" variant=Button.Variant.contained size="large">
              {string("Save my password")}
            </Button>
          </div>
        </Container>
      </Grid.Container>
    </div>
  </div>
}
