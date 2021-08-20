open React
open Routes
open Promise

@react.component
let make = () => {
  let (tasks, setTasks) = useState(() => list{})
  let (maybeUser, setUser) = useState(() => None)

  useEffect0(() => {
    User.login("user", "pass")
    ->then((user: User.t) => {
      setUser(_ => Some(user))
      resolve()
    })
    ->ignore

    None
  })

  let url = RescriptReactRouter.useUrl()

  let onUnclaimedTask = () => RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
  let onTaskList = () => RescriptReactRouter.push(Routes.route2Str(TaskList))
  let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))

  switch maybeUser {
  | None => <div> {string("Please Login")} </div>
  | Some(user) =>
    <div>
      <p> {string(`You have  ${Js.Int.toString(user.token)} token`)} </p>
      {switch url->Routes.url2route {
      | Register => <Register />
      | UnclaimTask => <UnclaimTask user/>
      | TaskList => <TaskList />
      | Notification => <Notification />
      | AddTask => <AddTask setTasks />
      }}
      <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button>
      <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
      <button onClick={_ => onNotification()}> {string("Notification")} </button>
    </div>
  }
}
