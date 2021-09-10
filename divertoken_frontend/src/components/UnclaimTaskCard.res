open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t) => {

  let (voteText, setVoteText) = React.useState(_ => "Vote");

  let vote = (user: User.t, task: Task.t) => {
    let amount = 1
    task->Task.vote(amount, user, setVoteText)->ignore
  }

  let claim = (user: User.t, task: Task.t) => {
    task->Task.claim(user)->ignore
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
            <Button color="secondary" variant=Button.Variant.contained onClick={_ => claim(user,task)} >
              {string("Claim Task")}
            </Button>
          </Grid.Item>
          <Grid.Item xs={GridSize.size(4)}>
            <Button
              color="secondary" variant=Button.Variant.contained onClick={_ => vote(user, task)} >
              { Js.Dict.get(task.voted, user.id) == Some(0) || Js.Dict.get(task.voted, user.id) == None ?
              {string("Vote")} : {string("Unvote")} }
            </Button>
          </Grid.Item>
        </Grid.Container>
      </div>
    </Grid.Item>
  </Grid.Container>
}
