open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~notification: Notification.t) => {

    // Switch to which type of notification
    let notificationSwitch = () => {
      switch notification.notiType {
        | Claimed => {string("Your task has been claimed")}
        | VerifyWait => {string("Your task is being verified")}
        | Verify => {string("A task that you voted for is completed, you can verify it now")}
        | Done => {string("Your task has been verified")}
      }
    }

    // Send notification for verified task & change status in Your Tasks
    let handleVerify = () => {
      // Firebase.Divertask.child("tasks").child(notification.task_id).get().then(snapshot => ...)
      let stopListen = Firebase.Divertask.listenToPath({"/task/" ++ Js.String2.make(notification.task_id)}, ~eventType=#value, ())
      Js.log2("value", stopListen)
      Notification.handlePressVerify(user, notification)
      // task->Notification.allNotifications(user, Done)->ignore
      ()
    }

    <div style=(ReactDOM.Style.make(~display="flex", ()))>
    <Grid.Container>
      <div style=(ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ()))>
        <div className="box"
          style={ReactDOM.Style.make(~margin="10px", ~padding="15px 25px", ~backgroundColor="#FFFFFF", ())}>
          <Grid.Item xs={GridSize.size(12)}>
            <div style=(ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ()))>
                {
                  switch(notification.notiType){
                    | Claimed => 
                      <Typography variant=Typography.Variant.h6>
                        {string("Your task has been claimed")}
                      </Typography>
                    | VerifyWait => 
                      <Typography variant=Typography.Variant.h6>
                        {string("Your task is being verified")}
                      </Typography>
                    | Verify => 
                      <div>
                        <Typography variant=Typography.Variant.h6>
                          {string("A task that you voted for is completed, you can verify it now")}
                        </Typography>
                        <div style={ReactDOM.Style.make(~padding="10px 0px 0px", ())}>
                          <Button variant=Button.Variant.contained color="primary" onClick={_=> handleVerify()} >{string("Verify")}</Button>
                        </div>
                      </div>
                    | Done =>
                      <Typography variant=Typography.Variant.h6>
                        {string("Your task has been verified")}
                      </Typography>
                  }
                }
            </div>
          </Grid.Item>
        </div>
      </div>
    </Grid.Container>
  </div>
}
