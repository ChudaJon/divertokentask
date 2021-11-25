open MaterialUI
open MaterialUI.DataType

type tab = UnClaimed | YourTask | Notification | Account

module SwitchTabs = {
  @react.component
  let make = (~currentTab, ~setCurrentTab, ~notificationBadge) => {
    let user = React.useContext(Context_Auth.context)
    let userStr =
      user->Belt.Option.mapWithDefault("", ({email}) => email->Js.String2.slice(~from=0, ~to_=2))

    let onChange = (_event, newTab) => setCurrentTab(_ => newTab)

    <BottomNavigation value={currentTab} onChange>
      <BottomNavigationAction icon={<Icon.FormatListBulleted />} />
      <BottomNavigationAction icon={<Icon.Person />} />
      <BottomNavigationAction
        icon={<Badge badgeContent=notificationBadge color="secondary">
          <Icon.Notifications />
        </Badge>}
      />
      <BottomNavigationAction icon={<Avatar> {React.string(userStr)} </Avatar>} />
    </BottomNavigation>
  }
}

@react.component
let make = (
  ~title,
  ~notificationBadge,
  ~setNotificationBadge,
  ~tokenCount,
  ~onLogout,
  ~children,
) => {
  let url = RescriptReactRouter.useUrl()
  let (currentTab, setCurrentTab) = React.useState(_ => UnClaimed)
  let clearNotification = () => setNotificationBadge(_ => 0)

  React.useEffect1(() => {
    switch url->Routes.url2route {
    | UnclaimTask => setCurrentTab(_ => UnClaimed)
    | TaskList => setCurrentTab(_ => YourTask)
    | Notification => setCurrentTab(_ => Notification)
    | Account => setCurrentTab(_ => Account)
    | _ => ()
    }
    None
  }, [])

  React.useEffect1(() => {
    switch currentTab {
    | UnClaimed => Routes.push(UnclaimTask)
    | YourTask => Routes.push(TaskList)
    | Notification =>
      clearNotification() //TODO: should be call in notification page instead
      Routes.push(Notification)
    | Account => Routes.push(Account)
    }
    None
  }, [currentTab])

  <div>
    <div style={ReactDOM.Style.make(~padding="10px", ())}>
      <Grid.Container>
        <Grid.Item xs={GridSize.size(12)}>
          <Grid.Container justify=Justify.center spacing=10>
            <Grid.Item>
              <Typography variant=Typography.Variant.h5> {React.string(title)} </Typography>
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
    <SwitchTabs currentTab setCurrentTab notificationBadge />
    <Button
      variant={Button.Variant.contained} color={NoTransparentColor.secondary} onClick=onLogout>
      {React.string("Logout")}
    </Button>
  </div>
}
