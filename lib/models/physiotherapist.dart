import '../dbKeys.dart' as db_key;


class Physiotherapist {
  Physiotherapist(
      {this.id,
        this.displayName,
        this.email,
        this.phone,
        this.dob,
        this.patientIds,
        this.fcmToken});

  factory Physiotherapist.fromMap(Map<String, dynamic> data) {
    return Physiotherapist(
        id: data[db_key.idDBKey],
        displayName: data[db_key.displayNameDBKey] ?? '',
        email: data[db_key.emailDBKey] ?? '',
        phone: data[db_key.phoneDBKey] ?? '',
        dob: data[db_key.dobDBKey] == null
            ? null
            : data[db_key.dobDBKey].toDate(),
        patientIds: data[db_key.patientIds] ?? <String>[],
        fcmToken: data[db_key.fcmTokenDBKey] ?? '');
  }

  //  When you add a new field, remember to add it in
  //  the syncUserToDatabase method in services/authentication
  String id;
  String displayName;
  String email;
  String phone;
  DateTime dob;
  List<dynamic> patientIds;
  String fcmToken;
}
