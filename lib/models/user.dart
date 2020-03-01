import '../dbKeys.dart' as db_key;


class User {
  User(
      {this.id,
      this.biography,
      this.coverImage,
      this.currentBusiness,
      this.displayName,
      this.email,
      this.phone,
      this.dob,
      this.eventIds,
      this.favEventIds,
      this.experiences,
      this.skills,
      this.profileImage,
      this.reviews,
      this.fcmToken,
      });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        id: data[db_key.idDBKey],
        biography: data[db_key.biographyDBKey] ?? '',
        coverImage: data[db_key.coverImageDBKey] ?? '',
        currentBusiness: data[db_key.currentBusinessDBKey] ?? <dynamic, dynamic>{},
        displayName: data[db_key.displayNameDBKey] ?? '',
        email: data[db_key.emailDBKey] ?? '',
        phone: data[db_key.phoneDBKey] ?? '',
        dob: data[db_key.dobDBKey] == null
            ? null
            : data[db_key.dobDBKey].toDate(),
        eventIds: data[db_key.eventIdsDBKey] ?? <String>[],
        favEventIds: data[db_key.favEventIdsKey] ?? <String>[],
        experiences: data[db_key.experiencesDBKey] ?? '',
        skills: data[db_key.skillsDBKey] ?? '',
        profileImage: data[db_key.profileImageDBKey] ?? '',
        reviews: data[db_key.reviewsDBKey] ?? '',
        fcmToken: data[db_key.fcmTokenDBKey] ?? '');
  }

  //  When you add a new field, remember to add it in
  //  the syncUserToDatabase method in services/authentication
  String id;
  String biography;
  String coverImage;
  Map<dynamic, dynamic> currentBusiness;
  String displayName;
  String email;
  String phone;
  DateTime dob;
  List<dynamic> eventIds;
  List<dynamic> favEventIds;
  String experiences;
  String skills;
  String profileImage;
  String reviews;
  String fcmToken;
}
