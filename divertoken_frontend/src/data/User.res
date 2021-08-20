/** User type */
type t = {
  id: string,
  displayName: string,
  token: int,
  email: string
};

module Database = Firebase.Database;

module Codec = {
  open Json;
  let fromJson = (id:option<string>, data:Js.Json.t) => {
    data->(json=>{
      {
        id: Decode.field("id", Decode.string)(json),
        displayName: Decode.field("display_name", Decode.string)->Decode.withDefault("?")(json),
        token: Decode.field("token", Decode.int)->Decode.withDefault(0)(json),
        email: Decode.field("email", Decode.string)->Decode.withDefault("")(json),
      }
    })
  }

  let toJson = (user:t) => {
    [
      ("id", user.id->Encode.string),
      ("display_name", user.displayName->Encode.string),
      ("token", user.token->Encode.int),
      ("email", user.email->Encode.string)
    ]
    -> Array.to_list
    -> Encode.object_
  };
}

let changeToken = (user, amount) => {...user, token: user.token + amount}

let spendToken = (user, amount) => {
  let value = user->changeToken(-amount)->Codec.toJson
  let path = "users"
  let db = Firebase.Divertask.db;

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

let login = (_username, _password) => {
  Js.Promise.resolve({
  id: "proto-user-0",
  displayName: "test",
  token: 10,
  email: "divertask@divertise.asia"
}:t)
}