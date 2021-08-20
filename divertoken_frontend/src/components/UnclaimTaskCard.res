open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~task: Task.t) => {
  let vote = (user: User.t, task: Task.t) => {
    let amount = 1
    task->Task.vote(amount, user)->ignore
  }

  <Grid.Container>
    <Grid.Item xs={GridSize.size(8)}>
      <Box className="box">
        // style={ReactDOM.Style.make(~margin="10px", ~padding="10px", ~border="1px solid black", ())}>
        <Grid.Item xs={GridSize.size(12)}>
          <Typography> {string(task.content)} </Typography>
          <Grid.Container>
            <Grid.Item xs={GridSize.size(6)}>
              <Typography> {string("Deadline: ")} </Typography>
            </Grid.Item>
            <Grid.Item xs={GridSize.size(6)}>
              <Typography> {string("Votes: " ++ string_of_int(task.vote))} </Typography>
            </Grid.Item>
          </Grid.Container>
        </Grid.Item>
        <Grid.Container>
          <Grid.Item xs={GridSize.size(8)}>
            <Button color="secondary" variant=Button.Variant.contained>
              {string("Claim Task")}
            </Button>
          </Grid.Item>
          <Grid.Item xs={GridSize.size(4)}>
            <Button
              color="secondary" variant=Button.Variant.contained onClick={_ => vote(user, task)}>
              {string("Vote")}
            </Button>
          </Grid.Item>
        </Grid.Container>
      </Box>
    </Grid.Item>
  </Grid.Container>
}
