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

  <Grid.Container> 
    <p> {string("Register")} </p> 
    <Item> <TextField label="Username" name="username" value=registration.username onChange /> </Item>
    <Item> <TextField label="Password" name="password" value=registration.password onChange /> </Item>
    <Item> <TextField label="Confirmed Password" name="cpassword" value=registration.confirmedPassword onChange /> </Item>
  </Grid.Container>
}
