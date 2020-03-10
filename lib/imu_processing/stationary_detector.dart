
import 'package:vector_math/vector_math_64.dart' as vector;


class StationaryDetector {

  StationaryDetector();

  static const int framesToWait = 50;

  int frameCount = 0;
  vector.Quaternion backImuQuatInitial = vector.Quaternion.identity();
  vector.Quaternion leftFemurImuQuatInitial = vector.Quaternion.identity();
  vector.Quaternion rightTibiaImuQuatInitial= vector.Quaternion.identity();
  vector.Quaternion leftTibiaImuQuatInitial= vector.Quaternion.identity();
  vector.Quaternion rightFemurImuQuatInitial = vector.Quaternion.identity();

  double radiansThreshold = 0.0524; // 3 degrees

  bool isUserStationary(vector.Quaternion backImuQuat, vector.Quaternion leftFemurImuQuat, vector.Quaternion leftTibiaImuQuat,
    vector.Quaternion rightFemurImuQuat, vector.Quaternion rightTibiaImuQuat) {
      if (frameCount == 0) {
        backImuQuatInitial = backImuQuat;
        leftFemurImuQuatInitial = leftFemurImuQuat;
        leftTibiaImuQuatInitial = leftTibiaImuQuat;
        rightFemurImuQuatInitial = rightFemurImuQuat;
        rightTibiaImuQuatInitial = rightTibiaImuQuat;
      }

      frameCount++;

      if (frameCount >= framesToWait)
      {
        resetFrameCount();
      }

      return frameCount == 0 && (((backImuQuatInitial.conjugated())*backImuQuat).radians).abs() < radiansThreshold &&
        (((leftFemurImuQuatInitial.conjugated())*leftFemurImuQuat).radians).abs() < radiansThreshold &&
        (((leftTibiaImuQuatInitial.conjugated())*leftTibiaImuQuat).radians).abs() < radiansThreshold &&
        (((rightFemurImuQuatInitial.conjugated())*rightFemurImuQuat).radians).abs() < radiansThreshold &&
        (((rightTibiaImuQuatInitial.conjugated())*rightTibiaImuQuat).radians).abs() < radiansThreshold;

    }

    void resetFrameCount() {
      frameCount = 0;
    }


}