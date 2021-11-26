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
    open Decode

    (
      json => {
        id: field("id", string)(json),
        displayName: field("display_name", string)->withDefault("?")(json),
        token: field("token", int)->withDefault(0)(json),
        email: field("email", string)->withDefault("")(json),
      }
    )->optional(json)
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
    token: Env.defaultToken,
    email: "divertask@divertise.asia",
  })

let addUser = (~user: t) => {
  let db = Firebase.Divertask.db
  let value = user->Codec.toJson

  db->Database.ref(~path=`users/${user.id}`, ())->Database.Reference.set(~value, ())
}
