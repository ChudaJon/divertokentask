let firebaseConfig = {
  "apiKey": "AIzaSyA0azDZFcpFr02EEXbm_j_ZOoFFnr3GKeo",
  "authDomain": "divertise-asia-divertask.firebaseapp.com",
  "databaseURL": "https://divertise-asia-divertask-default-rtdb.asia-southeast1.firebasedatabase.app",
  "projectId": "divertise-asia-divertask",
  "storageBucket": "divertise-asia-divertask.appspot.com",
  "messagingSenderId": "801702206503",
  "appId": "1:801702206503:web:fbad3a42ea768b73000202",
  "measurementId": "G-WJYLW54XT7",
}

module Error = {
  type t<'e> = 'e
}

module Database = {
  type t

  type eventType = [
    | #value
    | #child_added
    | #child_changed
    | #child_removed
    | #child_moved
  ]

  module rec Reference: {
    type t
    type cb = DataSnapshot.t => unit
    @get external key: t => Js.nullable<string> = "key"
    @get external parent: t => Js.nullable<t> = "parent"
    @get external root: t => t = "root"
    @send external child: (t, ~path: string) => t = "child"

    @send
    external once: (
      t,
      ~eventType: @string [#value | #child_added | #child_changed | #child_removed | #child_moved],
      ~successCallback: DataSnapshot.t => unit=?,
      unit,
    ) => Js.Promise.t<DataSnapshot.t> = "once"

    @send
    external on: (
      t,
      ~eventType: @string [#value | #child_added | #child_changed | #child_removed | #child_moved],
      ~callback: DataSnapshot.t => unit,
      ~cancelCallback: Error.t<'e> => unit=?,
    ) => t = "on"

    @send
    external off: (
      t,
      ~eventType: @string [#value | #child_added | #child_changed | #child_removed | #child_moved],
      ~callback: DataSnapshot.t => unit=?,
      unit,
    ) => unit = "off"

    @send
    external set: (
      t,
      ~value: 'a,
      ~onComplete: Js.nullable<Error.t<'e>> => unit=?,
      unit,
    ) => Js.Promise.t<unit> = "set"

    @send
    external update: (
      t,
      ~value: 'a,
      ~onComplete: Js.nullable<Error.t<'e>> => unit=?,
      unit,
    ) => Js.Promise.t<unit> = "update"

    @send
    external push: (t, ~value: 'a=?, ~onComplete: Js.nullable<Error.t<'e>> => unit=?, unit) => t =
      "push"
  } = Reference

  and DataSnapshot: {
    type t
    @get external key: t => Js.null<string> = "key"
    @get external ref: t => Reference.t = "ref"
    @send external child: (t, ~path: string) => t = "child"
    @send external exists: t => bool = "exists"
    @send external exportVal: t => Js.Json.t = "exportVal"
    @send external foreach: (t, t => bool) => bool = "forEach"
    /* external getPriority */
    @send external hasChild: (t, ~path: string) => bool = "hasChild"
    @send external hasChildren: t => bool = "hasChildren"
    @send external numChildren: t => int = "numChildren"
    @send external toJson: t => Js.Json.t = "toJSON"
    @send external val_: t => Js.Json.t = "val"
  } = DataSnapshot
  module OnDisconnect = {
    type t
    @send
    external cancel: (t, ~onComplete: Js.nullable<Error.t<'e>> => unit=?) => Js.Promise.t<unit> =
      "cancel"
    @send
    external remove: (t, ~onComplete: Js.nullable<Error.t<'e>> => unit=?) => Js.Promise.t<unit> =
      "remove"
    @send
    external set: (
      t,
      Js.Json.t,
      ~onComplete: Js.nullable<Error.t<'e>> => unit=?,
    ) => Js.Promise.t<unit> = "set"
    /* external setWithPriority */
    @send
    external update: (
      t,
      Js.Json.t,
      ~onComplete: Js.nullable<Error.t<'e>> => unit=?,
    ) => Js.Promise.t<unit> = "update"
  }

  module ThenableReference = {
    type t
  }

  module Query = {
    type t
  }

  /* external app : t => App.t = "" [@@bs.get]; */
  @send external goOffline: t => unit = "goOffline"
  @send external goOnline: t => unit = "goOnline"
  @send external ref: (t, ~path: string=?, unit) => Reference.t = "ref"
  @scope(("database", "ServerValue")) @val @module("firebase")
  external serverTimestamp: Js.null<string> = "TIMESTAMP"
  @send external refFromUrl: (t, ~url: string) => Reference.t = "refFromURL"
}

module Storage = {
  type t
  module UploadTask = {
    type t
  }

  module Reference = {
    type t
    @get external bucket: t => string = "bucket"
    @get external fullPath: t => string = "fullPath"
    @get external name: t => string = "name"
    @get external parent: t => option<t> = "parent"
    @get external root: t => t = "root"
    /* external storage : t => Storage.t = "" [@@bs.get]; */
    @send external path: (t, ~path: string) => t = "path"
    @send external delete: t => Js.Promise.t<unit> = "delete"
    @send external getDownloadURL: t => Js.Promise.t<string> = "getDownloadURL"
  }

  @send external ref: (t, ~path: string=?, unit) => Reference.t = "ref"
}

module Auth = {
  type t
  module User = {
    type t
    type profile = {"displayName": Js.nullable<string>, "photoURL": Js.nullable<string>}
    @get external displayName: t => string = "displayName"
    @get external email: t => Js.nullable<string> = "email"
    @get external emailVerified: t => bool = "emailVerified"
    @get external isAnonymous: t => bool = "isAnonymous"
    @get external phoneNumber: t => Js.nullable<string> = "phoneNumber"
    @get external photoUrl: t => Js.nullable<string> = "photoURL"
    @get external uid: t => string = "uid"
    @send external updateProfile: (t, ~profile: profile) => Js.Promise.t<unit> = "updateProfile"
    @send external getIdToken: t => Js.Promise.t<Js.nullable<string>> = "getIdToken"
  }
  module Error = {
    type t
  }
  module AuthCredential = {
    type t
  }
  @get external currentUser: t => Js.null<User.t> = "currentUser"
  @send
  external createUserWithEmailAndPassword: (
    t,
    ~email: string,
    ~password: string,
  ) => Js.Promise.t<User.t> = "createUserWithEmailAndPassword"
  @send
  external onAuthStateChanged: (
    t,
    ~nextOrObserver: Js.Null.t<User.t> => unit,
    ~error: Error.t => unit=?,
    ~completed: unit => unit=?,
  ) => unit = "onAuthStateChanged"
  @send external signInAnonymously: (t, unit) => Js.Promise.t<User.t> = "signInAnonymously"
  @send
  external signInWithCredential: (t, ~credential: AuthCredential.t) => Js.Promise.t<User.t> =
    "signInWithCredential"
  @send
  external signInWithCustomToken: (t, ~token: string) => Js.Promise.t<User.t> =
    "signInWithCustomToken"
  @send external signOut: t => Js.Promise.t<unit> = "signOut"
}

module Messaging = {
  type t

  @send external isSupported: t => bool = "isSupported"
  @send external usePublicVapidKey: (t, string) => unit = "usePublicVapidKey"
  @send external onTokenRefresh: (t, unit => unit) => unit = "onTokenRefresh"
  @send external getToken: (t, unit) => Js.Promise.t<string> = "getToken"
  @send external onMessage: (t, Js.Promise.t<'a>) => unit = "onMessage"
  @send external deleteToken: (t, string) => Js.Promise.t<unit> = "deleteToken"
  @send external useServiceWorker: (t, 'a) => Js.Promise.t<unit> = "useServiceWorker"
  @send external isSupported: t => bool = "isSupported"
}

module App = {
  type t
  @send external auth: t => Auth.t = "auth"
  @send external database: t => Database.t = "database"
  /* external delete */
  @send external messaging: t => Messaging.t = "messaging"
  @send external storage: t => Storage.t = "storage"
  @get external options: t => 'a = "options"
  @send @scope(("firebase_", "messaging")) external isSupportedMessaging: t => bool = "isSupported"
}

type options = {
  "apiKey": string,
  "authDomain": string,
  "databaseURL": string,
  "storageBucket": string,
  "messagingSenderId": string,
  "appId": string,
  "measurementId": string,
  "projectId": string
}

@scope("default") @module("firebase/app") external initializeApp: (~options: options) => App.t = "initializeApp"

@module external database: Database.t = "firebase/database"
@module external messaging: Messaging.t = "firebase/messaging"

module Divertask = {
  let options = firebaseConfig

  let app = initializeApp(~options)

  let _ = database; /** This is required ato load firebase.database seperately. */
  let _ = messaging; /** This is required to load firebase.messaging. */

  let db = App.database(app)
  type key = string;

  let listenToPath = (path, ~eventType:Database.eventType=#child_added, ~onData:(option<key>, Js.Json.t)=>unit, ()) => 
  {
    Js.log2("listening...", path)
    let callback = snapshot => 
      onData(Database.DataSnapshot.key(snapshot)->Js.Null.toOption, Database.DataSnapshot.val_(snapshot));
    
    Database.ref(db, ~path, ()) -> Database.Reference.on(
        ~eventType,
        ~callback,
        ~cancelCallback={err => Js.log2("cancel",err)}
    ) |> ignore;

    let stopListen = () => {
      Database.Reference.off(
        Database.ref(db, ~path, ()),
        ~eventType,
        ~callback,
        ()
    );
    }
    stopListen
  }


  let messaging = if(App.isSupportedMessaging(app)){
      Some(App.messaging(app))
  } else {
      None
  }

}

let _ = Divertask.app;