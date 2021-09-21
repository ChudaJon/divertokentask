open React
open MaterialUI
open MaterialUIDataType

@react.component
let make = (~user: User.t, ~notification: Notification.t) => {

    let optionIdConvert = (notiTaskId) => {
      switch notiTaskId {
        | Some(notiTaskId) => notiTaskId
        | None => ""
      }
    }

    let taskId = optionIdConvert(notification.task_id)

    let linkToTask = () => {
      RescriptReactRouter.push(Routes.route2Str(ViewTask(taskId)))
    }

    let allTasks = React.useContext(Context_Tasks.context)

    let optionTask = allTasks->Belt.List.getBy( t => t.id == Some(taskId));

    switch (optionTask){
        | Some(task) => 
        <>{
          <div style=(ReactDOM.Style.make(~display="flex", ()))>
          <Grid.Container>
            <div style=(ReactDOM.Style.make(~margin="auto", ~width="50%", ~display="block", ()))>
              <div className="box"
                style={ReactDOM.Style.make(~margin="10px", ~padding="15px 25px", ~backgroundColor="#FFFFFF", ())}>
                <Grid.Item xs={GridSize.size(12)}>
                  <div style=(ReactDOM.Style.make(~margin="auto", ~padding="10px 3px", ()))>
                    <Button onClick={_ => linkToTask()}> 
                      {
                        switch(notification.notiType){
                          | Claimed => 
                            <Typography variant=Typography.Variant.h6>
                              {string("Your task '" ++ task.content ++ "' has been claimed")}
                            </Typography>
                          | VerifyWait => 
                            <Typography variant=Typography.Variant.h6>
                              {string("Your task '" ++ task.content ++ "' is being verified")}
                            </Typography>
                          | Verify => 
                            <div>
                              <Typography variant=Typography.Variant.h6>
                                {string("A task that you voted for '" ++ task.content++ "' is completed, you can verify it now")}
                              </Typography>
                            </div>
                          | Done =>
                            <Typography variant=Typography.Variant.h6>
                              {string("Your task '" ++ task.content ++ "' has been verified")}
                            </Typography>
                        }
                      }
                    </Button>
                  </div>
                </Grid.Item>
              </div>
            </div>
          </Grid.Container>
          </div>
        }</>
        | None => {string("")}
    }
}
