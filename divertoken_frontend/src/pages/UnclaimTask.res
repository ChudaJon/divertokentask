open React

@react.component
let make = (~tasks, ~setTokenCoin) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let (tasks:list<string>, setTask) = useState(_=>list{})

  let onData = (data:Js.Json.t) => {
    switch(data->Task.fromJson){
      |Some(task) => setTask(prevTasks => list{task, ...prevTasks})
      |None => ()
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
