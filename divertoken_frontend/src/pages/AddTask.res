open React

@react.component
let make = (~setTasks) => {
  let (taskContent, setTaskContent) = React.useState(() => "")
  let onUnclaimedTask = () => ReasonReactRouter.push(Routes.route2Str(UnclaimTask))
  let onChange = (e: ReactEvent.Form.t): unit => {
    let value = (e->ReactEvent.Form.target)["value"]
    setTaskContent(value)
  }

  <div>
    <input type_="text" value=taskContent onChange />
    <button
      onClick={_ => {
        onUnclaimedTask()
        setTasks(prevTasks => \"@"(prevTasks, list{taskContent}))
      }}>
      {string("Save")}
    </button>
  </div>
}
