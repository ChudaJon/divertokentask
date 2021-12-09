const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.verifyTask = functions.https.onRequest((req, res) => {
  functions.logger.info("Task verified!", { structuredData: true });
  //   response.send("Task verified!");
  const taskId = req.body.taskId;
  const userId = req.body.userId;
  return admin.database().ref("tasks/" + taskId).once("value", (snapshot) => {
    const task = snapshot.val();
    res.send(`
          <!doctype html>
          <html>
              <head>
                  <title>${task.name}</title>
              </head>
              <body>
                  <h1>Title ${task.name} is verified by ${userId}</h1>
              </body>
          </html>`
    );
  });
});

exports.claimTask = functions.https.onRequest((request, response) => {
  functions.logger.info("Task claim!", {structuredData: true});
  response.send("Task claim!");
});

