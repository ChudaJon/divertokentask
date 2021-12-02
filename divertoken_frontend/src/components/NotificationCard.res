open React
open MaterialUI
open MaterialUIDataType
open Data

module Styles = {
  open ReactDOM.Style
  let container = make(~margin="auto", ~width="50%", ~display="block", ())
  let box = make(~margin="10px", ~padding="15px 25px", ~backgroundColor="#FFFFFF", ())

  let button = make(~margin="auto", ~padding="10px 3px", ())
}

@react.component
let make = (~notification: notification) => {
  let tasks = React.useContext(Context_Tasks.context)

  let taskId = notification.task_id->Belt.Option.getWithDefault("")

  let linkToTask = () => Routes.push(ViewTask(taskId))
  let optionTask = tasks->Belt.Array.getBy(t => t.id == Some(taskId))

  switch optionTask {
  | Some(task) =>
    <Grid.Container>
      <div style={Styles.container}>
        //TODO: Change to use either flex or block
        <div className="box" style={Styles.box}>
          <Grid.Item xs={GridSize.size(12)}>
            <div style={Styles.button}>
              <Button onClick={_ => linkToTask()}>
                <Typography variant=Typography.Variant.h6>
                  {string(
                    switch notification.notiType {
                    | Claimed(user) => `Task '${task.content}' has been claimed by ${user}`
                    | Complete =>
                      `A task that you voted for '${task.content}' is completed, you can verify it now`
                    | Verified(user) => `Task '${task.content}' has been verified by ${user}`
                    },
                  )}
                </Typography>
              </Button>
            </div>
          </Grid.Item>
        </div>
      </div>
    </Grid.Container>

  | None => string("")
  }
}
