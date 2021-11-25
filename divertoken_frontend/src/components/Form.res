open MaterialUI
open MaterialUI.DataType

@react.component
let make = (~title, ~children=React.null) => {
  let titleStyle = ReactDOM.Style.make(
    ~margin="auto",
    ~fontWeight="bold",
    ~textAlign="center",
    ~padding="80px 16px 30px 16px",
    ~fontFamily="Arial",
    ~fontSize="25px",
    (),
  )
  <Grid.Container justify={Justify.center} alignItems={AlignItems.center}>
    <Container> <div style=titleStyle> {React.string(title)} </div> {children} </Container>
  </Grid.Container>
}

module TextInput = {
  @react.component
  let make = (~label, ~name, ~_type=?, ~onChange) => {
    let style = ReactDOM.Style.make(~fontSize="25px", ~margin="16px 0px", ())

    <Grid.Item>
      <div style> <TextField label name ?_type variant=TextField.Variant.outlined onChange /> </div>
    </Grid.Item>
  }
}

module SubmitButton = {
  @react.component
  let make = (~text="Submit", ~onClick) => {
    let style = ReactDOM.Style.make(
      ~margin="auto",
      ~textAlign="center",
      ~borderRadius="4px",
      ~cursor="pointer",
      ~padding="25px",
      (),
    )

    <div style>
      <Button onClick color="primary" variant=Button.Variant.contained size="large">
        {React.string(text)}
      </Button>
    </div>
  }
}

module TextLink = {
  @react.component
  let make = (~text, ~onClick) => {
    let style = ReactDOM.Style.make(~textAlign="center", ~fontFamily="Arial", ~cursor="pointer", ())
    <Grid.Item> <div onClick style> <Link> {React.string(text)} </Link> </div> </Grid.Item>
  }
}
