/** User type */
type t = {
  displayName: string,
  token: int,
  email: string
};


let deductToken = (user, price) => {...user, token: user.token - price}
let depositToken = (user, amount) => {...user, token: user.token - amount}

let login = (_username, _password) => Js.Promise.resolve({
  displayName: "test",
  token: 10,
  email: "divertask@divertise.asia"
})