type t
type request
type response = {body: Js.Json.t, text: string}
type responseHandler = response => unit
type sentRequest
type error = {
  status: int,
  response: option<response>,
}
type errorHandler = error => unit

@module("superagent") external superagent: t = "default"

@send external get: (t, string) => request = "get"
@send external post: (t, string) => request = "post"
@send external delete: (t, string) => request = "delete"
@send external patch: (t, string) => request = "patch"

@send external send: (request, {..}) => request = "send"
@send external sendDict: (request, Js.Dict.t<Js.Json.t>) => request = "send"
@send external set: (request, string, string) => request = "set"
@send external then: (request, responseHandler) => sentRequest = "then"
@send external catch: (sentRequest, errorHandler) => unit = "catch"
@send external field: (request, string, string) => request = "field"
