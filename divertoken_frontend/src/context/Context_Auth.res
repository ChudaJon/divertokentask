type context = option<Data.User.t>
let defaultContext: context = None

let context = React.createContext(defaultContext)

module Provider = {
  let provider = React.Context.provider(context)

  @react.component
  let make = (~user, ~children) => {
    React.createElement(provider, {"value": user, "children": children})
  }
}
