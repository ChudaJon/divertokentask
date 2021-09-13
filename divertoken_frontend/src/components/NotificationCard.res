open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t) => {

    <div style=(ReactDOM.Style.make(~display="flex", ()))>
    <Grid.Container>
      <div style=(ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ()))>
        <div className="box"
          style={ReactDOM.Style.make(~margin="10px", ~padding="15px 25px", ~backgroundColor="#FFFFFF", ())}>
          <Grid.Item xs={GridSize.size(12)}>
            <div style=(ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ()))>
              <Typography variant=Typography.Variant.h6> {string(task.content)} </Typography>
            </div>
          </Grid.Item>
          <div style=(ReactDOM.Style.make(~padding="10px", ()))>
            <Grid.Container>
            </Grid.Container>
            </div>
        </div>
      </div>
    </Grid.Container>
  </div>
}
