open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: Data.user, ~task: Data.task, ~notificationBadge, ~setNotificationBadge) => {
  // Show Done Button or not
  let (_, setShowDone) = useState(_ => true)

  let (doneMsg, setDoneMsg) = useState(_ => false)

  let handleDoneMsgOpen = evt => {
    ReactEvent.Synthetic.preventDefault(evt)
    setDoneMsg(_ => true)
    task->Data.Task.done(user, setShowDone)->ignore
    task->Data.Notification.allNotifications(user, VerifyWait)->ignore
    task->Data.Notification.allNotifications(user, Verify)->ignore
    setNotificationBadge(_ => notificationBadge + 1)
  }

  let handleDoneMsgClose = () => {
    setDoneMsg(_ => false)
  }

  <div style={ReactDOM.Style.make(~display="flex", ())}>
    <Grid.Container>
      <div style={ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ())}>
        <div
          className="box"
          style={ReactDOM.Style.make(
            ~margin="10px",
            ~padding="10px",
            ~backgroundColor="#FFFFFF",
            ~borderRadius="3px 3px",
            (),
          )}>
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
                  <Button
                    color="primary" variant=Button.Variant.contained onClick={handleDoneMsgOpen}>
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
        </div>
      </div>
    </Grid.Container>
  </div>
}
