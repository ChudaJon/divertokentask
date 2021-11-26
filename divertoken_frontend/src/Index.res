// // Entry point

@val external document: {..} = "document"

let makeContainer = () => {
  let container = document["createElement"]("div")
  container["className"] = "container"

  let _ = document["body"]["appendChild"](container)

  container
}

// ReactDOMRe.render(<Routing />, makeContainer())
ReactDOM.render(<App />, makeContainer())
