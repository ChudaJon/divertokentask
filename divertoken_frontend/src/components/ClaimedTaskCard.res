open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t) => {

  let (showDone, setShowDone) = useState(_ => true);

  let (doneMsg, setDoneMsg) = useState(_ => false)

  let handleDoneMsgOpen = (evt) => {
    ReactEvent.Synthetic.preventDefault(evt);
    setDoneMsg(_ => true)
    task->Task.done(user, setShowDone)->ignore
    // Send to be verified
  }

  let handleDoneMsgClose = () => {
    setDoneMsg(_ => false);
  }

  <Grid.Container>
    <Grid.Item xs={GridSize.size(8)}>
      <div className="box">
        // style={ReactDOM.Style.make(~margin="10px", ~padding="10px", ~border="1px solid black", ())}>
        <Grid.Item xs={GridSize.size(12)}>
          <Typography> {string(task.content)} </Typography>
          <Grid.Container>
            <Grid.Item xs={GridSize.size(6)}>
              {
                let due = switch(task.deadline){
                  |Some(d) => d->Js.Date.toString
                  |None => "N/A"
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
          <Grid.Item xs={GridSize.size(8)}>
          </Grid.Item>
          <Grid.Item xs={GridSize.size(4)}>
            { task.status == Claim ? 
            <Button
              color="primary" variant=Button.Variant.contained onClick={handleDoneMsgOpen}>
              {string("Done")}
            </Button> : {string("Task is being verified")}}
            <Snackbar _open={doneMsg} autoHideDuration={6000} onClose={handleDoneMsgClose}>
              <Alert onClose={handleDoneMsgClose} severity="info">
                  {string("Please wait for your task to be verified")}
              </Alert>
            </Snackbar>
          </Grid.Item>
        </Grid.Container>
      </div>
    </Grid.Item>
  </Grid.Container>
}
