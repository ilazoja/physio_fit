import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export default functions.firestore
.document("/messages/{groupID}/{collectionID}/{messageID}")
.onCreate((snapshot, context) => {
  const message = snapshot.data();
  const senderUid = message.idFrom;
  const receiverUid = message.idTo;

  console.log(`From: ${senderUid}; To: ${receiverUid} `);

  const database = admin.firestore();
  let fcmToken = "",
    senderName = "",
    senderImage = "";

  database
    .doc(`/users/${receiverUid}`)
    .get()
    .then(rdoc => {
      const receiverData = rdoc.data();
      fcmToken = receiverData.fcmToken;

      database
        .doc(`/users/${senderUid}`)
        .get()
        .then(sdoc => {
          const senderData = sdoc.data();
          senderName =
            senderData.displayName == null ? "" : senderData.displayName;
          senderImage =
            senderData.profileImage == null ? "" : senderData.profileImage;

          const payload = {
            notification: {
              title: senderName,
              body: message.content,
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              sound: 'default'
            },
            data: {
              type: "Messaging",
              id: receiverUid,
              peerId: senderUid,
              peerName: senderName,
              peerAvatar: senderImage
            }
          };

          console.log(payload);

          admin
            .messaging()
            .sendToDevice(fcmToken, payload)
            .then(function(response) {
              console.log("Successfully sent message:", response);
            })
            .catch(function(error) {
              console.log("Error sending message:", error);
            });
        })
        .catch(err => {
          console.error(err);
        });
    })
    .catch(err => {
      console.error(err);
    });
  return { success: true };
});