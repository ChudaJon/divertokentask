open React
open MaterialUI

@react.component
let make = (~setTasks) => {
  let (taskContent, setTaskContent) = React.useState(() => "")
  let (dueDate, setDueDate) = React.useState(() => Js.Date.make())

  let onUnclaimedTask = () => RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
  let onChange = (e: ReactEvent.Form.t): unit => {
    let value = (e->ReactEvent.Form.target)["value"]
    setTaskContent(value)
  }

  let onSave = ()=>{
    switch(taskContent) {
      |""=> ()
      |task => {
        task
        -> Task.createTask(~deadline=dueDate)
        -> Task.addTask
        -> ignore
      }
    }
  }

  module Container = Grid.Container
  module Item = Grid.Item
  <Container>
    <Item>
      <Picker.UtilsProvider utils=Picker.dateFns>
        <DatePicker
          autoOk=true
          disablePast=true
          label="Due"
          className="date-picker"
          format="dd-MM-yyyy HH:mm"
          showTodayButton=true
          value=dueDate
          onChange={newDate=>setDueDate(_=>newDate)}
          views=[
            MaterialUI_DatePicker.DateView.date,
            "hours",
            "minutes",
          ]
        />
      </Picker.UtilsProvider>
    </Item>
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
