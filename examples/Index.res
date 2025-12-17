module Counter = {
  type state = int
  type action = Increment | Decrement
  let reducer = (state, action) => {
    switch action {
    | Increment => ReactUpdate.Update(state + 1)
    | Decrement => Update(state - 1)
    }
  }

  @react.component
  let make = () => {
    let (state, dispatch) = ReactUpdate.useReducer(reducer, 0)
    <div>
      {React.int(state)}
      <div>
        <button onClick={_ => dispatch(Increment)}> {React.string("+")} </button>
        <button onClick={_ => dispatch(Decrement)}> {React.string("-")} </button>
      </div>
    </div>
  }
}

module BasicUsage = {
  type action = Tick | Reset
  type state = {elapsed: int}

  @react.component
  let make = () => {
    let (state, send) = ReactUpdate.useReducerWithMapState(
      (state, action) =>
        switch action {
        | Tick =>
          UpdateWithSideEffects(
            {elapsed: state.elapsed + 1},
            ({send}) => {
              let timeoutId = setTimeout(() => send(Tick), 1_000)
              Some(() => clearTimeout(timeoutId))
            },
          )
        | Reset => Update({elapsed: 0})
        },
      () => {elapsed: 0},
    )
    React.useEffect0(() => {
      send(Tick)
      None
    })
    <div>
      {state.elapsed->String.make->React.string}
      <button onClick={_ => send(Reset)}> {"Reset"->React.string} </button>
    </div>
  }
}

switch ReactDOM.querySelector("#counter") {
| Some(root) => ReactDOM.Client.createRoot(root)->ReactDOM.Client.Root.render(<Counter />)
| None => ()
}

switch ReactDOM.querySelector("#basic") {
| Some(root) => ReactDOM.Client.createRoot(root)->ReactDOM.Client.Root.render(<BasicUsage />)
| None => ()
}
