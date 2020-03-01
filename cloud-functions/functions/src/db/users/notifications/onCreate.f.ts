import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export default functions.firestore
  .document("/users/{userID}/notifications/{docID}")
  .onCreate((snapshot, context) => {
    const notification = snapshot.data();
    const userId = context.params.userID;
    const eventId = notification.eventId;

    console.log(`Sending Announcement to ${userId}`);

    const database = admin.firestore();
    let fcmToken = "", imageSrc = "";

    database
      .doc(`/users/${userId}`)
      .get()
      .then(rdoc => {
        const receiverData = rdoc.data();
        fcmToken = receiverData.fcmToken;

        database
          .doc(`/events/${eventId}`)
          .get()
          .then(sdoc => {
            const eventData = sdoc.data();
            imageSrc = eventData.imageSrc;

            const payload = {
              notification: {
                title: notification.title,
                body: notification.message,
                click_action: "FLUTTER_NOTIFICATION_CLICK",
                sound: 'default'
              },
              data: {
                type: "Announcement",
                eventId: eventId,
                imageSrc: imageSrc
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