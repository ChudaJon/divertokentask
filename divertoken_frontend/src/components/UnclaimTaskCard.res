open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t, ~notificationBadge, ~setNotificationBadge) => {
  // For Popup delete
  let (openModal, setOpenModal) = React.useState(_ => false)
  let handleOpen = () => setOpenModal(_ => true)
  let handleClose = () => setOpenModal(_ => false)

  let vote = (user: User.t, task: Task.t) => {
    let amount = 1
    task->Task.vote(amount, user)->ignore
  }

  let claim = (user: User.t, task: Task.t) => {
    task->Task.claim(user)->ignore
    task->Notification.allNotifications(user, Claimed)->ignore
    setNotificationBadge(_ => notificationBadge + 1)
  }

  let handleModal = (user: User.t, task: Task.t) => {
    // Check vote count
    if task.vote == 1 {
      handleOpen()
    } else {
      vote(user, task)
    }
  }

  let handleDelete = (user: User.t, task: Task.t) => {
    handleClose()
    vote(user, task)
  }

  useEffect1(() => {
    None
  }, [notificationBadge])

  <div style={ReactDOM.Style.make(~display="flex", ())}>
    <Grid.Container>
      <div style={ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ())}>
        // <Grid.Item xs={GridSize.size(8)}>
        <div
          className="box"
          style={ReactDOM.Style.make(
            ~margin="10px",
            ~padding="15px 25px",
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
              <div style={ReactDOM.Style.make(~margin="auto", ())}>
                <Typography> {string("Votes: " ++ string_of_int(task.vote))} </Typography>
              </div>
            </Grid.Container>
          </Grid.Item>
          <div style={ReactDOM.Style.make(~padding="10px", ())}>
            <Grid.Container>
              <Grid.Item xs={GridSize.size(6)}>
                <Button
                  color="secondary"
                  variant=Button.Variant.contained
                  onClick={_ => claim(user, task)}>
                  {string("Claim Task")}
                </Button>
              </Grid.Item>
              <div style={ReactDOM.Style.make(~margin="auto", ())}>
                <Grid.Item xs={GridSize.size(4)}>
                  {Js.Dict.get(task.voted, user.id) == Some(0) ||
                    Js.Dict.get(task.voted, user.id) == None
                    ? <Button
                        color="secondary"
                        variant=Button.Variant.contained
                        onClick={_ => vote(user, task)}>
                        {string("Vote")}
                      </Button>
                    : <Button
                        color="secondary"
                        variant=Button.Variant.contained
                        onClick={_ => handleModal(user, task)}>
                        {string("Unvote")}
                      </Button>}
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
                        <Typography
                          id="modal-modal-title" variant=Typography.Variant.h6 component="h2">
                          {string("Task will be deleted")}
                        </Typography>
                        <div style={ReactDOM.Style.make(~padding="20px 0px 30px 0px", ())}>
                          <Typography id="modal-modal-description">
                            {string(
                              "This task has only 1 vote left, if you unvote it, it will be automatically deleted",
                            )}
                          </Typography>
                        </div>
                        <Grid.Container spacing={2}>
                          <Grid.Item xs={GridSize.size(6)}>
                            <Button
                              color="primary"
                              variant=Button.Variant.contained
                              onClick={_ => handleDelete(user, task)}>
                              {string("Delete Task")}
                            </Button>
                          </Grid.Item>
                          <Grid.Item xs={GridSize.size(6)}>
                            <Button
                              color="secondary"
                              variant=Button.Variant.contained
                              onClick={_ => handleClose()}>
                              {string("Cancel")}
                            </Button>
                          </Grid.Item>
                        </Grid.Container>
                      </Box>
                    </div>
                  </Modal>
                </Grid.Item>
              </div>
            </Grid.Container>
          </div>
          // </Grid.Item>
        </div>
      </div>
    </Grid.Container>
  </div>
}
