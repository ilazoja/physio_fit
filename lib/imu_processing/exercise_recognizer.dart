

import 'dart:collection';
import 'dart:math' as math;
import 'dart:math';

import 'package:vector_math/vector_math_64.dart' as vector;
import 'alignment_profile.dart';
import 'stationary_detector.dart';


class ExerciseRecognizer {
  vector.Vector3 rightRootToHip = vector.Vector3(-6.5, -0.25, 3.5701).scaled(0.01);
  vector.Vector3 leftRootToHip = vector.Vector3(6.5, -0.25, 3.5701).scaled(0.01);

  ExerciseRecognizer(AlignmentProfile alignmentProfile) {
    this.alignmentProfile = alignmentProfile;
    this.stationaryDetector = StationaryDetector();
  }

  // idle thresholds

  double back_XY_Idle_Threshold = 0;
  double back_XY_Idle_Range = 20;
  double back_YZ_Idle_Threshold = 0;
  double back_YZ_Idle_Range = 20;

  double L_Femur_XY_Idle_Threshold = 0;
  double L_Femur_XY_Idle_Range = 20;
  double L_Femur_YZ_Idle_Threshold = 0;
  double L_Femur_YZ_Idle_Range = 20;
  double L_Femur_XZ_Idle_Threshold = 0;
  double L_Femur_XZ_Idle_Range = 60;

  double R_Femur_XY_Idle_Threshold = 0;
  double R_Femur_XY_Idle_Range = 20;
  double R_Femur_YZ_Idle_Threshold = 0;
  double R_Femur_YZ_Idle_Range = 40;
  double R_Femur_XZ_Idle_Threshold = 0;
  double R_Femur_XZ_Idle_Range = 60;

  double L_Knee_Idle_Threshold = 0;
  double L_Knee_Idle_Range = 20;
  double R_Knee_Idle_Threshold = 0;
  double R_Knee_Idle_Range = 20;

  // low thresholds

  double back_XY_Exercise_Min_Threshold = 0;
  double back_XY_Exercise_Min_Range = 20;
  double back_YZ_Exercise_Min_Threshold = 0;
  double back_YZ_Exercise_Min_Range = 20;

  double L_Femur_XY_Exercise_Min_Threshold = 0;
  double L_Femur_XY_Exercise_Min_Range = 20;
  double L_Femur_YZ_Exercise_Min_Threshold = 0;
  double L_Femur_YZ_Exercise_Min_Range = 20;
  double L_Femur_XZ_Exercise_Min_Threshold = 0;
  double L_Femur_XZ_Exercise_Min_Range = 100;

  double R_Femur_XY_Exercise_Min_Threshold = 0;
  double R_Femur_XY_Exercise_Min_Range = 40;
  double R_Femur_YZ_Exercise_Min_Threshold = 0;
  double R_Femur_YZ_Exercise_Min_Range = 40;
  double R_Femur_XZ_Exercise_Min_Threshold = 0;
  double R_Femur_XZ_Exercise_Min_Range = 100;

  double L_Knee_Exercise_Min_Threshold = 0;
  double L_Knee_Exercise_Min_Range = 40;
  double R_Knee_Exercise_Min_Threshold = 0;
  double R_Knee_Exercise_Min_Range = 10;

  // high thresholds

  double back_XY_Exercise_Max_Threshold = 0;
  double back_XY_Exercise_Max_Range = 20;
  double back_YZ_Exercise_Max_Threshold = 0;
  double back_YZ_Exercise_Max_Range = 30;

  double L_Femur_XY_Exercise_Max_Threshold = 0;
  double L_Femur_XY_Exercise_Max_Range = 20;
  double L_Femur_YZ_Exercise_Max_Threshold = 0;
  double L_Femur_YZ_Exercise_Max_Range = 20;
  double L_Femur_XZ_Exercise_Max_Threshold = 0;
  double L_Femur_XZ_Exercise_Max_Range = 100;

