// // Entry point

@val external document: {..} = "document"

let makeContainer = () => {
  let container = document["createElement"]("div")
  container["className"] = "container"

  let content = document["createElement"]("div")
  content["className"] = "containerContent"

  let () = container["appendChild"](content)
  let () = document["body"]["appendChild"](container)

  content
}

// ReactDOMRe.render(<Routing />, makeContainer())
ReactDOM.render(<App />, makeContainer())
