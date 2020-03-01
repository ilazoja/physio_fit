import 'package:flutter/material.dart';
import 'package:physio_tracker_app/helpers/stringHelper.dart';
import 'package:physio_tracker_app/services/cloudStorage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:physio_tracker_app/widgets/shared/circularProgressDialog.dart';
import 'package:physio_tracker_app/screens/account/image_type.dart';

class ImageUploadHelper {
  static Future<void> profileImageUpload(
      String uid, BuildContext context, Function callback) async {
    await handleImageUpload(uid, ImageType.PROFILE, context, callback);
  }

  static Future<void> coverImageUpload(
      String uid, BuildContext context, Function callback) async {
    await handleImageUpload(uid, ImageType.COVER, context, callback);
  }

  static Future<void> handleImageUpload(String uid, ImageType imageType,
      BuildContext context, Function callback) async {
    print(uid);

    final List<Asset> resultList = await MultiImagePicker.pickImages(
      maxImages: 1,
    );

    if (resultList.isNotEmpty) {
      CircularProgressDialog(context, () async {
        try {
          CloudStorage.uploadImages(
                  id: '${uid}/${StringHelper.getImageTypeString(imageType)}',
                  assets: resultList,
                  imageType: ImageType.EVENT)
              .then((dynamic url) {
            if (url != null) {
              callback(uid, url[0], imageType);
            }
            Navigator.pop(context);
          });
        } on Exception catch (e) {
          print(e);
          Navigator.pop(context);
        }
      });
    }
  }
}
