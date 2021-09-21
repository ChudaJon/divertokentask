open React
open MaterialUI
open MaterialUI_Icon

// Page for when you press on the notication and it leads you to the task associated with it
@react.component
let make = (~user: User.t, ~taskId: string, ~notificationBadge, ~setNotificationBadge) => {

    let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))

    let allTasks = React.useContext(Context_Tasks.context)

    let optionTask = allTasks->Belt.List.getBy( t => t.id == Some(taskId));

    let statusToString = (status: Divertoken.Task.status) => {
        switch status{
        | Claim => "Claimed"
        | Done => "Done"
        | DoneAndVerified => "Done and verified"
        | Open => "Open"
        }
    }

    // For snackbar alert
    // let (doneMsg, setDoneMsg) = useState(_ => false)

    // let handleDoneMsgClose = () => {
    //     setDoneMsg(_ => false);
    // }

    switch (optionTask){
        | Some(task) => 
        <>{
            // Send notification for verified task & change status in Your Tasks
            let handleVerify = (evt) => {

                // For snackbar alert
                ReactEvent.Synthetic.preventDefault(evt);
                // setDoneMsg(_ => true)
                // Verify task
                // Add Notification
                setNotificationBadge(_ => notificationBadge+1)
                Notification.allNotifications(task, user, Done)
                // Give user token
                Task.giveToken(user, task)
                Task.verifyByTaskId(taskId) -> ignore
            }

            <div>
                <div style={ReactDOM.Style.make(~margin="auto", ~display="flex", ~padding="3px 30px", ())}>
                    <IconButton onClick={_ => onNotification()}>
                        <ArrowBackIos />
                    </IconButton>
                </div>
                <div style={ReactDOM.Style.make(~display="flex", ())}>
                    <Grid.Container>
                    <div style=(ReactDOM.Style.make(~margin="auto", ~padding="30px", ~width="50%", ~display="block", ()))>
                        <div className="box" style={ReactDOM.Style.make(~margin="10px", ~padding="30px 0px 100px 30px", ~backgroundColor="#FFFFFF", ~borderRadius="3px 3px",())}>
                            <Typography variant=Typography.Variant.h4> {string(task.content)} </Typography>
                            <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                                <Typography variant=Typography.Variant.h6> {string("taskId= " ++ taskId)} </Typography>
                            </div>
                            <div style=(ReactDOM.Style.make(~padding="30px 0px 0px 0px", ()))>
                                <Typography variant=Typography.Variant.h6> {string("status= " ++ statusToString(task.status))} </Typography>
                            </div>
                            { 
                            switch(task.status){
                                |Done =>
                                    <div>
                                        <div style={ReactDOM.Style.make(~padding="30px 0px 0px", ())}>
                                            <Button variant=Button.Variant.contained color="primary" onClick={handleVerify} >{string("Verify")}</Button>
                                        </div>
                                        // Does not work because when task updates page refreshes

                                        // <Snackbar _open={doneMsg} autoHideDuration={6000} onClose={handleDoneMsgClose}>
                                        //     <Alert onClose={handleDoneMsgClose} severity="info">
                                        //         {
                                        //             switch task.vote {
                                        //                 | 1 => {string("You have received " ++ string_of_int(task.vote) ++ " token!")}
                                        //                 | _ => {string("You have received " ++ string_of_int(task.vote) ++ " tokens!")}
                                        //             }
                                        //         }
                                        //     </Alert>
                                        // </Snackbar>
                                    </div>
                                | _ => <div> </div>
                            }
                        }
                        </div>
                    </div>
                    </Grid.Container>
                </div>
            </div>

        }
        </>
        | None => {string("")}
    }
}