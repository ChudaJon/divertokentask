open React
open MaterialUI
open MaterialUI_Icon

open Data

type popUpType = Verify | Decline
type popUpState = Hidden | Show(popUpType)
type verifyStatus = Initial | Success | Failed

module Popup = {
  @react.component
  let make = (
    ~popUpState,
    ~verifier: user,
    ~doer: user,
    ~task: task,
    ~setNotificationBadge,
    ~handleClose,
    ~handleVerifyMsgOpen,
    ~setVerifyMsgStatus,
  ) => {
    let handleDecline = () => {
      TaskApi.declineTask(task, verifier)->Js.log
    } // Handle decline

    let handleVerify = () => {
      // Handle notification
      setNotificationBadge(prev => prev + 1)
      Notification.allNotifications(
        task,
        Verified(verifier.email),
        [verifier.id, doer.id]->Belt.Array.concat(task.voted->Js.Dict.keys),
      )

      // Give user token and change status
      // Task.giveToken(doer, task)
      TaskApi.verifyTask(task, verifier)
      ->Superagent.then(res => {
        handleVerifyMsgOpen()
        if res.statusCode == 200 {
          setVerifyMsgStatus(_ => Success)
        } else {
          setVerifyMsgStatus(_ => Failed)
        }
        Js.log3("Task is being verified", res.statusCode, res)
      })
      ->ignore
      // ->Superagent.catch(res => Js.log2("veri error:: ", res))
      // task.id->Belt.Option.forEach(tId => Task.verifyByTaskId(tId)->ignore)
    }

    let verifyBtn =
      <Button color="primary" variant=Button.Variant.contained onClick={_ => handleVerify()}>
        {string("Verify")}
      </Button>
    let declineBtn =
      <Button color="primary" variant=Button.Variant.contained onClick={_ => handleDecline()}>
        {string("Decline")}
      </Button>
    let cancelBtn =
      <Button color="secondary" variant=Button.Variant.contained onClick={_ => handleClose()}>
        {string("Cancel")}
      </Button>

    let verifyingTxt = {
      `Do you want to verify ${task.content} ? ` ++
      `If everyone who voted has verified this task, ` ++
      `${doer.displayName} will receive ${string_of_int(task.vote)} ` ++
      `${task.vote > 1 ? "tokens" : "token"}}`
    }
    let decliningTxt = {
      `Do you want to decline ${task.content}? ` ++
      `If everyone who voted has verified this task, ` ++
      `${doer.displayName} will receive ${string_of_int(task.vote)} ` ++
      `${task.vote > 1 ? "tokens" : "token"}}`
    }

    let cardStle = ReactDOM.Style.make(
      ~position="absolute",
      ~backgroundColor="#FFFFFF",
      ~top="50%",
      ~left="50%",
      ~transform="translate(-50%, -50%)",
      ~width="50%",
      ~borderRadius="3px 3px",
      (),
    )

    <Modal _open={popUpState != Hidden} onClose=handleClose>
      <Paper style=cardStle>
        <Box p=4>
          <Typography id="modal-modal-title" variant=Typography.Variant.h6 component="h2">
            {string(popUpState == Show(Verify) ? "Verify Task" : "Decline Task")}
          </Typography>
          <div style={ReactDOM.Style.make(~padding="20px 0px 30px 0px", ())}>
            <Typography id="modal-modal-description">
              {string(popUpState == Show(Verify) ? verifyingTxt : decliningTxt)}
            </Typography>
            <Grid.Container spacing={2}>
              <Grid.Item> {popUpState == Show(Verify) ? verifyBtn : declineBtn} </Grid.Item>
              <Grid.Item> cancelBtn </Grid.Item>
            </Grid.Container>
          </div>
        </Box>
      </Paper>
    </Modal>
  }
}

