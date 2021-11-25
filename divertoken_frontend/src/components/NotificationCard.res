open React
open MaterialUI
open MaterialUIDataType
open Data

@react.component
let make = (~user: user, ~notification: notification) => {
  let allTasks = React.useContext(Context_Tasks.context)

  let taskId = notification.task_id->Belt.Option.getWithDefault("")

  let linkToTask = () => Routes.push(ViewTask(taskId))
  let optionTask = allTasks->Belt.List.getBy(t => t.id == Some(taskId))

  switch optionTask {
  | Some(task) =>
    <Grid.Container>
      <div style={ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ())}>
        <div
          className="box"
          style={ReactDOM.Style.make(
            ~margin="10px",
            ~padding="15px 25px",
            ~backgroundColor="#FFFFFF",
            (),
          )}>
          <Grid.Item xs={GridSize.size(12)}>
            <div style={ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ())}>
              <Button onClick={_ => linkToTask()}>
                <Typography variant=Typography.Variant.h6>
                  {string(
                    switch notification.notiType {
                    | Claimed =>
                      `Your task '${task.content}' has been claimed by ${user.displayName}`
                    | VerifyWait =>
                      `Your task '${task.content}' is being verified by ${user.displayName}`
                    | Verify =>
                      `A task that you voted for '${task.content}' is completed, you can verify it now`
                    | Done => `Your task '${task.content}' has been verified by ${user.displayName}`
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
