import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { deleteCollection } from '../../../utils';

export default functions.firestore
  .document("messages/{groupID}")
  .onDelete((snap, context) => {
    // const deletedValue = snap.data();
    const groupID = context.params.groupID;

    const BATCH_SIZE = 500;

    const database = admin.firestore();

    const colRef = database
      .collection("messages")
      .doc(groupID)
      .collection(groupID);
    const deleteExamples = deleteCollection(database, colRef, BATCH_SIZE);
    return Promise.all([deleteExamples]);
  });