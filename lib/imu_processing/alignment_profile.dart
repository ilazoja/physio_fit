import 'package:vector_math/vector_math_64.dart' as vector;


class AlignmentProfile {

  // alignment mapping
  vector.Quaternion quatBackImuToBody = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatLeftFemurImuToBody = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatLeftTibiaImuToBody = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatRightFemurImuToBody = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatRightTibiaImuToBody = vector.Quaternion(0,0,0,1);

  AlignmentProfile(vector.Quaternion backImuQuat, vector.Quaternion leftFemurImuQuat, vector.Quaternion leftTibiaImuQuat,
    vector.Quaternion rightFemurImuQuat, vector.Quaternion rightTibiaImuQuat) {
    // There's a better way to do this, stay tuned.
    vector.Vector3 yBody = vector.Vector3(0, 0, 1);
    vector.Vector3 zImu = backImuQuat.asRotationMatrix().transposed().row2;
    vector.Vector3 xBody = zImu.cross(yBody).normalized();
    vector.Vector3 zBody = xBody.cross(yBody);

    vector.Matrix3 rotGlobalToBody = vector.Matrix3.columns(xBody, yBody, zBody).transposed();
    vector.Quaternion quatGlobalToBody = vector.Quaternion.fromRotation(rotGlobalToBody);

    quatBackImuToBody = quatGlobalToBody*backImuQuat;
    quatLeftFemurImuToBody = quatGlobalToBody*leftFemurImuQuat;
    quatLeftTibiaImuToBody = quatGlobalToBody*leftTibiaImuQuat;
    quatRightFemurImuToBody = quatGlobalToBody*rightFemurImuQuat;
    quatRightTibiaImuToBody = quatGlobalToBody*rightTibiaImuQuat;
  }

}