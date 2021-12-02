open MaterialUI
@module("/src/styles/Layout_FormPage.module.scss") external styles: 'a = "default"

module Styles = {
  open ReactDOM.Style
  let container = make(~padding="50px 0px 0px 0px", ~display="flex", ~justifyContent="center", ())
}
@react.component
let make = (~children) => {
  <div style={Styles.container}> <Paper className={styles["form-card"]}> {children} </Paper> </div>
}
