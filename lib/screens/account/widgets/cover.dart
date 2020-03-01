import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:physio_tracker_app/themeData.dart';
import 'coverImage.dart';
import 'profileImage.dart';
import '../../../copyDeck.dart' as copy;

typedef VoidCallback = void Function();

class Cover extends StatelessWidget {
  const Cover(
      {this.isVerified,
      this.screenSize,
      this.coverUploadCallback,
      this.profileUploadCallback,
      this.coverImageStr,
      this.profileImageStr});

  final bool isVerified;
  final Size screenSize;
  final String coverImageStr;
  final String profileImageStr;

  final VoidCallback coverUploadCallback;
  final Function profileUploadCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: coverUploadCallback,
      child: Stack(
        children: <Widget>[
          CoverImage(screenSize: screenSize, coverImageStr: coverImageStr, isVerified: isVerified),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 6.4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    leftSection(),
                    middleSection(),
                    rightSection(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded leftSection() {
    return Expanded(
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(16.0)),
          Text('0', style: accountTheme.followNumStyle),
          Text(copy.following,
              style: const TextStyle(
                  fontFamily: mainFont,
                  color: Color(0xff8C8C8C),
                  fontSize: 12)),
        ],
      ),
    );
  }

  Center middleSection() {
    return Center(
      child: GestureDetector(
          onTap: profileUploadCallback,
          behavior: HitTestBehavior.translucent,
          child: ProfileImage(profileImageStr,
              profileUploadCallback: profileUploadCallback))
    );
  }

  Expanded rightSection() {
    return Expanded(
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(16.0)),
          Text('0', style: accountTheme.followNumStyle),
          Text(copy.followers,
              style: const TextStyle(
                  fontFamily: mainFont,
                  color: Color(0xff8C8C8C),
                  fontSize: 12)),
        ],
      ),
    );
  }
}
