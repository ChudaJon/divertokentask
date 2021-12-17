/* eslint-disable require-jsdoc */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

function isAllVerified(verifier, voter) {
  console.log("check", verifier, "vs", voter);
  if (voter.length === verifier.length) {
    const filteredArray = voter.filter((v) => !verifier.includes(v));
    return filteredArray.length === 0;
  } else {
    return false;
  }
}

function payoutOnVerified(task) {
  const voter = task.voted;
  const totalTokenToBePaid = Object.values(voter).reduce((a, b) => a + b);
  console.log(`paying out ${totalTokenToBePaid} to ${task.claimedBy}`);
  const path = `users/${task.claimedBy}`;

  const ref = admin.database().ref(path);
  ref.once("value", (snapshot) => {
    const user = snapshot.val();
    if (user) {
      const token = user.token + totalTokenToBePaid;
      ref.update({token: token});
    } else {
      console.log(`No such user exists, the token 
      should be returned to the all voters`);
      // TODO: return tokens logic
    }
  });
}

exports.verifyTask = functions.https.onRequest((req, res) => {
  functions.logger.info("Task verified!", {structuredData: true});
  const taskId = req.body.taskId;
  const userId = req.body.userId;
  const path = `tasks/${taskId}`;

  if (!userId || !taskId) {
    res.status(400).send({status: "Require taskId and userId"});
    return;
  }
  const ref = admin.database().ref(path);
  return ref.once("value", (snapshot) => {
    const task = snapshot.val();
    const verifier = task.verifier || [];
    if (userId && verifier.includes(userId)) {
      res.status(400).send({status: "Already verified"});
    } else {
      verifier.push(userId);
      ref.update({verifier: verifier});

      if (isAllVerified(verifier, Object.keys(task.voted))) {
        res.send({status: "Task is Verified by All, payingout to doer"});
        payoutOnVerified(task);
      } else {
        res.send({status: "Task Verified"});
      }
    }
  });
});

exports.claimTask = functions.https.onRequest((request, response) => {
  functions.logger.info("Task claim!", {structuredData: true});
  response.send("Task claim!");
});

function paybackOnDeclined(task) {
  const voter = task.voted;
  const totalTokenToBePaid = Object.values(voter).reduce((a, b) => a + b);
  console.log(`paying out ${totalTokenToBePaid} to ${task.claimedBy}`);
  Object.entries(voter).map((entry) => {
    const path = `users/${entry[0]}/token`;
    const ref = admin.database().ref(path);
    ref.transaction((currentToken) => {
      return (currentToken || 0) + entry[1];
    });
  });
}

exports.declineTask = functions.https.onRequest((req, res) => {
  functions.logger.info("Task declined!", {structuredData: true});
  const taskId = req.body.taskId;
  const userId = req.body.userId;
  const path = `tasks/${taskId}`;

  if (!userId || !taskId) {
    res.status(400).send({status: "Require taskId and userId"});
    return;
  }
  const ref = admin.database().ref(path);
  return ref.once("value", (snapshot) => {
    const task = snapshot.val();
    const verifier = task.verifier || [];
    const voted = task.voted || [];

    if (userId === undefined || userId === null) {
      res.status(400).send({status: "No userId provided"});
      return;
    }

    if (!voted.includes(userId)) {
      res.status(400).send({status: `You have not voted for this task, 
      therefore you cannot decline it`});
    } else if (!verifier.includes(userId)) {
      res.status(400).send({status: `You have already verfiied this task,, 
      therefore you cannot decline it`});
    } else {
      paybackOnDeclined(task);

      res.send(`Task ${task} is declined!`);
    }
  });
});

