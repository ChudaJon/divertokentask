

let declineTask = (task:Data.Task.t, user:Data.User.t) =>{
  
  Superagent.superagent
    ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/declineTask/`)
    ->Superagent.send({
      "taskId": task.id,
      "userId": user.id,
    })
}

let claimTask = (task:Data.Task.t, user:Data.User.t) =>{
  
  Superagent.superagent
    ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/claimTask/`)
    ->Superagent.send({
      "taskId": task.id,
      "userId": user.id,
    })
}

let verifyTask = (task:Data.Task.t, user:Data.User.t) =>{
  Superagent.superagent
    ->Superagent.post(`https://us-central1-divertise-asia-divertask.cloudfunctions.net/verifyTask/`)
    ->Superagent.send({
      "taskId": task.id,
      "userId": user.id,
    })
}