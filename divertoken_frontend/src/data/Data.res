module Task = Data_Task
module User = Data_User
module Notification = Data_Notification

type task = Task.t
type user = User.t
type notification = Notification.t

type apiState<'data, 'err> = Idle | Loading | Success('data) | Fail('err)
