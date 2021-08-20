open React

@react.component
let make = (~user:User.t, ~task:Task.t) => {
  let vote = (user:User.t, task:Task.t) => {
    let amount = 1;
    task->Task.vote(amount, user)->ignore
  }

  <div style={ReactDOM.Style.make(~margin="10px", ~padding="10px", ~border="1px solid black", ())}>
    <p> {string(task.content)} </p>
    <p> {string(`Votes: ${Js.Int.toString(task.vote)}`)} </p>
    <button onClick={_ => ()}> {string("Claim Task")} </button>
    <button
      style={ReactDOM.Style.make()}
      onClick={_ => vote(user, task)}>
      {React.string("Vote")}
    </button>
  </div>
}
