open React;

[@react.component]
let make = (~content, ~setTokenCoin) => {
  let (vote, setVote) = React.useState(() => 0);

  <div
    style={ReactDOM.Style.make(
      ~margin="10px",
      ~padding="10px",
      ~border="1px solid black",
      (),
    )}>
    <p> {string(content)} </p>
    <p> {string("Votes: " ++ string_of_int(vote))} </p>
    <button onClick={_ => ()}> {string("Claim Task")} </button>
    <button
      style={ReactDOM.Style.make()}
      onClick={_ => {
        setVote(_ => vote + 1);
        setTokenCoin(prev => prev - 1);
      }}>
      {React.string("Vote")}
    </button>
  </div>;
};
