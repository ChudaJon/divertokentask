/* * User type */
type t = {
  id: string,
  displayName: string,
  token: int,
  email: string,
}

module Database = Firebase.Database

module Codec = {
  open Json
  let fromJson = (_id: option<string>, json: Js.Json.t) => {
    id: Decode.field("id", Decode.string)(json),
    displayName: Decode.field("display_name", Decode.string)->Decode.withDefault("?")(json),
    token: Decode.field("token", Decode.int)->Decode.withDefault(0)(json),
    email: Decode.field("email", Decode.string)->Decode.withDefault("")(json),
  }

  let toJson = (user: t) => {
    [
      ("id", user.id->Encode.string),
      ("display_name", user.displayName->Encode.string),
      ("token", user.token->Encode.int),
      ("email", user.email->Encode.string),
    ]
    ->Array.to_list
    ->Encode.object_
  }
}

let changeToken = (user, amount) => {...user, token: user.token + amount}

let spendToken = (user, amount) => {
  let value = user->changeToken(-amount)->Codec.toJson
  let path = `users/${user.id}`
  let db = Firebase.Divertask.db

  db->Database.ref(~path, ())->Database.Reference.update(~value, ())
}

let login = (_username, _password): Js.Promise.t<t> =>
  Js.Promise.resolve({
    id: "proto-user-0",
    displayName: "test",
    token: 10,
    email: "divertask@divertise.asia",
  })

let addUser = (~user: t) => {
  let db = Firebase.Divertask.db
  let value = user->Codec.toJson

  db->Database.ref(~path="users", ())->Database.Reference.push(~value, ())
}
