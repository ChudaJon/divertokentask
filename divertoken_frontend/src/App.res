open React
open Routes
open Promise

@react.component
let make = () => {
  let (tasks, setTasks) = useState(() => list{})
  let (maybeUser, setUser) = useState(() => None)
  let (auth, setAuth) = useState(() => "proto-user-0")

  let onData = (id:option<string>, data:Js.Json.t) => {
    let user = data->User.Codec.fromJson(id,_);
    setUser(_=> Some(user))
  };

  useEffect1(()=>{
    let stopListen = Firebase.Divertask.listenToPath(`users/${auth}`, ~eventType=#value, ~onData,())

    Some(stopListen)
  },[auth])

  let url = RescriptReactRouter.useUrl()

  let onUnclaimedTask = () => RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
  let onTaskList = () => RescriptReactRouter.push(Routes.route2Str(TaskList))
  let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))

  switch maybeUser {
  | None => <div> {string("Please Login")} </div>
  | Some(user) =>
    <div>
      {switch url->Routes.url2route {
      | Register => <Register />
      | UnclaimTask => 
        <div> 
          <p> {string(`You have  ${Js.Int.toString(user.token)} token`)} </p> <UnclaimTask user/>
          <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button> 
          <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
          <button onClick={_ => onNotification()}> {string("Notification")} </button>
        </div>
      | TaskList => 
        <div> 
          <p> {string(`You have  ${Js.Int.toString(user.token)} token`)} </p> <TaskList user/> 
          <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button>
          <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
          <button onClick={_ => onNotification()}> {string("Notification")} </button>
        </div>
      | Notification => 
        <div> <Notification />          
          <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button>
          <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
          <button onClick={_ => onNotification()}> {string("Notification")} </button>
        </div>
      | AddTask => 
        <div> <p> {string(`You have  ${Js.Int.toString(user.token)} token`)} </p> <AddTask setTasks user/>
          <button onClick={_ => onUnclaimedTask()}> {string("Unclaimed")} </button>
          <button onClick={_ => onTaskList()}> {string("Your Task")} </button>
          <button onClick={_ => onNotification()}> {string("Notification")} </button>
        </div>
      }}
    </div>
  }
}
