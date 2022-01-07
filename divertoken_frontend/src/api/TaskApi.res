let declineTask = (task: Data.Task.t, user: Data.User.t) => {
  Superagent.superagent
  ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/declineTask/`)
  ->Superagent.send({
    "taskId": task.id,
    "userId": user.id,
  })
  // ->Superagent.then(res => {
  //   Js.log2("Task is being declined", res)
  // })
}

let claimTask = (task: Data.Task.t, user: Data.User.t) => {
  Superagent.superagent
  ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/claimTask/`)
  ->Superagent.send({
    "taskId": task.id,
    "userId": user.id,
  })
  ->Superagent.then(res => {
    Js.log2("Task is claimed", res)
  })
}

let verifyTask = (task: Data.Task.t, user: Data.User.t) => {
  Js.log3("verifyTask", task, user)
  Superagent.superagent
  ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/verifyTask/`)
  ->Superagent.send({
    "taskId": task.id,
    "userId": user.id,
  })
  // ->Superagent.then(res => {
  //   Js.log2("Task is being verified", res)
  // })
}
