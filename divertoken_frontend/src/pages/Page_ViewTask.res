open React
open MaterialUI
open MaterialUI_Icon

open Data

module Popup = {
  @react.component
  let make = (~user: user, ~task: task, ~showVerify, ~setNotificationBadge, ~handleClose) => {
    let handleDecline = ignore // Handle decline

    let handleVerify = () => {
      // Handle notification
      setNotificationBadge(prev => prev + 1)
      Notification.allNotifications(task, Verified(user.email))

      // Give user token and change status
      Task.giveToken(user, task)
      task.id->Belt.Option.forEach(tId => Task.verifyByTaskId(tId)->ignore)
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
      `${user.displayName} will receive ${string_of_int(task.vote)} ` ++
      `${task.vote > 1 ? "tokens" : "token"}}`
    }
    let decliningTxt = {
      `Do you want to decline ${task.content}? ` ++
      `If everyone who voted has verified this task, ` ++
      `${user.displayName} will receive ${string_of_int(task.vote)} ` ++
      `${task.vote > 1 ? "tokens" : "token"}}`
    }

    <>
      <Typography id="modal-modal-description">
        {string(showVerify ? verifyingTxt : decliningTxt)}
      </Typography>
      <Grid.Container spacing={2}>
        <Grid.Item> {showVerify ? verifyBtn : declineBtn} </Grid.Item>
        <Grid.Item> cancelBtn </Grid.Item>
      </Grid.Container>
    </>
  }
}

// Page for when you press on the notication and it leads you to the task associated with it
@react.component
let make = (~user: user, ~taskId: string, ~setNotificationBadge) => {
  // For decline option
  let (openModal, setOpenModal) = React.useState(_ => false)
  let (showVerify, setShowVerify) = React.useState(_ => false)

  let handleOpen = () => setOpenModal(_ => true)
  let handleClose = () => setOpenModal(_ => false)

  let onNotification = () => Routes.push(Notification)

  let tasks = React.useContext(Context_Tasks.context)

  let optionTask = tasks->Belt.Array.getBy(t => t.id == Some(taskId))

  let statusToString = (status: Task.status) => {
    switch status {
    | Claim(_) => "Claimed"
    | Done(_) => "Done"
    | DoneAndVerified(_) => "Done and verified"
    | Open => "Open"
    }
  }

  switch optionTask {
  | Some(task) =>
    let handleModal = (modalType: int, evt) => {
      ReactEvent.Synthetic.preventDefault(evt)

      // Verify
      if modalType == 0 {
        setShowVerify(_ => true)
      } else {
        // Decline
        setShowVerify(_ => false)
      }
      handleOpen()
    }

    <>
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
              <Grid.Container spacing={2}>
                <Grid.Item>
                  <Button variant=Button.Variant.contained color="primary" onClick={0->handleModal}>
                    {string("Verify")}
                  </Button>
                </Grid.Item>
                <Grid.Item>
                  <Button
                    variant=Button.Variant.contained color="secondary" onClick={1->handleModal}>
                    {string("Decline")}
                  </Button>
                </Grid.Item>
              </Grid.Container>
              <Modal _open={openModal} onClose={handleClose}>
                <div
                  style={ReactDOM.Style.make(
                    ~position="absolute",
                    ~backgroundColor="#FFFFFF",
                    ~top="50%",
                    ~left="50%",
                    ~transform="translate(-50%, -50%)",
                    ~width="400",
                    ~borderRadius="3px 3px",
                    (),
                  )}>
                  <Box p={4}>
                    <Typography id="modal-modal-title" variant=Typography.Variant.h6 component="h2">
                      {showVerify == false ? {string("Decline Task")} : {string("Verify Task")}}
                    </Typography>
                    <div style={ReactDOM.Style.make(~padding="20px 0px 30px 0px", ())}>
                      <Popup user task showVerify setNotificationBadge handleClose />
                    </div>
                  </Box>
                </div>
              </Modal>
            </div>
          | _ => <div />
          }}
        </div>
      </Grid.Container>
    </>

  | None => string("")
  }
}
