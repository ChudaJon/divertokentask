open MaterialUI
open MaterialUI.DataType

module SwitchTabs = {
  @react.component
  let make = (~title, ~notificationBadge, ~clearNotification) => {
    let onUnclaimedTask = _ => Routes.push(UnclaimTask)
    let onTaskList = _ => Routes.push(TaskList)
    let onNotification = _ => {
      Routes.push(Notification)
      clearNotification()
    }

    let tab = (~text, ~onClick) =>
      <Button onClick fullWidth=true>
        <Typography variant=Typography.Variant.h6> {React.string(text)} </Typography>
      </Button>

    let tabWithBadge = (~text, ~onClick, ~badgeContent) =>
      <Button onClick fullWidth=true>
        <Badge badgeContent color="secondary">
          <Typography variant=Typography.Variant.h6> {React.string(text)} </Typography>
        </Badge>
      </Button>

    <div style={ReactDOM.Style.make(~padding="25px", ())}>
      <Grid.Container spacing=3>
        <Grid.Item xs={GridSize.size(4)}> {tab(~text=title, ~onClick=onUnclaimedTask)} </Grid.Item>
        <Grid.Item xs={GridSize.size(4)}>
          {tab(~text="Your Tasks", ~onClick=onTaskList)}
        </Grid.Item>
        <Grid.Item xs={GridSize.size(4)}>
          {tabWithBadge(
            ~text="Notifications",
            ~onClick=onNotification,
            ~badgeContent=notificationBadge,
          )}
        </Grid.Item>
      </Grid.Container>
    </div>
  }
}

@react.component
let make = (~title, ~notificationBadge, ~setNotificationBadge, ~tokenCount, ~children) => {
  let clearNotification = () => setNotificationBadge(_ => 0)

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
    <SwitchTabs title clearNotification notificationBadge />
  </div>
}
