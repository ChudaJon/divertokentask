open MaterialUI
open MaterialUI.DataType

module Styles = {
  open ReactDOM.Style
  let title = make(
    ~fontWeight="bold",
    ~textAlign="center",
    ~padding="30px 16px 30px 16px",
    ~fontFamily="Arial",
    ~fontSize="25px",
    (),
  )
  let bottomPadding = make(~height="30px", ())
}

@react.component
let make = (~title, ~children=React.null) => {
  <form onSubmit={ReactEvent.Form.preventDefault}>
    <Container>
      <Grid.Container justify={Justify.center} alignItems={AlignItems.center}>
        <Grid.Item xs={GridSize.size(12)}>
          <div style={Styles.title}> {React.string(title)} </div>
        </Grid.Item>
        {children}
        <Grid.Item xs={GridSize.size(12)}> <div style={Styles.bottomPadding} /> </Grid.Item>
      </Grid.Container>
    </Container>
  </form>
}

module TextInput = {
  @react.component
  let make = (~label, ~name, ~_type=?, ~onChange) => {
    let style = ReactDOM.Style.make(~fontSize="25px", ~margin="10px", ~textAlign="center", ())

    <Grid.Item>
      <div style> <TextField label name ?_type variant=TextField.Variant.outlined onChange /> </div>
    </Grid.Item>
  }
}

module SubmitButton = {
  @react.component
  let make = (~text="Submit", ~onClick) => {
    let style = ReactDOM.Style.make(~textAlign="center", ~margin="16px", ~cursor="pointer", ())

    <Grid.Item xs={GridSize.size(12)}>
      <div style>
        <Button
          onClick color="primary" variant=Button.Variant.contained size="large" _type="submit">
          {React.string(text)}
        </Button>
      </div>
    </Grid.Item>
  }
}

module TextLink = {
  @react.component
  let make = (~text, ~onClick) => {
    let style = ReactDOM.Style.make(~textAlign="center", ~fontFamily="Arial", ~cursor="pointer", ())
    <Grid.Item xs={GridSize.size(12)}>
      <div onClick style> <Link> {React.string(text)} </Link> </div>
    </Grid.Item>
  }
}
