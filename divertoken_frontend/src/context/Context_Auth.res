open React

let authContext = React.createContext()

// let useAuth = () => {
//   React.useContext(authContext)
// }

module Provider = {
  let provider = React.Context.provider(authContext)

  let (currentUser, setCurrentUser) = React.useState(_ => ())

  let signup = (~email as _: string, ~password as _: string) => {
    // Firebase.Divertask.auth->Firebase.Auth.createUserWithEmailAndPassword(~email, ~password)
    ()
  }
  useEffect1(() => {
    // let unsubscribe = Firebase.Auth.onAuthStateChanged(user: Firebase.Auth.User.t)
    // setCurrentUser(_ => user)

    // unsubscribe
    None
  }, [])

  let value = {
    (currentUser, signup)
  }

  @react.component
  let make = (~children) => {
    React.createElement(provider, {"value": currentUser, "children": children})
  }
}