// Page for when you press on the notication and it leads you to the task associated with it
@react.component
let make = (~user: user, ~taskId: string, ~setNotificationBadge) => {
  let tasks = React.useContext(Context_Tasks.context)
  let (popUpState, setPopUpState) = React.useState(_ => Hidden)

  let onNotification = () => Routes.push(Notification)
  let optionTask = tasks->Belt.Array.getBy(t => t.id == Some(taskId))

  let onClickVerify = _ => setPopUpState(_ => Show(Verify))
  let onClickDecline = _ => setPopUpState(_ => Show(Decline))
  let onClosePopUp = _ => setPopUpState(_ => Hidden)
  let (doer, setDoer) = useState(_ => user)

  let (verifyMsg, setVerifyMsg) = useState(_ => false)
  let (verifyMsgStatus, setVerifyMsgStatus) = useState(_ => Initial)

  let verifyStatusTostr = (status: verifyStatus) => {
    switch status {
    | Success => "successful"
    | Failed => "failed"
    | _ => ""
    }
  }

  let verifySeverity = (status: verifyStatus) => {
    switch status {
    | Success => "success"
    | Failed => "error"
    | _ => "info"
    }
  }

  let handleVerifyMsgOpen = () => setVerifyMsg(_ => true)
  let handleVerifyMsgClose = () => setVerifyMsg(_ => false)

  let statusToString = (status: Task.status) => {
    switch status {
    | Claim(_) => "Claimed"
    | Done(_) => "Done"
    | DoneAndVerified(_) => "Done and verified"
    | Open => "Open"
    }
  }

  React.useEffect1(() => {
    open Firebase.Divertask

    let retrieveDoer = userId => {
      let path = `users/${userId}`
      let onUserOfTask = (_id, data) => {
        switch Data.User.Codec.fromJson(Some(userId), data) {
        | Some(u) => setDoer(_ => u)
        | None => Js.log("No user")
        }
      }

      Some(listenToPath(path, ~eventType=#value, ~onData=onUserOfTask, ()))
    }

    switch optionTask {
    | Some({status: Claim(userId) | Done(userId)}) => retrieveDoer(userId)
    | _ => None
    }
  }, [optionTask])

  switch optionTask {
  | Some(task) => <>
      <div style={ReactDOM.Style.make(~margin="auto", ~display="flex", ~padding="3px 30px", ())}>
        <IconButton onClick={_ => onNotification()}> <ArrowBackIos /> </IconButton>
      </div>
      <Grid.Container>
        <div
          className="box"
          style={ReactDOM.Style.make(
            ~margin="10px",
            ~padding="30px 0px 100px 30px",
            ~backgroundColor="#FFFFFF",
            ~borderRadius="3px 3px",
            (),
          )}>
          <Typography variant=Typography.Variant.h4> {string(task.content)} </Typography>
          <Typography variant=Typography.Variant.h6>
            {string(`status: ${statusToString(task.status)}`)}
          </Typography>
          {switch task.status {
          | Done(_doneBy) =>
            <div>
              <Grid.Container spacing=2>
                <Grid.Item>
                  <Button variant=Button.Variant.contained color="primary" onClick=onClickVerify>
                    {string("Verify")}
                  </Button>
                </Grid.Item>
                <Grid.Item>
                  <Button variant=Button.Variant.contained color="secondary" onClick=onClickDecline>
                    {string("Decline")}
                  </Button>
                </Grid.Item>
                <Popup
                  verifier=user
                  doer
                  task
                  setNotificationBadge
                  popUpState
                  handleClose=onClosePopUp
                  handleVerifyMsgOpen
                  setVerifyMsgStatus
                />
              </Grid.Container>
            </div>
          | _ => <div />
          }}
        </div>
        <Grid.Item>
          <Snackbar _open={verifyMsg} autoHideDuration={6000} onClose={handleVerifyMsgClose}>
            <Alert onClose={handleVerifyMsgClose} severity={verifySeverity(verifyMsgStatus)}>
              {string("Verify " ++ verifyStatusTostr(verifyMsgStatus))}
            </Alert>
          </Snackbar>
        </Grid.Item>
      </Grid.Container>
    </>

  | None => string("")
  }
}
