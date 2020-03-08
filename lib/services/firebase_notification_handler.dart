import 'dart:convert' as json;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/copyDeck.dart' as copy;
import 'package:physio_tracker_app/dbKeys.dart';
import 'package:physio_tracker_app/screens/inbox/inbox.dart';
import 'package:physio_tracker_app/screens/inbox/providerWrapper/chatScreenProviderWrapper.dart';
import 'package:physio_tracker_app/screens/inbox/widgets/chatScreen.dart';
import 'package:physio_tracker_app/services/cloud_database.dart';
import 'package:physio_tracker_app/widgets/shared/circular_image.dart';
import 'package:physio_tracker_app/widgets/shared/defaultPageRoute.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  Future<bool> addTokenToSharedPrefs(String token, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('kiqback_fcm_token', token);
    updateFCMToken(token, context);
    return true;
  }

  bool currentlyTalkingToPeer(String peerID) {
    // if chat screen is currently pushed and talking to a peer sending curr user a message
    return Chat.currentPeer == peerID;
  }

  void firebaseCloudMessaging_Listeners(BuildContext context) {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print('FCM TOKEN: ' + token);
      addTokenToSharedPrefs(token, context);
    });

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      // App in foreground
      print('on message $message');
      //StandardAlertDialog(context, 'hello', 'bye');
      handleInAppNotification(message, context);
    }, onResume: (Map<String, dynamic> message) async {
      // App in background
      print('on resume $message');
      handlePushNotification(message, context);
    }, onLaunch: (Map<String, dynamic> message) async {
      // App is terminated
      print('on launch $message');
      handlePushNotification(message, context);
    });
  }

  Map<String, dynamic> formatRecievedNotification(
      Map<String, dynamic> message) {
    // If it is an ios notification return in the required format
    Map<String, dynamic> notif = Map<String, dynamic>();
    if (Platform.isIOS) {
      notif['notification'] = message['aps']['alert'];
      notif[dataKey] = json.jsonDecode(
          '{\"peerId\": \"${message[peerIdKey]}\", \"peerAvatar\": \"${message[peerAvatarKey]}\", \"peerName\": \"${message[peerNameKey]}\", \"id\": \"${message[userIdKey]}\", \"type\": \"${message[notifTypeKey]}\", \"imageSrc\": \"${message[imageSourceNotifKey]}\"}');
      if (notif[dataKey] == null) {
        print('Unable to format');
      }
    } else {
      notif = message;
    }
    return notif;
  }

  void handleInAppNotification(
      Map<String, dynamic> message, BuildContext context) {
    message = formatRecievedNotification(message);

    final dynamic notification = message[notificationKey];
    final String title = notification[titleNotifKey];
    final String body = notification[bodyNotifKey];
    final dynamic data = message[dataKey];

    switch (data[notifTypeKey]) {
      case copy.messagingNotification:
        if (!currentlyTalkingToPeer(data[peerIdKey])) {
          showInAppNotification(title, body, data[peerAvatarKey],
              () => moveToChatScreen(context, data));
        }
        break;
      case copy.announcementNotification:
        showInAppNotification(title, body, data[imageSourceNotifKey],
            () => moveToNotifications(context));
        break;
    }
  }

  void handlePushNotification(
      Map<String, dynamic> message, BuildContext context) {
    message = formatRecievedNotification(message);
    final dynamic data = message[dataKey];
    switch (data[notifTypeKey]) {
      case copy.messagingNotification:
        moveToChatScreen(context, data);
        break;
      case copy.announcementNotification:
        moveToNotifications(context);
        break;
    }
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //print('Settings registered: $settings');
    });
  }

  void moveToChatScreen(BuildContext context, dynamic data) {
    Navigator.of(context).push<dynamic>(DefaultPageRoute<dynamic>(
        pageRoute: ChatScreenProviderWrapper(
            id: data[userIdKey],
            peerId: data[peerIdKey],
            peerName: data[peerNameKey],
            peerAvatar: data[peerAvatarKey])));
  }

  void moveToNotifications(BuildContext context) {
    Navigator.of(context)
        .push<dynamic>(DefaultPageRoute<dynamic>(pageRoute: Inbox(tab: 1)));
  }

  void setUpFirebase(BuildContext context) {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners(context);
  }

  void showInAppNotification(
      String title, String body, String imageSrc, Function callback) {
    showOverlayNotification((BuildContext context) {
      return NotificationOverlay(
        imageSrc: imageSrc,
        title: title,
        body: body,
        callback: callback,
      );
    }, duration: const Duration(milliseconds: 2500));
  }

  void updateFCMToken(String token, BuildContext context) {
    FirebaseUser _user = Provider.of<FirebaseUser>(context);
    final bool _logged = _user != null;
    if (_logged) {
      String cloudFCMToken = CloudDatabase.getFCMToken(_user.uid);
      if (cloudFCMToken == null || cloudFCMToken != token) {
        CloudDatabase.updateFCMToken(
            collection: 'users', document: _user.uid, key: fcmTokenDBKey);
      }
    }
  }
}

class NotificationOverlay extends StatelessWidget {
  final String imageSrc;

  final String title;
  final String body;
  final Function callback;
  const NotificationOverlay(
      {Key key,
      @required this.imageSrc,
      @required this.title,
      @required this.body,
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          OverlaySupportEntry.of(context).dismiss(animate: true);
          callback();
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: ListTile(
              leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                      child: Container(
                    child: CircularImage(imageSrc),
                  ))),
              title: Text(title),
              subtitle: Text(body),
              trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context).dismiss(animate: true);
                  }),
            ),
          ),
        ));
  }
}
