open React
open MaterialUI
open MaterialUIDataType

let (notificationBadge, setNotificationBadge) = useState(() => 0)

let tokenCount = <div> {React.string("1")} </div>
let onUnclaimedTask = () => RescriptReactRouter.push(Routes.route2Str(UnclaimTask))
let onTaskList = () => RescriptReactRouter.push(Routes.route2Str(TaskList))
let onNotification = () => RescriptReactRouter.push(Routes.route2Str(Notification))
let handleNotifications = () => {
  onNotification()
  setNotificationBadge(_ => 0)
}

let switchTab =
  <div style={ReactDOM.Style.make(~padding="25px", ())}>
    <Grid.Container spacing=3>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => onUnclaimedTask()} fullWidth=true>
          <Typography variant=Typography.Variant.h6> {string("Unclaimed Tasks")} </Typography>
        </Button>
      </Grid.Item>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => onTaskList()} fullWidth=true>
          <Typography variant=Typography.Variant.h6> {string("Your Tasks")} </Typography>
        </Button>
      </Grid.Item>
      <Grid.Item xs={GridSize.size(4)}>
        <Button onClick={_ => handleNotifications()} fullWidth=true>
          <Badge badgeContent={notificationBadge} color="secondary">
            <Typography variant=Typography.Variant.h6> {string("Notifications")} </Typography>
          </Badge>
        </Button>
      </Grid.Item>
    </Grid.Container>
  </div>

@react.component
let make = (~pageTitle, ~children=React.null) =>
  <div>
    <div style={ReactDOM.Style.make(~padding="10px", ())}>
      <Grid.Container>
        <Grid.Item xs={GridSize.size(12)}>
          <Grid.Container justify=Justify.center spacing=10>
            <Grid.Item>
              <Typography variant=Typography.Variant.h5> {string(pageTitle)} </Typography>
            </Grid.Item>
            <div style={ReactDOM.Style.make(~position="absolute", ~left="87%", ~top="2%", ())}>
              <Grid.Item>
                <Typography variant=Typography.Variant.h6> tokenCount </Typography>
              </Grid.Item>
            </div>
          </Grid.Container>
        </Grid.Item>
      </Grid.Container>
    </div>
    children
    switchTab
  </div>
