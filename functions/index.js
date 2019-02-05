const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

exports.onLikeCat = functions.firestore
  .document('likes/{likeId}')
  .onCreate(e => {
    let catId, userId;
    [catId, userId] = event.params.likeId.split(':');

    const db = admin.firestore();
    const catRef = db.collection('cats').doc(catId);
    db.runTransaction(t => {
      return t.get(catRef)
        .then(doc => {
          t.update(catRef, { likeCounter: (doc.data().like_counter || 0) + 1 })
        });
    }).then(result => {
      console.log('Icreased aggregate cat like counter');
    }).catch(error => {
      console.log('Failed to increase like counter', error);
    });
  })

  exports.onUnlikeCat = functions.firestore
  .document('likes/{likeId}')
  .onDelete(e => {
    let catId, userId;
    [catId, userId] = event.params.likeId.split(':');

    const db = admin.firestore();
    const catRef = db.collection('cats').doc(catId);
    return db.runTransaction(t => {
      return t.get(catRef)
        .then(doc => {
          t.update(catRef, { likeCounter: (doc.data().like_counter || 0) - 1 })
        });
    }).then(result => {
      console.log('Decreased aggregate cat like counter');
    }).catch(error => {
      console.log('Failed to decrease like counter', error);
    });
  })
