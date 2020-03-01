import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:physio_tracker_app/screens/account/image_type.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CloudStorage {
  static StorageReference getReference() {
    return FirebaseStorage.instance.ref();
  }

  static Future<List<String>> uploadImages(
      {@required String id,
      @required List<Asset> assets,
      @required ImageType imageType}) async {
    final List<String> uploadUrls = <String>[];
    try {
      await Future.wait(
          assets.map((Asset asset) async {
            final Metadata assetMeta = await asset.metadata;
            final StorageMetadata metaData =
                StorageMetadata(contentType: 'image/jpeg');

            final String hashCode = asset.hashCode.toString();

            final ByteData assetBytes = await asset.getByteData();
            final Uint8List uint8list = assetBytes.buffer.asUint8List();
            final List<int> intBytes = uint8list.cast<int>();

            int compressFactor;
            if (assetMeta.exif.pixelXDimension != null) {
              compressFactor =
                  (725 / assetMeta.exif.pixelXDimension * 100).toInt();
              if (compressFactor > 100) {
                compressFactor = 100;
              } else if (compressFactor < 0) {
                compressFactor = 0;
              }
            } else {
              throw Exception(
                  'One or more pictures are not correctly formatted');
            }
            print(compressFactor);

            final List<int> byteData =
                await FlutterImageCompress.compressWithList(
              intBytes,
              minWidth: 1920,
              quality: compressFactor,
            );

            final StorageReference reference =
                FirebaseStorage.instance.ref().child('$id$hashCode');
            final StorageUploadTask uploadTask =
                reference.putData(Uint8List.fromList(byteData), metaData);
            StorageTaskSnapshot storageTaskSnapshot;

            final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            if (snapshot.error == null) {
              storageTaskSnapshot = snapshot;
              final String downloadUrl =
                  await storageTaskSnapshot.ref.getDownloadURL();
              uploadUrls.add(downloadUrl);

              print('Upload success');
            } else {
              print('Error from image repo ${snapshot.error.toString()}');
              throw 'One or more pictures are not correctly formatted';
            }
          }),
          eagerError: true,
          cleanUp: (dynamic e) {
            print('eager cleaned up');
          });
    } catch (e) {
      print(e.toString());
      return null;
    }

    return uploadUrls;
  }
}
