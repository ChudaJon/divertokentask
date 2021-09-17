open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t) => {

  let vote = (user: User.t, task: Task.t) => {
    let amount = 1
    task->Task.vote(amount, user)->ignore
  }

  let claim = (user: User.t, task: Task.t) => {
    task->Task.claim(user)->ignore
    task->Notification.allNotifications(user, Claimed)->ignore
  }

  <div style=(ReactDOM.Style.make(~display="flex", ()))>
    <Grid.Container>
      <div style=(ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ()))>
      // <Grid.Item xs={GridSize.size(8)}>
        <div className="box"
          style={ReactDOM.Style.make(~margin="10px", ~padding="15px 25px", ~backgroundColor="#FFFFFF", ~borderRadius="3px 3px", ())}>
          <Grid.Item xs={GridSize.size(12)}>
            <div style=(ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ()))>
              <Typography variant=Typography.Variant.h5> {string(task.content)} </Typography>
            </div>
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
              <div style=(ReactDOM.Style.make(~margin="auto", ()))>
                // <Grid.Item xs={GridSize.size(4)}>
                  <Typography> {string("Votes: " ++ string_of_int(task.vote))} </Typography>
                // </Grid.Item>
              </div>
            </Grid.Container>
          </Grid.Item>
          <div style=(ReactDOM.Style.make(~padding="10px", ()))>
            <Grid.Container>
              <Grid.Item xs={GridSize.size(6)}>
                <Button color="secondary" variant=Button.Variant.contained onClick={_ => claim(user,task)} >
                  {string("Claim Task")}
                </Button>
              </Grid.Item>
              <div style=(ReactDOM.Style.make(~margin="auto", ()))>
                <Grid.Item xs={GridSize.size(4)}>
                  <Button
                    color="secondary" variant=Button.Variant.contained onClick={_ => vote(user, task)} >
                    { Js.Dict.get(task.voted, user.id) == Some(0) || Js.Dict.get(task.voted, user.id) == None ?
                    {string("Vote")} : {string("Unvote")} }
                  </Button>
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
