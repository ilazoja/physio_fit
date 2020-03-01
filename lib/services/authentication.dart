import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:physio_tracker_app/dbKeys.dart' as db_key;

import 'cloud_database.dart';

abstract class BaseAuth {
  Future<Map<String, dynamic>> signUp(String email, String password,
      String displayName, String phone, DateTime dob, String type);

  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<Map<String, dynamic>> signInWithGoogle();

  Future<Map<String, dynamic>> signInWithFacebook();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<void> sendPasswordResetLink(String email);
}

class Authentication implements BaseAuth {
  Authentication._internal() {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'https://www.googleapis.com/auth/contacts.readonly',
        'email',
      ],
    );
  }

  static final Authentication _auth = Authentication._internal();

  factory Authentication() {
    return _auth;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final String _collection = 'users';
  GoogleSignIn _googleSignIn;
  FacebookLogin _facebookLogin;

  Future<FirebaseUser> getFirebaseUser() async {
    _firebaseAuth.currentUser();
  }

  @override
  Future<bool> isEmailVerified() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  void onComplete(FirebaseUser user) {
    CloudDatabase.updateFCMToken(
        collection: _collection, document: user.uid, key: db_key.fcmTokenDBKey);
  }

  @override
  Future<void> sendEmailVerification() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser firebaseUser = authResult.user;
    final bool isNewUser = authResult.additionalUserInfo.isNewUser;
    if (isNewUser) {
      await syncUserToDatabase(firebaseUser);
    }
    return <String, dynamic>{'user': firebaseUser, 'isNewUser': isNewUser};
  }

  @override
  Future<Map<String, dynamic>> signUp(String email, String password,
      String displayName, String phone, DateTime dob, String type) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    sendEmailVerification();
    final bool isNewUser = authResult.additionalUserInfo.isNewUser;
    final FirebaseUser firebaseUser = authResult.user;
    if (isNewUser) {
      await syncUserToDatabase(firebaseUser,
          displayName: displayName, phone: phone, dob: dob, type: type);
    }
    return <String, dynamic>{'user': firebaseUser, 'isNewUser': isNewUser};
  }

  @override
  Future<Map<String, dynamic>> signInWithFacebook() async {
    _facebookLogin = FacebookLogin();
    final FacebookLoginResult result =
    await _facebookLogin.logIn(<String>['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
        final FirebaseUser firebaseUser = authResult.user;
        final bool isNewUser = authResult.additionalUserInfo.isNewUser;
        if (isNewUser) {
          await syncUserToDatabase(firebaseUser);
        }
        return <String, dynamic>{'user': firebaseUser, 'isNewUser': isNewUser};
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(FacebookLoginStatus.error);
        throw Exception;
        break;
    }

    return null;
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult authResult =
    await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser firebaseUser = authResult.user;
    final bool isNewUser = authResult.additionalUserInfo.isNewUser;
    if (isNewUser) {
      await syncUserToDatabase(firebaseUser);
    }
    return <String, dynamic>{'user': firebaseUser, 'isNewUser': isNewUser};
  }

  @override
  Future<bool> signOut() async {
    _firebaseAuth.currentUser().then((FirebaseUser user) {
      print('Signing out ${user.uid}');
    });

    if (_googleSignIn != null) _googleSignIn.signOut();

    if (_facebookLogin != null) _facebookLogin.logOut();

    if (_firebaseAuth != null) _firebaseAuth.signOut();

    return true;
  }

  @override
  Future<void> sendPasswordResetLink(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  ///Add user to database if not already added
  Future<void> syncUserToDatabase(FirebaseUser user,
      {String displayName, String phone, DateTime dob, String type}) async {
    final _physiotherapy_collection = 'physiotherapists';
    if (type.toLowerCase() == "physiotherapist") {
      final Map<String, dynamic> map = <String, dynamic>{
        db_key.idDBKey: user.uid,
        db_key.displayNameDBKey:
        displayName == null ? user.displayName : displayName,
        db_key.emailDBKey: user.email,
        db_key.phoneDBKey: phone,
        db_key.dobDBKey: dob,
        db_key.patientIds: null,
        db_key.fcmTokenDBKey: null
      };

      await CloudDatabase.updateDocumentValueWithMap(
          collection: _physiotherapy_collection,
          document: user.uid,
          map: map,
          callback: () => onComplete(user));
    }
    else {
      final Map<String, dynamic> map = <String, dynamic>{
        db_key.idDBKey: user.uid,
        db_key.displayNameDBKey:
        displayName == null ? user.displayName : displayName,
        db_key.emailDBKey: user.email,
        db_key.phoneDBKey: phone,
        db_key.dobDBKey: dob,
        db_key.profileImageDBKey: user.photoUrl,
        db_key.coverImageDBKey: null,
        db_key.biographyDBKey: null,
        db_key.experiencesDBKey: null,
        db_key.currentBusinessDBKey: null,
        db_key.skillsDBKey: null,
        db_key.reviewsDBKey: null,
        db_key.eventIdsDBKey: null,
        db_key.favEventIdsKey: null,
        db_key.fcmTokenDBKey: null,
      };

      await CloudDatabase.updateDocumentValueWithMap(
          collection: _collection,
          document: user.uid,
          map: map,
          callback: () => onComplete(user));
    }
  }
}
