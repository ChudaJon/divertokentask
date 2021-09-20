open React
open MaterialUI
open MaterialUIDataType
open MaterialUI_Icon
open MaterialUI_IconButton

// Page for when you press on the notication and it leads you to the task associated with it
@react.component
let make = (~user: User.t, ~taskId: string, ~notificationBadge, ~setNotificationBadge) => {

    let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))

    // Send notification for verified task & change status in Your Tasks
    let handleVerify = () => {
    //   Notification.handlePressVerify(user, notification)
      Task.verifyByTaskId(taskId) -> ignore
      setNotificationBadge(_ => notificationBadge+1)
    }

    // let handleNotitype = () => {
    //     switch notification.notiType {
    //         | Claimed => "Claimed"
    //         | VerifyWait => "Waiting on Verification"
    //         | Verify => "Ready to be Verified"
    //         | Done => "Verification and Task complete"
    //     }
    // }

    // let handleNotifcationId = () => {
    //     switch notification.id {
    //         |Some(notificationId) => notificationId
    //         |None => ""
    //     }
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
                        <Typography variant=Typography.Variant.h4> {string("taskId= " ++ taskId)} </Typography>
                        <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                            <Typography variant=Typography.Variant.h6> {string("notitype= " /*++ handleNotitype()*/)} </Typography>
                        </div>
                        <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                            <Typography variant=Typography.Variant.h6> {string("notificationID=" /*++ handleNotifcationId()*/)} </Typography>
                        </div>
                        // { notification.notiType == Verify ?
                        <div style={ReactDOM.Style.make(~padding="30px 0px 0px", ())}>
                            <Button variant=Button.Variant.contained color="primary" onClick={_=> handleVerify()} >{string("Verify")}</Button>
                        </div> 
                        // : <div />
                        // }
                    </div>
                </div>
            </Grid.Container>
        </div>
    </div>

}