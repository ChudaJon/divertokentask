open React

@react.component
let make = (~user) => {
  let onAddTask = () => RescriptReactRouter.push(Routes.route2Str(AddTask))

  let (tasks:list<Task.t>, setTaskList) = useState(_=>list{})

  let onData = (id:option<string>, data:Js.Json.t) => {
    Js.log2("task", data)
    let task = data->Task.fromJson(id,_);
    setTaskList(prevTasks => list{task, ...prevTasks})
  };
  
  useEffect0(()=>{
    let stopListen = Firebase.Divertask.listenToPath("tasks", ~onData,());

    Some(stopListen)
  })

  <div>
    {tasks
    ->Belt.List.mapWithIndex((i,task) => <UnclaimTaskCard key=`task-${Js.Int.toString(i)}` user task />)
    ->Array.of_list
    ->React.array}
    <button onClick={_ => onAddTask()}> {string("+ Add Task")} </button>
  </div>
}
