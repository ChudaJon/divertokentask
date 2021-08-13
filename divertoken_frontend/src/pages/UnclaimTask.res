open React

@react.component
let make = (~tasks, ~setTokenCoin) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let (tasks:list<string>, setTask) = useState(_=>list{})

  let onData = (id:option<string>, data:Js.Json.t) => {
    switch(data->Task.fromJson(id,_)){
      |{content, status: Open} => setTask(prevTasks => list{content, ...prevTasks})
      |_ => ()
    }
    
  };
  
  useEffect0(()=>{
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData,());

    Some(stopListen)
  })

  <div>
    {tasks
    ->Belt.List.map(task => <UnclaimTaskCard content=task setTokenCoin />)
    ->Array.of_list
    ->React.array}
    <button onClick={_ => onAddTask()}> {string("+ Add Task")} </button>
  </div>
}
