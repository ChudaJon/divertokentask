open React
open MaterialUI
open MaterialUIDataType
@module("/src/styles/ClaimTaskCard.module.scss") external styles: 'a = "default"

@react.component
let make = (~user: Data.user, ~task: Data.task, ~setNotificationBadge) => {
  // Show Done Button or not
  let (_, setShowDone) = useState(_ => true)

  let (doneMsg, setDoneMsg) = useState(_ => false)

  let handleDoneMsgOpen = evt => {
    ReactEvent.Synthetic.preventDefault(evt)
    setDoneMsg(_ => true)
    task->Data.Task.done(user, setShowDone)->ignore
    task->Data.Notification.allNotifications(user, VerifyWait)->ignore
    task->Data.Notification.allNotifications(user, Verify)->ignore
    setNotificationBadge(prev => prev + 1)
  }

  let handleDoneMsgClose = () => setDoneMsg(_ => false)

  <Grid.Container className={task.status != Claim ? styles["unclaimed"] : ""}>
    <Grid.Item xs={GridSize.size(12)}>
      <div style={ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ())}>
        <Typography variant=Typography.Variant.h5> {string(task.content)} </Typography>
      </div>
      <Grid.Container>
        <Grid.Item xs={GridSize.size(6)}>
          {
            let due = switch task.deadline {
            | Some(d) => d->Js.Date.toString
            | None => "N/A"
            }
            <Typography> {string(`Deadline: ${due}`)} </Typography>
          }
        </Grid.Item>
        <Grid.Item xs={GridSize.size(6)}>
          <Typography> {string("Votes: " ++ string_of_int(task.vote))} </Typography>
        </Grid.Item>
      </Grid.Container>
    </Grid.Item>
    <Grid.Container>
      <Grid.Item xs={GridSize.size(6)}>
        {switch task.status {
        | Claim =>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~padding="10px 3px",
              ~fontFamily="Arial",
              ~fontSize="15px",
              (),
            )}>
            <Button color="primary" variant=Button.Variant.contained onClick={handleDoneMsgOpen}>
              {string("Done")}
            </Button>
          </div>
        | Done =>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~padding="10px 3px",
              ~fontFamily="Arial",
              ~fontSize="15px",
              (),
            )}>
            {string("Task is being verified")}
          </div>
        | DoneAndVerified =>
          <div
            style={ReactDOM.Style.make(
              ~margin="auto",
              ~padding="10px 3px",
              ~fontFamily="Arial",
              ~fontSize="15px",
              (),
            )}>
            {string("Task has been verified! Enjoy your tokens")}
          </div>
        | _ => <div> {string("")} </div>
        }}
        <Snackbar _open={doneMsg} autoHideDuration={6000} onClose={handleDoneMsgClose}>
          <Alert onClose={handleDoneMsgClose} severity="info">
            {string("Please wait for your task to be verified")}
          </Alert>
        </Snackbar>
      </Grid.Item>
    </Grid.Container>
  </Grid.Container>
}
