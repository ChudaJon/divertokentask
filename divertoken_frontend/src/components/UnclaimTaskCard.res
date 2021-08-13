open React
open MaterialUI
open MaterialUIDataType

@module("/src/styles/UnclaimTaskCard.css") external styles: 'a = "default"

@react.component
let make = (~content, ~setTokenCoin) => {
  let (vote, setVote) = React.useState(() => 0)

  <Grid.Container>
    <Box className={"border: 3px solid gray"}>
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
    </Box>
  </Grid.Container>
}
