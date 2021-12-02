open React
open MaterialUI
open Data
@module("/src/styles/NotificationCard.module.scss") external styles: {..} = "default"

@react.component
let make = (~notification: notification) => {
  let tasks = React.useContext(Context_Tasks.context)

  let taskId = notification.task_id->Belt.Option.getWithDefault("")

  let linkToTask = () => Routes.push(ViewTask(taskId))
  let optionTask = tasks->Belt.Array.getBy(t => t.id == Some(taskId))

  switch optionTask {
  | Some(task) =>
    <div>
      //TODO: Change to use either flex or block
      <div className={styles["noti-card"]}>
        <Button onClick={_ => linkToTask()}>
          <Typography className={styles["noti-text"]}>
            {string(
              switch notification.notiType {
              | Claimed(user) => `Task '${task.content}' has been claimed by ${user}`
              | Complete =>
                `A task that you voted for '${task.content}' is completed, you can verify it now`
              | Verified(user) => `Task '${task.content}' has been verified by ${user}`
              },
            )}
          </Typography>
        </Button>
      </div>
    </div>

  | None => string("")
  }
}
