open React
open Routes
open Promise
open MaterialUI
open MaterialUIDataType

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

  let switchTab = 
  <div> 
    <Grid.Container spacing=3>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => onUnclaimedTask()} fullWidth=true>
          <Typography variant=Typography.Variant.h6>{string("Unclaimed Tasks")}</Typography>
        </Button>
      </Grid.Item>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => onTaskList()} fullWidth=true> 
          <Typography variant=Typography.Variant.h6>{string("Your Tasks")}</Typography>
        </Button>
      </Grid.Item>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => onNotification()} fullWidth=true>
          <Typography variant=Typography.Variant.h6>{string("Notifications")}</Typography>
        </Button>
      </Grid.Item>
    </Grid.Container>
  </div>

  switch maybeUser {
    
  | None => <div> {string("Please Login")} </div>
  | Some(user) =>
    let tokenCount = {user.token != 1 ? <div> {string(`You have  ${Js.Int.toString(user.token)} tokens`)} </div> :  <div>{string(`You have  ${Js.Int.toString(user.token)} token`)}</div>}
    <div>
      {switch url->Routes.url2route {
      | Register => <Register />
      | UnclaimTask => 
        <div>
          <div style=(ReactDOM.Style.make(~padding="10px", ()))> 
            <Grid.Container>
              <Grid.Item xs={GridSize.size(12)}>
                <Grid.Container justify=Justify.center spacing=10>
                  <Grid.Item>
                    <Typography variant=Typography.Variant.h5>{string("Unclaimed Tasks")}</Typography> 
                  </Grid.Item>
                  <Grid.Item>
                    <Typography variant=Typography.Variant.h6>tokenCount</Typography>
                  </Grid.Item>
                </Grid.Container>
              </Grid.Item>  
            </Grid.Container>
          </div>
          <UnclaimTask user/>
          switchTab
        </div>
      | TaskList => 
        <div>
          <div style=(ReactDOM.Style.make(~padding="10px", ()))> 
              <Grid.Container>
                <Grid.Item xs={GridSize.size(12)}>
                  <Grid.Container justify=Justify.center spacing=10>
                    <Grid.Item>
                      <Typography variant=Typography.Variant.h5>{string("Your Tasks")}</Typography> 
                    </Grid.Item>
                    <Grid.Item>
                      <Typography variant=Typography.Variant.h6>tokenCount</Typography>
                    </Grid.Item>
                  </Grid.Container>
                </Grid.Item>  
              </Grid.Container>
            </div>
          <TaskList user/> 
          switchTab
        </div>
      | Notification => 
        <div>
          <div style=(ReactDOM.Style.make(~padding="10px", ()))> 
                <Grid.Container>
                  <Grid.Item xs={GridSize.size(12)}>
                    <Grid.Container justify=Justify.center spacing=10>
                      <Grid.Item>
                        <Typography variant=Typography.Variant.h5>{string("Notifications")}</Typography> 
                      </Grid.Item>
                      <Grid.Item>
                        <Typography variant=Typography.Variant.h6>tokenCount</Typography>
                      </Grid.Item>
                    </Grid.Container>
                  </Grid.Item>  
                </Grid.Container>
              </div>
        <NotificationList user />          
          switchTab
        </div>
      | AddTask => 
        <div> tokenCount <AddTask setTasks user/>
          switchTab
        </div>
      }}
    </div>
  }
}
