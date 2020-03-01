import 'package:cloud_functions/cloud_functions.dart';

void sendEventBookingConfirmation(
    String userEmail, String userName, String emailSubject, String body) {
  final HttpsCallable callable = CloudFunctions.instance
      .getHttpsCallable(functionName: 'httpsEventConfirmation');

  callable.call(<String, String>{
    'email': userEmail,
    'subject': emailSubject,
    'name': userName,
    'body': body,
  }).then((HttpsCallableResult res) => print(res.data));
}
