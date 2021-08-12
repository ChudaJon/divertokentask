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

  let onSave = ()=>{
    switch(taskContent) {
      |""=> ()
      |task => Task.addTask(task) -> ignore
    }
  }

  module Container = Grid.Container
  module Item = Grid.Item
  <Container>
    <Item> <TextField label="Task..." value=taskContent onChange /> </Item>
    <Item>
      <Button
        color="primary"
        variant=Button.Variant.contained
        onClick={_ => {
          onUnclaimedTask()
          // setTasks(prevTasks => List.append(prevTasks, list{taskContent}))
          onSave()
        }}>
        {string("Save")}
      </Button>
    </Item>
  </Container>
}
