/** User type */
type t = {
  displayName: string,
  token: int,
  email: string
};

let changeToken = (user, amount) => {...user, token: user.token + amount}

let spendToken = (user, amount) => {
  ()
}

let depositToken = (user, amount) => {
  ()
}

let login = (_username, _password) => Js.Promise.resolve({
  displayName: "test",
  token: 10,
  email: "divertask@divertise.asia"
}:t)