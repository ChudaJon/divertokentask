open React
open MaterialUI
open MaterialUIDataType
open MaterialUI_Icon
open MaterialUI_IconButton

// Page for when you press on the notication and it leads you to the task associated with it
@react.component
let make = (~user: User.t, /*~notification: Notification.t, */~notificationBadge, ~setNotificationBadge/*~task: Task.t */) => {

    let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))

    // Send notification for verified task & change status in Your Tasks
    // let handleVerify = () => {
    //   Notification.handlePressVerify(user, notification)
    //   switch(notification.task_id){
    //     |Some(taskId) =>  Task.verifyByTaskId(taskId) -> ignore
    //     |None => ()
    //   }
    //   setNotificationBadge(_ => notificationBadge+1)
    //   Js.log2("verify", notificationBadge)
    // }

    // let handleOption = () => {
    //     switch(notification.task_id){
    //     |Some(taskId) => taskId
    //     |None => ""
    //   }
    // }

    <div>
        <div style={ReactDOM.Style.make(~margin="auto", ~display="flex", ~padding="3px 30px", ())}>
            <IconButton onClick={_ => onNotification()}>
                <ArrowBackIos />
            </IconButton>
        </div>
        <div style={ReactDOM.Style.make(~display="flex", ())}>
            <Grid.Container>
                <div style=(ReactDOM.Style.make(~margin="auto", ~padding="30px", ~width="50%", ~display="block", ()))>
                    <div className="box" style={ReactDOM.Style.make(~margin="10px", ~padding="30px 0px 200px 30px", ~backgroundColor="#FFFFFF", ~borderRadius="3px 3px",())}>
                        <Typography variant=Typography.Variant.h4> {string("Title/ID of Task")} </Typography>
                        <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                            <Typography variant=Typography.Variant.h6> {string("handleOption()")} </Typography>
                        </div>
                        <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                            <Typography variant=Typography.Variant.h6> {string("Maybe some info/picture about the verification ")} </Typography>
                        </div>
                        <div style={ReactDOM.Style.make(~padding="30px 0px 0px", ())}>
                          <Button variant=Button.Variant.contained color="primary" /*onClick={_=> handleVerify()}*/ >{string("Verify")}</Button>
                        </div>
                    </div>
                </div>
            </Grid.Container>
        </div>
    </div>

}