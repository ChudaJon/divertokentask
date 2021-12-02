open React
open MaterialUI
open MaterialUIDataType
open Data
@module("/src/styles/Page_AddTask.module.scss") external styles: 'a = "default"

@react.component
let make = (~user) => {
  let (taskContent, setTaskContent) = React.useState(() => "")
  let (dueDate, setDueDate) = React.useState(() => Js.Date.make())

  let onUnclaimedTask = () => Routes.push(UnclaimTask)
  let onChange = (e: ReactEvent.Form.t): unit => {
    let value = (e->ReactEvent.Form.target)["value"]
    setTaskContent(value)
  }

  let onSave = () => {
    switch taskContent {
    | "" => ()
    | task => task->Task.createTask(~deadline=dueDate, ~user)->Task.addTask(user)->ignore
    }
  }

  module Container = Grid.Container
  module Item = Grid.Item
  <div>
    <div className={styles["add-task-card"]}>
      <Box p={4}>
        <div style={ReactDOM.Style.make(~margin="0 auto", ())}>
          <Container spacing=2>
            <Item xs={GridSize.size(12)}>
              <div>
                <Picker.UtilsProvider utils=Picker.dateFns>
                  <DatePicker
                    autoOk=true
                    disablePast=true
                    label="Due Date"
                    className="date-picker"
                    format="dd-MM-yyyy HH:mm"
                    showTodayButton=true
                    value=dueDate
                    onChange={newDate => setDueDate(_ => newDate)}
                    views=[MaterialUI_DatePicker.DateView.date, "hours", "minutes"]
                  />
                </Picker.UtilsProvider>
              </div>
            </Item>
            <Item xs={GridSize.size(12)}>
              <TextField
                size="small"
                required=true
                variant=TextField.Variant.outlined
                label="Task name"
                value=taskContent
                onChange
                rows={"1"}
                multiline=true
              />
            </Item>
            <Item xs={GridSize.size(12)}>
              <div
                style={ReactDOM.Style.make(
                  ~display="flex",
                  ~justifyContent="center",
                  ~padding="30px 0px 20px 0px",
                  (),
                )}>
                <Button
                  color="primary"
                  variant=Button.Variant.contained
                  onClick={_ => {
                    onUnclaimedTask()
                    onSave()
                  }}>
                  {string("Add Task")}
                </Button>
              </div>
            </Item>
          </Container>
        </div>
      </Box>
    </div>
  </div>
}
