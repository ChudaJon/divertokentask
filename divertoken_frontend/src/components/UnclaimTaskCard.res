open React
open MaterialUI
open MaterialUIDataType

// @module("/src/styles/UnclaimTaskCard.css") external styles: 'a = "default"

%%raw("require('../styles/main.css')")

@react.component
let make = (~user: User.t, ~task: Task.t) => {
  let vote = (user: User.t, task: Task.t) => {
    let amount = 1
    task->Task.vote(amount, user)->ignore
  }

  <Grid.Container>
    <Grid.Item xs={GridSize.size(8)}>
      <div className="box">
        // style={ReactDOM.Style.make(~margin="10px", ~padding="10px", ~border="1px solid black", ())}>
        <Grid.Item xs={GridSize.size(12)}>
          <Typography> {string(content)} </Typography>
          <Grid.Container>
            <Grid.Item xs={GridSize.size(6)}>
              <Typography> {string("Deadline: ")} </Typography>
            </Grid.Item>
            <Grid.Item xs={GridSize.size(6)}>
              <Typography> {string("Votes: " ++ string_of_int(vote))} </Typography>
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
              color="secondary"
              variant=Button.Variant.contained
              onClick={_ => {
                setVote(_ => vote + 1)
                setTokenCoin(prev => prev - 1)
              }}>
              {string("Vote")}
            </Button>
          </Grid.Item>
        </Grid.Container>
      </div>
    </Grid.Item>
  </Grid.Container>
}