  double R_Femur_XY_Exercise_Max_Threshold = 0;
  double R_Femur_XY_Exercise_Max_Range = 40;
  double R_Femur_YZ_Exercise_Max_Threshold = 0;
  double R_Femur_YZ_Exercise_Max_Range = 40;
  double R_Femur_XZ_Exercise_Max_Threshold = 0;
  double R_Femur_XZ_Exercise_Max_Range = 100;

  double L_Knee_Exercise_Max_Threshold = 0;
  double L_Knee_Exercise_Max_Range = 40;
  double R_Knee_Exercise_Max_Threshold = 80;
  double R_Knee_Exercise_Max_Range = 20;


  List<vector.Vector3> weights = [vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1),
    vector.Vector3(1,1,1)];


  // variance threshold
  double variance_threshold = 10;
  //double end_exercise_variance_threshold = 10;

  // exercise count

  double number_of_repetitions = 10;
  double number_of_sets = 3;
  double time_between_each_set = 0;


  /////////

  // queues
  static const int framesToWait = 250;

  // Todo (maybe) need to implement proper mean, (probs not even worth)
  vector.Quaternion backImuQuatMean = vector.Quaternion(0,0,0,0);
  vector.Quaternion leftFemurImuQuatMean = vector.Quaternion(0,0,0,0);
  vector.Quaternion leftTibiaImuQuatMean = vector.Quaternion(0,0,0,0);
  vector.Quaternion rightFemurImuQuatMean = vector.Quaternion(0,0,0,0);
  vector.Quaternion rightTibiaImuQuatMean = vector.Quaternion(0,0,0,0);

  // alignment mapping
  //vector.Quaternion quatBackImuToBody = vector.Quaternion(0,0,0,1);
  //vector.Quaternion quatLeftFemurImuToBody = vector.Quaternion(0,0,0,1);
  //vector.Quaternion quatLeftTibiaImuToBody = vector.Quaternion(0,0,0,1);
  //vector.Quaternion quatRightFemurImuToBody = vector.Quaternion(0,0,0,1);
  //vector.Quaternion quatRightTibiaImuToBody = vector.Quaternion(0,0,0,1);

  AlignmentProfile alignmentProfile;
  StationaryDetector stationaryDetector;

  // quaternion body angles
  vector.Quaternion quatWorldToRoot = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatLeftRootToFemur = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatRightRootToFemur = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatLeftFemurToTibia = vector.Quaternion(0,0,0,1);
  vector.Quaternion quatRightFemurToTibia = vector.Quaternion(0,0,0,1);

  // projected
  double projXY_Root_Ang = 0;
  double projYZ_Root_Ang = 0;
  double projXY_L_Femur_Ang = 0;
  double projYZ_L_Femur_Ang = 0;
  double projXZ_L_Foot_Ang = 0;
  double projXY_R_Femur_Ang = 0;
  double projYZ_R_Femur_Ang = 0;
  double projXZ_R_Foot_Ang = 0;
  double proj_L_Femur_L_Tibia = 0;
  double proj_R_Femur_R_Tibia = 0;

  // min, max
  double minProjXY_Root_Ang = 0;
  double minProjYZ_Root_Ang = 0;
  double minProjXY_L_Femur_Ang = 0;
  double minProjYZ_L_Femur_Ang = 0;
  double minProjXZ_L_Foot_Ang = 0;
  double minProjXY_R_Femur_Ang = 0;
  double minProjYZ_R_Femur_Ang = 0;
  double minProjXZ_R_Foot_Ang = 0;
  double minProj_L_Femur_L_Tibia = 0;
  double minProj_R_Femur_R_Tibia = 0;

  double maxProjXY_Root_Ang = 0;
  double maxProjYZ_Root_Ang = 0;
  double maxProjXY_L_Femur_Ang = 0;
  double maxProjYZ_L_Femur_Ang = 0;
  double maxProjXZ_L_Foot_Ang = 0;
  double maxProjXY_R_Femur_Ang = 0;
  double maxProjYZ_R_Femur_Ang = 0;
  double maxProjXZ_R_Foot_Ang = 0;
  double maxProj_L_Femur_L_Tibia = 0;
  double maxProj_R_Femur_R_Tibia = 0;

  // exercise state

  double repetitionsCompleted = 0;
  double setsCompleted = 0;

  //List<vector.Vector3> differencesFromThreshold = List<vector.Vector3>();
  int state = 0;
  double restTimeStart = 0;

  // outputs, read these depending on state

  String message;
  List<double> accuracyRatings = List<double>();

  int processIMU(vector.Quaternion backImuQuat, vector.Quaternion leftFemurImuQuat, vector.Quaternion leftTibiaImuQuat,  vector.Quaternion rightFemurImuQuat, vector.Quaternion rightTibiaImuQuat) {
      bool userIsStationary = stationaryDetector.isUserStationary(backImuQuat, leftFemurImuQuat, leftTibiaImuQuat, rightFemurImuQuat, rightTibiaImuQuat);
      // TODO: coult evaluate to true on come up and come down (maybe not a big deal, but possible)
      switch (state) {
        case -1: { // Align
          if (userIsStationary) {
            state = 0;
            alignmentProfile = AlignmentProfile(backImuQuat, leftFemurImuQuat, leftTibiaImuQuat, rightFemurImuQuat, rightTibiaImuQuat);
          }

        }
        break;
        case 0: { // Idle
          calculateQuatJointAngles(backImuQuat, leftFemurImuQuat, leftTibiaImuQuat, rightFemurImuQuat, rightTibiaImuQuat);
          calculateProjectionJointAngles();
          if (userIsStationary && isUserInsideIdleThreshold()) {
            state = 1;

          } // TODO: timeout if not in idle, ask user to realign sensor, reset frame count
        }
        break;
        case 1: { // Start Exercise
          calculateQuatJointAngles(backImuQuat, leftFemurImuQuat, leftTibiaImuQuat, rightFemurImuQuat, rightTibiaImuQuat);
          calculateProjectionJointAngles();
          if (!isUserInsideIdleThreshold()) {
            state = 2;
          }
        }
        break;
        case 2: { // End Exercise
          calculateQuatJointAngles(backImuQuat, leftFemurImuQuat, leftTibiaImuQuat, rightFemurImuQuat, rightTibiaImuQuat);
          calculateProjectionJointAngles();
          if (userIsStationary) {
            assessExercise();
            repetitionsCompleted++;
            if (repetitionsCompleted >= number_of_repetitions) {
              setsCompleted++;
              if (setsCompleted >= number_of_sets) {
                state = 4;
              }
              else {
                state = 3;
              }

            }
            else {
              state = 0;
            }

          }
        }
        break;
        case 3: { // Rest Time
          if (isRestTimeCompleted()) {
            state = 0;

          }
        }

        break;

        default: {

        }
        break;
      }
      return state;
    }// output state

  void resetAngleDistributions()
  {
      minProjXY_Root_Ang = 0;
      minProjYZ_Root_Ang = 0;
      minProjXY_L_Femur_Ang = 0;
      minProjYZ_L_Femur_Ang = 0;
      minProjXZ_L_Foot_Ang = 0;
      minProjXY_R_Femur_Ang = 0;
      minProjYZ_R_Femur_Ang = 0;
      minProjXZ_R_Foot_Ang = 0;
      minProj_L_Femur_L_Tibia = 0;
      minProj_R_Femur_R_Tibia = 0;

      maxProjXY_Root_Ang = 0;
      maxProjYZ_Root_Ang = 0;
      maxProjXY_L_Femur_Ang = 0;
      maxProjYZ_L_Femur_Ang = 0;
      maxProjXZ_L_Foot_Ang = 0;
      maxProjXY_R_Femur_Ang = 0;
      maxProjYZ_R_Femur_Ang = 0;
      maxProjXZ_R_Foot_Ang = 0;
      maxProj_L_Femur_L_Tibia = 0;
      maxProj_R_Femur_R_Tibia = 0;
  }

  void updateAngleDistributions() {

    minProjXY_Root_Ang = min(minProjXY_Root_Ang, projXY_Root_Ang);
    minProjYZ_Root_Ang = min(minProjYZ_Root_Ang, projYZ_Root_Ang);
    minProjXY_L_Femur_Ang = min(minProjXY_L_Femur_Ang, projXY_L_Femur_Ang);
    minProjYZ_L_Femur_Ang = min(minProjYZ_L_Femur_Ang, projYZ_L_Femur_Ang);
    minProjXZ_L_Foot_Ang = min(minProjXZ_L_Foot_Ang, projXZ_L_Foot_Ang);
    minProjXY_R_Femur_Ang = min(minProjXY_R_Femur_Ang, projXY_R_Femur_Ang);
    minProjYZ_R_Femur_Ang = min(minProjYZ_R_Femur_Ang, projYZ_R_Femur_Ang);
    minProjXZ_R_Foot_Ang = min(minProjXZ_R_Foot_Ang, projXZ_R_Foot_Ang);
    minProj_L_Femur_L_Tibia = min(minProj_L_Femur_L_Tibia, proj_L_Femur_L_Tibia);
    minProj_R_Femur_R_Tibia = min(minProj_R_Femur_R_Tibia, proj_R_Femur_R_Tibia);

    maxProjXY_Root_Ang = max(maxProjXY_Root_Ang, projXY_Root_Ang);
    maxProjYZ_Root_Ang = max(maxProjYZ_Root_Ang, projYZ_Root_Ang);
    maxProjXY_L_Femur_Ang = max(maxProjXY_L_Femur_Ang, projXY_L_Femur_Ang);
    maxProjYZ_L_Femur_Ang = max(maxProjYZ_L_Femur_Ang, projYZ_L_Femur_Ang);
    maxProjXZ_L_Foot_Ang = max(maxProjXZ_L_Foot_Ang, projXZ_L_Foot_Ang);
    maxProjXY_R_Femur_Ang = max(maxProjXY_R_Femur_Ang, projXY_R_Femur_Ang);
    maxProjYZ_R_Femur_Ang = max(maxProjYZ_R_Femur_Ang, projYZ_R_Femur_Ang);
    maxProjXZ_R_Foot_Ang = max(maxProjXZ_R_Foot_Ang, projXZ_R_Foot_Ang);
    maxProj_L_Femur_L_Tibia = max(maxProj_L_Femur_L_Tibia, proj_L_Femur_L_Tibia);
    maxProj_R_Femur_R_Tibia = max(maxProj_R_Femur_R_Tibia, proj_R_Femur_R_Tibia);

  }

  void calculateQuatJointAngles(vector.Quaternion backImuQuat, vector.Quaternion leftFemurImuQuat, vector.Quaternion leftTibiaImuQuat,  vector.Quaternion rightFemurImuQuat, vector.Quaternion rightTibiaImuQuat) {

    vector.Quaternion quatWorldToRoot = alignmentProfile.quatBackImuToBody*backImuQuat.conjugated();
    vector.Quaternion quatGlobalToLeftFemur = alignmentProfile.quatLeftFemurImuToBody*leftFemurImuQuat.conjugated();
    vector.Quaternion quatGlobalToLeftTibia = alignmentProfile.quatLeftTibiaImuToBody*leftTibiaImuQuat.conjugated();
    vector.Quaternion quatGlobalToRightFemur = alignmentProfile.quatRightFemurImuToBody*rightFemurImuQuat.conjugated();
    vector.Quaternion quatGlobalToRightTibia = alignmentProfile.quatRightTibiaImuToBody*rightTibiaImuQuat.conjugated();

    quatWorldToRoot = quatWorldToRoot;
    quatLeftRootToFemur = quatGlobalToLeftFemur*quatWorldToRoot.conjugated();
    quatRightRootToFemur = quatGlobalToRightFemur*quatWorldToRoot.conjugated();
    quatLeftFemurToTibia = quatGlobalToLeftTibia*quatGlobalToLeftFemur.conjugated();
    quatRightFemurToTibia = quatGlobalToRightTibia*quatGlobalToRightFemur.conjugated();
  }

  void calculateProjectionJointAngles() {
    vector.Vector3 down = vector.Vector3(0, -1, 0);
    vector.Vector3 forward = vector.Vector3(0, 0, 1);
    vector.Vector3 up = vector.Vector3(0, 1, 0);


    vector.Vector3 relativeLeftRootToHip = leftRootToHip.clone();
    relativeLeftRootToHip.applyQuaternion(quatWorldToRoot);
    vector.Vector3 relativeRightRootToHip = rightRootToHip.clone();
    relativeRightRootToHip.applyQuaternion(quatWorldToRoot);

    //vector.Vector3 World_Root_Position = vector.Vector3(0,0,0);

    vector.Vector3 relativeHipVector = relativeLeftRootToHip - relativeRightRootToHip;
    relativeHipVector[1] = 0; // get rid of y axis
    double correctionAngle = acos(relativeHipVector[1]/relativeHipVector.length);
    vector.Quaternion faceStraightQuat = vector.Quaternion.euler(0, correctionAngle, 0);

    vector.Vector3 backBody = up.clone();
    backBody.applyQuaternion(faceStraightQuat*quatWorldToRoot);
    projXY_Root_Ang = acos(backBody[1]/(vector.Vector2(backBody[0], backBody[1]).length))*180/pi;
    projYZ_Root_Ang = acos(backBody[1]/(vector.Vector2(backBody[1], backBody[2]).length))*180/pi;

    vector.Vector3 femurbody_L = down.clone();
    femurbody_L.applyQuaternion(faceStraightQuat*quatWorldToRoot*quatLeftRootToFemur);
    projXY_L_Femur_Ang = acos(-femurbody_L[1]/(vector.Vector2(femurbody_L[0], femurbody_L[1]).length))*180/pi;
    projYZ_L_Femur_Ang = acos(-femurbody_L[1]/(vector.Vector2(femurbody_L[1], femurbody_L[2]).length))*180/pi;

    vector.Vector3 femurfootbody_L = forward.clone();
    femurfootbody_L.applyQuaternion(faceStraightQuat*quatWorldToRoot*quatLeftRootToFemur);
    projXZ_L_Foot_Ang = acos(femurfootbody_L[2]/(vector.Vector2(femurfootbody_L[0], femurfootbody_L[2]).length))*180/pi;

    vector.Vector3 femurbody_R = down.clone();
    femurbody_R.applyQuaternion(faceStraightQuat*quatWorldToRoot*quatRightRootToFemur);
    projXY_R_Femur_Ang = acos(-femurbody_R[1]/(vector.Vector2(femurbody_R[0], femurbody_R[1]).length))*180/pi;
    projYZ_R_Femur_Ang = acos(-femurbody_R[1]/(vector.Vector2(femurbody_R[1], femurbody_R[2]).length))*180/pi;

    vector.Vector3 femurfootbody_R = forward.clone();
    femurfootbody_R.applyQuaternion(faceStraightQuat*quatWorldToRoot*quatRightRootToFemur);
    projXZ_R_Foot_Ang = acos(femurfootbody_R[2]/(vector.Vector2(femurfootbody_R[0], femurfootbody_R[2]).length))*180/pi;

    proj_L_Femur_L_Tibia = quatLeftFemurToTibia.radians*180/pi;
    proj_R_Femur_R_Tibia = quatRightFemurToTibia.radians*180/pi;
  }

  void assessExercise() {
    List<vector.Vector3> differencesFromThreshold = List<vector.Vector3>();

    differencesFromThreshold.add(assessAngle(minProjXY_Root_Ang, maxProjXY_Root_Ang, projXY_Root_Ang,
      back_XY_Exercise_Min_Threshold, back_XY_Exercise_Max_Threshold, back_XY_Idle_Threshold,
      back_XY_Exercise_Min_Range, back_XY_Exercise_Max_Range, back_XY_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjYZ_Root_Ang, maxProjYZ_Root_Ang, projYZ_Root_Ang,
      back_YZ_Exercise_Min_Threshold, back_YZ_Exercise_Max_Threshold, back_YZ_Idle_Threshold,
      back_YZ_Exercise_Min_Range, back_YZ_Exercise_Max_Range, back_YZ_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjXY_L_Femur_Ang, maxProjXY_L_Femur_Ang, projXY_L_Femur_Ang,
      L_Femur_XY_Exercise_Min_Threshold, L_Femur_XY_Exercise_Max_Threshold, L_Femur_XY_Idle_Threshold,
      L_Femur_XY_Exercise_Min_Range, L_Femur_XY_Exercise_Max_Range, L_Femur_XY_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjYZ_L_Femur_Ang, maxProjYZ_L_Femur_Ang, projYZ_L_Femur_Ang,
      L_Femur_YZ_Exercise_Min_Threshold, L_Femur_YZ_Exercise_Max_Threshold, L_Femur_YZ_Idle_Threshold,
      L_Femur_YZ_Exercise_Min_Range, L_Femur_YZ_Exercise_Max_Range, L_Femur_YZ_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjXZ_L_Foot_Ang, maxProjXZ_L_Foot_Ang, projXZ_L_Foot_Ang,
      L_Femur_XZ_Exercise_Min_Threshold, L_Femur_XZ_Exercise_Max_Threshold, L_Femur_XZ_Idle_Threshold,
      L_Femur_XZ_Exercise_Min_Range, L_Femur_XZ_Exercise_Max_Range, L_Femur_XZ_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjXY_R_Femur_Ang, maxProjXY_R_Femur_Ang, projXY_R_Femur_Ang,
      R_Femur_XY_Exercise_Min_Threshold, R_Femur_XY_Exercise_Max_Threshold, R_Femur_XY_Idle_Threshold,
      R_Femur_XY_Exercise_Min_Range, R_Femur_XY_Exercise_Max_Range, R_Femur_XY_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjYZ_R_Femur_Ang, maxProjYZ_R_Femur_Ang, projYZ_R_Femur_Ang,
      R_Femur_YZ_Exercise_Min_Threshold, R_Femur_YZ_Exercise_Max_Threshold, R_Femur_YZ_Idle_Threshold,
      R_Femur_YZ_Exercise_Min_Range, R_Femur_YZ_Exercise_Max_Range, R_Femur_YZ_Idle_Range));

    differencesFromThreshold.add(assessAngle(minProjXZ_R_Foot_Ang, maxProjXZ_R_Foot_Ang, projXZ_R_Foot_Ang,
      R_Femur_XZ_Exercise_Min_Threshold, R_Femur_XZ_Exercise_Max_Threshold, R_Femur_XZ_Idle_Threshold,
      R_Femur_XZ_Exercise_Min_Range, R_Femur_XZ_Exercise_Max_Range, R_Femur_XZ_Idle_Range));

  }

  vector.Vector3 assessAngle(double minAngle, double maxAngle, double idleAngle, double minThreshold, double maxThreshold, double idleThreshold, double minRange, double maxRange, double idleRange) {
    vector.Vector3 differenceFromThreshold = vector.Vector3.zero();

    if (minAngle < minThreshold - minRange/2) {
      differenceFromThreshold[0] = (minAngle - (minThreshold - minRange)).abs();
    }
    else if (minAngle > minThreshold + minRange/2) {
       differenceFromThreshold[0] = (minAngle - (minThreshold + minRange)).abs();
    }
    if (maxAngle < maxThreshold - maxRange/2) {
      differenceFromThreshold[1] = (maxAngle - (maxThreshold - maxRange)).abs();
    }
    else if (maxAngle > maxThreshold + maxRange/2) {
       differenceFromThreshold[1] = (maxAngle - (maxThreshold + maxRange)).abs();
    }
    if (idleAngle < idleThreshold - idleRange/2) {
      differenceFromThreshold[2] = (idleAngle - (idleThreshold - idleRange)).abs();
    }
    else if (idleAngle > idleThreshold + idleRange/2) {
       differenceFromThreshold[2] = (idleAngle - (idleThreshold + idleRange)).abs();
    }

    return differenceFromThreshold;

  }

  void assignScoreAndGiveFeedback(List<vector.Vector3> errors) {
    double weightedSum = 0;

    //for (int i = 0; i)

    //double score

    //accuracyRatings.add()

  }

  bool isUserInsideIdleThreshold(){
    return projXY_Root_Ang > back_XY_Idle_Threshold - back_XY_Idle_Range/2 //... % must be standing straight still first before exercise begins
                && projXY_Root_Ang < back_XY_Idle_Threshold + back_XY_Idle_Range/2
                && projYZ_Root_Ang > back_YZ_Idle_Threshold - back_YZ_Idle_Range/2
                && projYZ_Root_Ang < back_YZ_Idle_Threshold + back_YZ_Idle_Range/2
                && projXY_L_Femur_Ang > L_Femur_XY_Idle_Threshold - L_Femur_XY_Idle_Range/2
                && projXY_L_Femur_Ang < L_Femur_XY_Idle_Threshold + L_Femur_XY_Idle_Range/2
                && projYZ_L_Femur_Ang > L_Femur_YZ_Idle_Threshold - L_Femur_YZ_Idle_Range/2
                && projYZ_L_Femur_Ang < L_Femur_YZ_Idle_Threshold + L_Femur_YZ_Idle_Range/2
                && projXZ_L_Foot_Ang > L_Femur_XZ_Idle_Threshold - L_Femur_XZ_Idle_Range/2
                && projXZ_L_Foot_Ang < L_Femur_XZ_Idle_Threshold + L_Femur_XZ_Idle_Range/2
                && projXY_R_Femur_Ang > R_Femur_XY_Idle_Threshold - R_Femur_XY_Idle_Range/2
                && projXY_R_Femur_Ang < R_Femur_XY_Idle_Threshold + R_Femur_XY_Idle_Range/2
                && projYZ_R_Femur_Ang > R_Femur_YZ_Idle_Threshold - R_Femur_YZ_Idle_Range/2
                && projYZ_R_Femur_Ang < R_Femur_YZ_Idle_Threshold + R_Femur_YZ_Idle_Range/2
                && projXZ_R_Foot_Ang > R_Femur_XZ_Idle_Threshold - R_Femur_XZ_Idle_Range/2
                && projXZ_R_Foot_Ang < R_Femur_XZ_Idle_Threshold + R_Femur_XZ_Idle_Range/2
                && proj_L_Femur_L_Tibia > L_Knee_Idle_Threshold - L_Knee_Idle_Range/2
                && proj_L_Femur_L_Tibia < L_Knee_Idle_Threshold + L_Knee_Idle_Range/2
                && proj_R_Femur_R_Tibia > R_Knee_Idle_Threshold - R_Knee_Idle_Range/2
                && proj_R_Femur_R_Tibia < R_Knee_Idle_Threshold + R_Knee_Idle_Range/2;
  }

  bool isRestTimeCompleted() {
    return true;
  }
}