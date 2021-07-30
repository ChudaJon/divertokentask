open React
open MaterialUI

@react.component
let make = (~setTasks) => {
  let (taskContent, setTaskContent) = React.useState(() => "")
  let onUnclaimedTask = () => RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
  let onChange = (e: ReactEvent.Form.t): unit => {
    let value = (e->ReactEvent.Form.target)["value"]
    setTaskContent(value)
  }

  <Grid.Container>
    <Grid.Item> <TextField label="Task..." value=taskContent onChange /> </Grid.Item>
    <Grid.Item>
      <Button
        color="primary"
        variant=Button.Variant.contained
        onClick={_ => {
          onUnclaimedTask()
          setTasks(prevTasks => \"@"(prevTasks, list{taskContent}))
        }}>
        {string("Save")}
      </Button>
    </Grid.Item>
  </Grid.Container>
}
