open MaterialUI
open MaterialUI.DataType

@react.component
let make = (~title, ~notificationBadge, ~setNotificationBadge, ~tokenCount, ~children) => {
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
            <Typography variant=Typography.Variant.h6> {React.string(title)} </Typography>
          </Button>
        </Grid.Item>
        <Grid.Item xs={GridSize.size(4)}>
          <Button onClick={_ => onTaskList()} fullWidth=true>
            <Typography variant=Typography.Variant.h6> {React.string("Your Tasks")} </Typography>
          </Button>
        </Grid.Item>
        <Grid.Item xs={GridSize.size(4)}>
          <Button onClick={_ => handleNotifications()} fullWidth=true>
            <Badge badgeContent={notificationBadge} color="secondary">
              <Typography variant=Typography.Variant.h6>
                {React.string("Notifications")}
              </Typography>
            </Badge>
          </Button>
        </Grid.Item>
      </Grid.Container>
    </div>

  <div>
    <div style={ReactDOM.Style.make(~padding="10px", ())}>
      <Grid.Container>
        <Grid.Item xs={GridSize.size(12)}>
          <Grid.Container justify=Justify.center spacing=10>
            <Grid.Item>
              <Typography variant=Typography.Variant.h5>
                {React.string("Unclaimed Tasks")}
              </Typography>
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
    {children}
    switchTab
  </div>
}
