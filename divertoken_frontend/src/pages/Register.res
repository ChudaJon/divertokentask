open React
open MaterialUI

module Item = Grid.Item

type registration = {
  username: string,
  password: string,
  confirmedPassword: string
}

let defaultRegistration = {
  username: "",
  password: "",
  confirmedPassword: ""
}

@react.component
let make = () => {
  let (registration, setRegistration) = React.useState(() => defaultRegistration)

  let onChange = (evt:ReactEvent.Form.t) => {
    let t = ReactEvent.Form.target(evt)
    
    setRegistration(r =>
    switch(t["name"]){
      |"username" => {...r, username: t["value"] }
      |"password" => {...r, username: t["password"] }
      |"cpassword" => {...r, username: t["cpassword"] }
      |_ => r
    }
    )
  }

  let textFieldStyle = ReactDOM.Style.make(~fontSize="25px", ~display="flex", ~justifyContent="center", ~margin="16px 0px", ());

  <Grid.Container> 
    <Container>
    <div style=(ReactDOM.Style.make(~margin="auto", ~textAlign="center", ~padding="100px 16px 30px 16px", ~fontFamily="Arial", ~fontSize="25px", ()))>
      {string("Register to Divertask")}
    </div>
    <div style=textFieldStyle>
      // <Item> <TextField label="Username" name="username" value=registration.username variant=TextField.Variant.outlined onChange /> </Item>
      <Item> <TextField label="Username" name="username" variant=TextField.Variant.outlined onChange /> </Item>
    </div>
    <div style=textFieldStyle>
      // <Item> <TextField label="Username" _type="password" name="username" value=registration.username variant=TextField.Variant.outlined onChange /> </Item>
      <Item> <TextField label="Password" _type="password" name="password" variant=TextField.Variant.outlined onChange /> </Item>
    </div>
    <div style=textFieldStyle>
      // <Item> <TextField label="Confirm Password" _type="password" name="cpassword" value=registration.confirmedPassword variant=TextField.Variant.outlined onChange /> </Item>
      <Item> <TextField label="Confirm Password" _type="password" name="cpassword" variant=TextField.Variant.outlined onChange /> </Item>
    </div>
    <div style=(ReactDOM.Style.make(~margin="auto", ~textAlign="center", ~borderRadius="4px", ~cursor="pointer", ~padding="25px", ()))>
      <Button
        color="primary" variant=Button.Variant.contained size="large">
        {string("Register")}
      </Button>
    </div>
    <div style=(ReactDOM.Style.make(~margin="auto", ~color="#26212E", ~textAlign="center", ~borderRadius="4px", ~padding="10px", ~fontFamily="Arial", ~fontSize="14px", ~textDecoration="none", ()))>
        // route to login
        <a href="/">{string("Log in")}</a>
    </div>
    </Container>
  </Grid.Container>
}
