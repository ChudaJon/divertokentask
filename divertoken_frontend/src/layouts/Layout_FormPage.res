open MaterialUI

module Styles = {
  open ReactDOM.Style
  let container = make(~padding="50px 0px 0px 0px", ~display="flex", ~justifyContent="center", ())
  let card = make(~width="30%", ())
}

@react.component
let make = (~children) => {
  <div style={Styles.container}> <Paper style={Styles.card}> {children} </Paper> </div>
}
