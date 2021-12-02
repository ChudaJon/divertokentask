open MaterialUI
open MaterialUI.DataType

type tab = UnClaimed | YourTask | Notification | Account

@module("/src/styles/Layout_Main.module.scss") external styles: {..} = "default"

module SwitchTabs = {
  @react.component
  let make = (~currentTab, ~setCurrentTab, ~notificationBadge) => {
    let user = React.useContext(Context_Auth.context)
    let userStr =
      user->Belt.Option.mapWithDefault("", ({email}) => email->Js.String2.slice(~from=0, ~to_=2))

    let onChange = (_event, newTab) => setCurrentTab(_ => newTab)
    <div className={styles["bottom-nav-container"]}>
      <BottomNavigation className={styles["bottom-nav"]} value={currentTab} onChange>
        <BottomNavigationAction icon={<Icon.FormatListBulleted />} />
        <BottomNavigationAction icon={<Icon.Person />} />
        <BottomNavigationAction
          icon={<Badge badgeContent=notificationBadge color="secondary">
            <Icon.Notifications />
          </Badge>}
        />
        <BottomNavigationAction icon={<Avatar> {React.string(userStr)} </Avatar>} />
      </BottomNavigation>
    </div>
  }
}

@react.component
let make = (~title, ~notificationBadge, ~setNotificationBadge, ~children) => {
  let url = RescriptReactRouter.useUrl()
  let user = React.useContext(Context_Auth.context)
  let (currentTab, setCurrentTab) = React.useState(_ => UnClaimed)

  let clearNotification = () => setNotificationBadge(_ => 0)

  let tokenCount = switch user {
  | Some({token}) =>
    token > 1
      ? <div>
          {React.string(`You have`)} <br /> {React.string(`${Js.Int.toString(token)} tokens`)}
        </div>
      : <div>
          {React.string(`You have`)} <br /> {React.string(`${Js.Int.toString(token)} token`)}
        </div>
  | None => <div> {React.string(`You don't have any tokens`)} </div>
  }

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
    <div className={styles["page-header-container"]}>
      <Grid.Container className={styles["page-header"]}>
        <Grid.Item xs={GridSize.size(12)}>
          <Grid.Container justify=Justify.center spacing=12>
            <Grid.Item>
              <Typography variant=Typography.Variant.h5> {React.string(title)} </Typography>
            </Grid.Item>
            <div className={styles["tokencount-container"]}>
              <Typography> tokenCount </Typography>
            </div>
          </Grid.Container>
        </Grid.Item>
      </Grid.Container>
    </div>
    <div className={styles["page-content"]}> {children} </div>
    <SwitchTabs currentTab setCurrentTab notificationBadge />
  </div>
}
