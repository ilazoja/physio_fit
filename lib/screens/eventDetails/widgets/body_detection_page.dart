import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'dart:math' as math;

import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;


//// load csv

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

///

import 'package:csv/csv.dart' show CsvToListConverter;

class BodyDetectionPage extends StatefulWidget {
  final Storage storage;

  BodyDetectionPage({Key key,
  @required this.storage,
  @required this.currentSets,
  @required this.currentReps,
  @required this.totalSets,
  @required this.totalReps,
  @required this.message
  }) : super(key: key);

  double currentSets;
  double currentReps;
  int totalSets;
  int totalReps;
  String message;
  @override
  _BodyDetectionPageState createState() => _BodyDetectionPageState();
}

class _BodyDetectionPageState extends State<BodyDetectionPage> {
  ARKitConfiguration configuration = ARKitConfiguration.bodyTracking;

  ARKitAnchor constantBodyAnchor;

  ARKitController arkitController;
  ARKitNode node;
  String anchorId;
  String anchorName;

  ARKitNode spine;
  ARKitNode rootSpine;

  ARKitNode rootHip;
  ARKitNode leftRootHip;
  ARKitNode rightRootHip;

  ARKitNode rightShoulder;

  ARKitNode leftHip;
  ARKitNode leftKnee;
  ARKitNode leftHeel;
  ARKitNode leftToe;

  ARKitNode leftHipKnee;
  ARKitNode leftKneeHeel;
  ARKitNode leftHeelToe;

  ARKitNode rightHip;
  ARKitNode rightKnee;
  ARKitNode rightHeel;
  ARKitNode rightToe;

  ARKitNode rightHipKnee;
  ARKitNode rightKneeHeel;
  ARKitNode rightHeelToe;

  //var jointNode = new List(14);

  String anglesState;

  int numFrames;
  List<List<dynamic>> allAngles;
  List<List<dynamic>> allPositions;

  List<List<vector.Vector3>> skeleton;
  List<List<vector.Vector3>> skeletonAng;


  vector.Vector3 rightRootToHip = vector.Vector3(-6.5, -0.25, 3.5701).scaled(0.01);
  vector.Vector3 leftRootToHip = vector.Vector3(6.5, -0.25, 3.5701).scaled(0.01);
  vector.Quaternion faceStraightQuat;

  double footLength = 0.257; // in m
  double tibiaLength = 0.343677; // use formula
  double femurLength = 0.429181;
  double pelvisLength = 0.0742; // root to hip
  double spineLength = 0.71; // average

  bool startExercise = false;

  int currentIndex = 0;
  int incrementor = 2;

  String averageBodyAnchorId = "50A123";
  String averageBodyAnchorName = "AverageBodyAnchor";


  Matrix4 latestBodyAnchorTransform = Matrix4.identity();



  @override
  void initState(){
    super.initState();

    widget.storage.loadData().then((String value) {
      setState((){
        print("testinggggg");
        anglesState = value;
        allAngles = CsvToListConverter().convert(anglesState, fieldDelimiter: ",", eol: "\n");
        numFrames = allAngles.length;

        skeletonAng = new List<List<vector.Vector3>>();

        print(allAngles.length.toString());

        List<dynamic> firstFrame = allAngles[1];
        vector.Vector3 startingPosition = vector.Vector3(firstFrame[18], firstFrame[19], firstFrame[20]);

        vector.Vector3 startingOrientation = vector.Vector3(firstFrame[15], firstFrame[16], firstFrame[17]);
        vector.Vector3 relativeLeftRootToHip = leftRootToHip.clone();
        relativeLeftRootToHip.applyQuaternion(eulers2Quat(startingOrientation.scaled(pi/180)));
        vector.Vector3 relativeRightRootToHip = rightRootToHip.clone();
        relativeRightRootToHip.applyQuaternion(eulers2Quat(startingOrientation.scaled(pi/180)));

        vector.Vector3 relativeHipVector = relativeLeftRootToHip - relativeRightRootToHip;
        relativeHipVector[1] = 0; // get rid of y axis

        double correctionAngle = acos(relativeHipVector[0]/relativeHipVector.length);
        //correctionRotationVisualization = eulers2RotMatrix(correctionAngle);
        faceStraightQuat = vector.Quaternion.euler(correctionAngle, 0, 0);

        for(int frame = 1; frame < allAngles.length; frame++){

          List<dynamic> currentFrame = allAngles[frame];
          List<vector.Vector3> skelAngCurrentFrame = new List<vector.Vector3>();

          print(frame.toString());


          skelAngCurrentFrame.add((vector.Vector3(currentFrame[18], currentFrame[19], currentFrame[20]) - startingPosition).scaled(0.001)); // World_Root_Pos
          skelAngCurrentFrame.add(vector.Vector3(currentFrame[15], currentFrame[16], currentFrame[17])); // World_Root_Ang
          //skelAngCurrentFrame.add(vector.Vector3(currentFrame[15], currentFrame[16], currentFrame[17])); // World_Root_Ang


          skelAngCurrentFrame.add(vector.Vector3(currentFrame[9], currentFrame[10], currentFrame[11])); // Root_L_Femur
          skelAngCurrentFrame.add(vector.Vector3(currentFrame[12], currentFrame[13], currentFrame[14])); // Root_R_Femur

          skelAngCurrentFrame.add(vector.Vector3(currentFrame[1], 0, 0)); // L_Tibia_L_Femur
          skelAngCurrentFrame.add(vector.Vector3(currentFrame[5], 0, 0)); // R_Tibia_R_Femur

          skelAngCurrentFrame.add(vector.Vector3(currentFrame[2], currentFrame[3], currentFrame[4])); // L_Tibia_L_Foot
          skelAngCurrentFrame.add(vector.Vector3(currentFrame[5], currentFrame[6], currentFrame[7])); // R_Tibia_L_Foot
          skeletonAng.add(skelAngCurrentFrame);
        }

        print("testinggggg END");

      });

    });
  }

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  Future<bool> navigateBack() {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to skip your exercises?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Yes')),
              ],
            ) ??
            false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        //appBar: AppBar(title: const Text('Face Detection Sample')),
        appBar: AppBar(
          title: const Text('Hip Abduction'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => navigateBack(),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.teal,
              onPressed: () {
                //configuration = ARKitConfiguration.worldTracking;

                print("Container pressed");

                startExercise = true;
                addAveragedBodyAnchor();

              },
              child: Text("Sets: 1/3"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Stack(children: [
          Container(
              child: ARKitSceneView(
              configuration: configuration,
              onARKitViewCreated: onARKitViewCreated,
            ),
          ),
          Positioned(
            left: 320,
            top: -50,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              decoration: BoxDecoration( 
                color: Colors.white, 
                shape: BoxShape.circle),
              /*child: AutoSizeText (
                '# of Reps: ' + widget.currentReps.toString(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 40
                )
              ), */
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 335,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration( 
                color: Colors.white, 
                shape: BoxShape.rectangle),
              child: AutoSizeText (
                'Great!',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 30
                )
                
              ), 
            ),
          ),
         /* Positioned(
            left: 10,
            top: 500,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              child: AutoSizeText (
                'Feedback: ' + widget.message,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 40
                )
              ),
            ),
          ),*/
          Positioned(
            left: 350,
            top: 90,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              child: AutoSizeText (
                'Reps' + widget.message,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 25
                )
              ),
            ),
          ),
          Positioned(
            left: 340,
            top: 0,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              child: AutoSizeText (
                '3' + widget.message,
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 50
                )
              ),
            ),
          ),
          Positioned(
            left: 365,
            top: 20,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              child: AutoSizeText (
                '/' + widget.message,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 50
                )
              ),
            ),
          ),
          Positioned(
            left: 375,
            top: 48,
            child: Container(
              transform: latestBodyAnchorTransform,
              width: 200,
              height: 200,
              child: AutoSizeText (
                '10' + widget.message,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Open Sans',
                  fontSize: 30
                )
              ),
            ),
          ),
        ])
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = _handleAddAnchor;
    this.arkitController.onUpdateNodeForAnchor = _handleUpdateAnchor;


  }

  void _handleAddAnchor(ARKitAnchor anchor) {

    if (!(anchor is ARKitBodyAnchor)) {
      return;
    }
    final material = ARKitMaterial(fillMode: ARKitFillMode.lines);
    final ARKitBodyAnchor faceAnchor = anchor;

    //faceAnchor.geometry.materials.value = [material];

    anchorId = anchor.identifier;
    anchorName = anchor.nodeName;
    //node = ARKitNode();
    //arkitController.add(node, parentNodeName: anchor.nodeName);
//
    //rootHip = _createEye(faceAnchor.skeleton.modelTransforms["root"], Colors.yellow);
    //arkitController.add(rootHip, parentNodeName: anchor.nodeName);
    ////rightShoulder = _createEye(faceAnchor.skeleton.modelTransforms["rightShoulder"], Colors.yellow);
    ////arkitController.add(rightShoulder, parentNodeName: anchor.nodeName);
//
    //leftHip = _createEye(Matrix4.identity(), Colors.black);
    //arkitController.add(leftHip, parentNodeName: anchor.nodeName);
    //leftKnee = _createEye(Matrix4.identity(), Colors.black);
    //arkitController.add(leftKnee, parentNodeName: anchor.nodeName);
    //leftHeel = _createEye(Matrix4.identity(), Colors.black);
    //arkitController.add(leftHeel, parentNodeName: anchor.nodeName);
    //leftToe = _createEye(Matrix4.identity(), Colors.black);
    //arkitController.add(leftToe, parentNodeName: anchor.nodeName);
    //
    //rightHip = _createEye(Matrix4.identity(), Colors.red);
    //arkitController.add(rightHip, parentNodeName: anchor.nodeName);
    //rightKnee = _createEye(Matrix4.identity(), Colors.green);
    //arkitController.add(rightKnee, parentNodeName: anchor.nodeName);
    //rightHeel = _createEye(Matrix4.identity(), Colors.blue);
    //arkitController.add(rightHeel, parentNodeName: anchor.nodeName);
    //rightToe = _createEye(Matrix4.identity(), Colors.cyan);
    //arkitController.add(rightToe, parentNodeName: anchor.nodeName);
//
    //spine = _createEye(Matrix4.identity(), Colors.pink);
    //arkitController.add(spine, parentNodeName: anchor.nodeName);
//
//
    //rootSpine = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), spineLength);
    //arkitController.add(rootSpine, parentNodeName: anchor.nodeName);
//
    //leftRootHip = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), pelvisLength);
    //arkitController.add(leftRootHip, parentNodeName: anchor.nodeName);
    //rightRootHip = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), pelvisLength);
    //arkitController.add(rightRootHip, parentNodeName: anchor.nodeName);
//
    //leftHipKnee = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), femurLength);
    //arkitController.add(leftHipKnee, parentNodeName: anchor.nodeName);
    //leftKneeHeel = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), tibiaLength);
    //arkitController.add(leftKneeHeel, parentNodeName: anchor.nodeName);
    //leftHeelToe = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), footLength);
    //arkitController.add(leftHeelToe, parentNodeName: anchor.nodeName);
//
    //rightHipKnee = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), femurLength);
    //arkitController.add(rightHipKnee, parentNodeName: anchor.nodeName);
    //rightKneeHeel = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), tibiaLength);
    //arkitController.add(rightKneeHeel, parentNodeName: anchor.nodeName);
    //rightHeelToe = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), footLength);
    //arkitController.add(rightHeelToe, parentNodeName: anchor.nodeName);
  }

  ARKitNode _createEye(Matrix4 transform, Color color) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty(color: color),
    );
    final sphere = ARKitSphere(
        materials: [material], radius:0.05);

    return ARKitNode(geometry: sphere, position: position);
  }

  ARKitNode _createLineSegment(vector.Vector3 p1, vector.Vector3 p2) {

    final material = ARKitMaterial(
      diffuse: ARKitMaterialProperty(color: Colors.white),

    );

    final line = ARKitLine(
      fromVector: p1,
      toVector: p2,
      materials: [material],
    );

    return ARKitNode(geometry: line);
  }

  ARKitNode _createCylinder(vector.Vector3 p, vector.Vector4 r, double h) => ARKitNode(

      geometry: ARKitCylinder(
          radius: 0.05,//0.05,
          height: h,
          materials: _createLimbMaterial()),
       position: p,
       rotation: r,

       //eulerAngles:
    );

  List<ARKitMaterial> _createLimbMaterial() {
    return [
      ARKitMaterial(
        lightingModelName: ARKitLightingModel.physicallyBased,
        diffuse: ARKitMaterialProperty(
          color: Colors.white,
        ),
      )
    ];
  }

  List<ARKitMaterial> _createRandomColorMaterial() {
    return [
      ARKitMaterial(
        lightingModelName: ARKitLightingModel.physicallyBased,
        diffuse: ARKitMaterialProperty(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
        ),
      )
    ];
  }

  void addAveragedBodyAnchor() {
    //ARKitAnchor averagedBodyAnchor = ARKitAnchor(averageBodyAnchorName,averageBodyAnchorId, )
    //TransformAverager transformAverager = TransformAverager();
    //transformAverager.computeAverageTransform();
    node = ARKitNode();
    constantBodyAnchor = ARKitAnchor(averageBodyAnchorName,averageBodyAnchorId, latestBodyAnchorTransform);
    node.position.value = latestBodyAnchorTransform.getTranslation();
    vector.Quaternion latestBodyAnchorQuat = vector.Quaternion.fromRotation(latestBodyAnchorTransform.getRotation());
    node.rotation.value = vector.Vector4(latestBodyAnchorQuat.axis[0], latestBodyAnchorQuat.axis[1], latestBodyAnchorQuat.axis[2], latestBodyAnchorQuat.radians);
    arkitController.add(node);

    rootHip = _createEye(Matrix4.identity(), Colors.yellow);
    arkitController.add(rootHip, parentNodeName: node.name);
    //rightShoulder = _createEye(faceAnchor.skeleton.modelTransforms["rightShoulder"], Colors.yellow);
    //arkitController.add(rightShoulder, parentNodeName: anchor.nodeName);

    leftHip = _createEye(Matrix4.identity(), Colors.black);
    arkitController.add(leftHip, parentNodeName: node.name);
    leftKnee = _createEye(Matrix4.identity(), Colors.black);
    arkitController.add(leftKnee, parentNodeName: node.name);
    leftHeel = _createEye(Matrix4.identity(), Colors.black);
    arkitController.add(leftHeel, parentNodeName: node.name);
    leftToe = _createEye(Matrix4.identity(), Colors.black);
    arkitController.add(leftToe, parentNodeName: node.name);

    rightHip = _createEye(Matrix4.identity(), Colors.red);
    arkitController.add(rightHip, parentNodeName: node.name);
    rightKnee = _createEye(Matrix4.identity(), Colors.green);
    arkitController.add(rightKnee, parentNodeName: node.name);
    rightHeel = _createEye(Matrix4.identity(), Colors.blue);
    arkitController.add(rightHeel, parentNodeName: node.name);
    rightToe = _createEye(Matrix4.identity(), Colors.cyan);
    arkitController.add(rightToe, parentNodeName: node.name);

    spine = _createEye(Matrix4.identity(), Colors.pink);
    arkitController.add(spine, parentNodeName: node.name);


    rootSpine = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), spineLength);
    arkitController.add(rootSpine, parentNodeName: node.name);

    leftRootHip = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), pelvisLength);
    arkitController.add(leftRootHip, parentNodeName: node.name);
    rightRootHip = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), pelvisLength);
    arkitController.add(rightRootHip, parentNodeName: node.name);

    leftHipKnee = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), femurLength);
    arkitController.add(leftHipKnee, parentNodeName: node.name);
    leftKneeHeel = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), tibiaLength);
    arkitController.add(leftKneeHeel, parentNodeName: node.name);
    leftHeelToe = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), footLength);
    arkitController.add(leftHeelToe, parentNodeName: node.name);

    rightHipKnee = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), femurLength);
    arkitController.add(rightHipKnee, parentNodeName: node.name);
    rightKneeHeel = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), tibiaLength);
    arkitController.add(rightKneeHeel, parentNodeName: node.name);
    rightHeelToe = _createCylinder(vector.Vector3.zero(),vector.Vector4.zero(), footLength);
    arkitController.add(rightHeelToe, parentNodeName: node.name);

  }

  void updateBodyAnchorDistributions(Matrix4 currentBodyAnchorTransform) {
   /* currentBodyAnchorTransform.getRotation()
    currentBodyAnchorTransform.get
    bodyAnchorTransformSum += currentBodyAnchorTransform;
    if (bodyAnchorTransformQueue.length >= initialCapacity) {
      bodyAnchorTransformSum -= bodyAnchorTransformQueue.removeLast();
    }

    bodyAnchorTransformQueue.add(currentBodyAnchorTransform); */
    latestBodyAnchorTransform = currentBodyAnchorTransform;
  }

  void _handleUpdateAnchor(ARKitAnchor anchor) {
    if (anchor is ARKitBodyAnchor) {
      final ARKitBodyAnchor faceAnchor = anchor;
      //arkitController.updateFaceGeometry(node, anchor.identifier);

      updateBodyAnchorDistributions(anchor.transform);
      _updateRootHip(rootHip, faceAnchor.skeleton.modelTransforms["root"]);
      //_updateRightShoulder(rightShoulder, faceAnchor.skeleton.modelTransforms["rightShoulder"]);
    }
  }

  void _updateEye(ARKitNode node, Matrix4 transform) {
    final scale = vector.Vector3(1, 1, 1);
    node.scale.value = scale;

  }

void _updateRootHip(ARKitNode node, Matrix4 transform) {


   // print(transform.getColumn(0).x.toString() + " " + transform.getColumn(0).y.toString()  + " " + transform.getColumn(0).z.toString() );
   // print(transform.getColumn(1).x.toString() + " " + transform.getColumn(1).y.toString()  + " " + transform.getColumn(1).z.toString() );
   // print(transform.getColumn(2).x.toString() + " " + transform.getColumn(2).y.toString()  + " " + transform.getColumn(2).z.toString() );
   // print(transform.getColumn(3).x.toString() + " " + transform.getColumn(3).y.toString()  + " " + transform.getColumn(3).z.toString() );
    if (startExercise){
      //vector.Vector4 rootHipAxisAngle = rootHip.rotation.value;
      _updateOverlay(vector.Vector3(transform.getColumn(3).x, transform.getColumn(3).y,transform.getColumn(3).z));
      //vector.Quaternion.axisAngle(vector.Vector3(rootHipAxisAngle[0], rootHipAxisAngle[1], rootHipAxisAngle[2]), rootHipAxisAngle[3]));
    }
    else {
      rootHip.position.value = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );

    }

  }

void _updateOverlay(vector.Vector3 bodyRootPos)  {// vector.Quaternion bodyRootQuat) {

  List<vector.Vector3> jointAngles = skeletonAng[(currentIndex)]; //~/ 10];

  vector.Vector3 down = vector.Vector3(0, -1, 0);
  vector.Vector3 forward = vector.Vector3(0, 0, 1);
  vector.Vector3 up = vector.Vector3(0, 1, 0);

  vector.Quaternion flipQuat = vector.Quaternion.euler(0, pi, 0);
  vector.Quaternion ytozQuat = vector.Quaternion.euler(0, pi/2, 0);
  vector.Quaternion l_Root_Hip = vector.Quaternion.fromTwoVectors(leftRootToHip, vector.Vector3(0,1,0));
  vector.Quaternion r_Root_Hip = vector.Quaternion.fromTwoVectors(rightRootToHip, vector.Vector3(0,1,0));


  vector.Quaternion world_rootQuat = eulers2Quat(jointAngles[1].scaled(pi/180));
  vector.Quaternion l_Root_FemurQuat = eulers2Quat(jointAngles[2].scaled(pi/180));
  vector.Quaternion l_Femur_TibiaQuat = eulers2Quat(jointAngles[4].scaled(pi/180));
  vector.Quaternion l_Tibia_FootQuat = eulers2Quat(jointAngles[6].scaled(pi/180));
  vector.Quaternion r_Root_FemurQuat = eulers2Quat(jointAngles[3].scaled(pi/180));
  vector.Quaternion r_Femur_TibiaQuat = eulers2Quat(jointAngles[5].scaled(pi/180));
  vector.Quaternion r_Tibia_FootQuat = eulers2Quat(jointAngles[7].scaled(pi/180));

  vector.Quaternion recordingToBodyQuat = faceStraightQuat*world_rootQuat;

  vector.Vector3 rootPos = jointAngles[0].clone();
  rootPos.applyQuaternion(faceStraightQuat);
  bodyRootPos += rootPos;

  vector.Vector3 leftHipJoint = down.clone();
  vector.Quaternion leftHipOrientation = recordingToBodyQuat*l_Root_Hip;//*flipQuat;
  leftHipJoint.applyQuaternion(leftHipOrientation);
  leftHipJoint = bodyRootPos + leftHipJoint.scaled(pelvisLength);
  vector.Vector3 leftKneeJoint = down.clone();
  vector.Quaternion leftFemurOrientation = recordingToBodyQuat*l_Root_FemurQuat;//*flipQuat;
  leftKneeJoint.applyQuaternion(leftFemurOrientation);
  leftKneeJoint = leftHipJoint + leftKneeJoint.scaled(femurLength);
  vector.Vector3 leftHeelJoint = down.clone();
  vector.Quaternion leftTibiaOrientation = recordingToBodyQuat*l_Femur_TibiaQuat*l_Root_FemurQuat;//*flipQuat;
  leftHeelJoint.applyQuaternion(leftTibiaOrientation);
  leftHeelJoint = leftKneeJoint + leftHeelJoint.scaled(tibiaLength);
  vector.Vector3 leftToeJoint = up.clone();
  vector.Quaternion leftFootOrientation = recordingToBodyQuat*l_Femur_TibiaQuat*l_Root_FemurQuat*ytozQuat;//*l_Femur_TibiaQuat*l_Tibia_FootQuat;//*flipQuat;
  leftToeJoint.applyQuaternion(leftFootOrientation);
  leftToeJoint = leftHeelJoint + leftToeJoint.scaled(footLength);

  vector.Vector3 rightHipJoint = up.clone();
  vector.Quaternion rightHipOrientation = recordingToBodyQuat*r_Root_Hip*flipQuat;
  rightHipJoint.applyQuaternion(rightHipOrientation);
  rightHipJoint = bodyRootPos + rightHipJoint.scaled(pelvisLength);
  vector.Vector3 rightKneeJoint = up.clone();
  vector.Quaternion rightFemurOrientation = recordingToBodyQuat*r_Root_FemurQuat*flipQuat;
  rightKneeJoint.applyQuaternion(rightFemurOrientation);
  rightKneeJoint = rightHipJoint + rightKneeJoint.scaled(femurLength);
  vector.Vector3 rightHeelJoint = up.clone();
  vector.Quaternion rightTibiaOrientation = recordingToBodyQuat*r_Femur_TibiaQuat*r_Root_FemurQuat*flipQuat;
  rightHeelJoint.applyQuaternion(rightTibiaOrientation);
  rightHeelJoint = rightKneeJoint + rightHeelJoint.scaled(tibiaLength);
  vector.Vector3 rightToeJoint = up.clone();
  vector.Quaternion rightFootOrientation = recordingToBodyQuat*r_Femur_TibiaQuat*r_Root_FemurQuat*ytozQuat; //*r_Femur_TibiaQuat*r_Tibia_FootQuat*flipQuat;
  rightToeJoint.applyQuaternion(rightFootOrientation);
  rightToeJoint = rightHeelJoint + rightToeJoint.scaled(footLength);

  //recordingToBodyQuat*vector.Quaternion(0.707,0,0,0.707);
  double angle = lerpDouble(0, 0.707, currentIndex/skeletonAng.length);

  vector.Vector3 spineJoint = up.clone();
  spineJoint.applyQuaternion(recordingToBodyQuat);
  spineJoint = bodyRootPos + spineJoint;

  rootHip.position.value = bodyRootPos;

  leftHip.position.value = leftHipJoint;
  leftKnee.position.value = leftKneeJoint;
  leftHeel.position.value = leftHeelJoint;
  leftToe.position.value = leftToeJoint;

  rightHip.position.value = rightHipJoint;
  rightKnee.position.value = rightKneeJoint;
  rightHeel.position.value = rightHeelJoint;
  rightToe.position.value = rightToeJoint;

  spine.position.value = spineJoint;

  leftRootHip.position.value = bodyRootPos + (leftHipJoint - bodyRootPos)/2;
  leftRootHip.rotation.value = vector.Vector4(leftHipOrientation.axis[0], leftHipOrientation.axis[1], leftHipOrientation.axis[2], leftHipOrientation.radians);
  leftHipKnee.position.value = leftHipJoint + (leftKneeJoint - leftHipJoint)/2;
  leftHipKnee.rotation.value = vector.Vector4(leftFemurOrientation.axis[0], leftFemurOrientation.axis[1], leftFemurOrientation.axis[2], leftFemurOrientation.radians);
  leftKneeHeel.position.value = leftKneeJoint + (leftHeelJoint - leftKneeJoint)/2;
  leftKneeHeel.rotation.value = vector.Vector4(leftTibiaOrientation.axis[0], leftTibiaOrientation.axis[1], leftTibiaOrientation.axis[2], leftTibiaOrientation.radians);
  leftHeelToe.position.value = leftHeelJoint + (leftToeJoint - leftHeelJoint)/2;
  leftHeelToe.rotation.value = vector.Vector4(leftFootOrientation.axis[0], leftFootOrientation.axis[1], leftFootOrientation.axis[2], leftFootOrientation.radians);

  rightRootHip.position.value = bodyRootPos + (rightHipJoint - bodyRootPos)/2;
  rightRootHip.rotation.value = vector.Vector4(rightHipOrientation.axis[0], rightHipOrientation.axis[1], rightHipOrientation.axis[2], rightHipOrientation.radians);
  rightHipKnee.position.value = rightHipJoint + (rightKneeJoint - rightHipJoint)/2;
  rightHipKnee.rotation.value = vector.Vector4(rightFemurOrientation.axis[0], rightFemurOrientation.axis[1], rightFemurOrientation.axis[2], rightFemurOrientation.radians);
  rightKneeHeel.position.value = rightKneeJoint + (rightHeelJoint - rightKneeJoint)/2;
  rightKneeHeel.rotation.value = vector.Vector4(rightTibiaOrientation.axis[0], rightTibiaOrientation.axis[1], rightTibiaOrientation.axis[2], rightTibiaOrientation.radians);
  rightHeelToe.position.value = rightHeelJoint + (rightToeJoint - rightHeelJoint)/2;
  rightHeelToe.rotation.value = vector.Vector4(rightFootOrientation.axis[0], rightFootOrientation.axis[1], rightFootOrientation.axis[2], rightFootOrientation.radians);

  rootSpine.position.value = bodyRootPos + (spineJoint - bodyRootPos)/2;
  rootSpine.rotation.value = vector.Vector4(recordingToBodyQuat.axis[0], recordingToBodyQuat.axis[1], recordingToBodyQuat.axis[2], recordingToBodyQuat.radians);


  currentIndex += incrementor;
  if (currentIndex >= skeletonAng.length) {
    currentIndex = 0;
  }

}

vector.Quaternion eulers2Quat(vector.Vector3 eAngles){

  // XYZ
  return vector.Quaternion.fromRotation(eulers2RotMatrix(eAngles));

}

vector.Matrix3 eulers2RotMatrix(vector.Vector3 eAngles){

  // XYZ

  vector.Matrix3 rotx = rotX(eAngles[0]);
  vector.Matrix3 roty = rotY(eAngles[1]);
  vector.Matrix3 rotz = rotZ(eAngles[2]);

  roty.multiply(rotz);
  rotx.multiply(roty);

  return rotx;
}

vector.Vector3 rotMatrix2Eulers(vector.Matrix3 rotMatrix){

  // XYZ

  if (rotMatrix.row0[2] < 1)
  {
    if (rotMatrix.row0[2] > -1) {
      return vector.Vector3(atan2(-rotMatrix.row1[2],rotMatrix.row2[2]),asin(rotMatrix.row0[2]),atan2(-rotMatrix.row0[1],rotMatrix.row0[0]));
    }
    else{
      return vector.Vector3(-atan2(rotMatrix.row1[0],rotMatrix.row1[1]),-pi/2,0);
    }
  }
  else {
    return vector.Vector3(atan2(rotMatrix.row1[0],rotMatrix.row1[1]),pi/2,0);
  }
}

vector.Matrix3 rotX(double t) {
  double ct = cos(t);
  double st = sin(t);
  return vector.Matrix3(1, 0, 0, 0, ct, st, 0, -st, ct);
}

vector.Matrix3 rotY(double t) {
  double ct = cos(t);
  double st = sin(t);
  return vector.Matrix3(ct, 0, -st, 0, 1, 0, st, 0, ct);
}

vector.Matrix3 rotZ(double t) {
  double ct = cos(t);
  double st = sin(t);
  return vector.Matrix3(ct, st, 0, -st, ct, 0, 0, 0, 1);
}

void _updateRightShoulder(ARKitNode node, Matrix4 transform) {
    rightShoulder.position.value = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );

  }
}

class Storage {
  Future<String> loadPositions() async {
    return await rootBundle.loadString('assets/m06_s01_e01_positions.txt');
  }

  Future<String> loadAngles() async {
    return await rootBundle.loadString('assets/m06_s01_e01_angles.txt');
  }

  Future<String> loadData() async {
    return await rootBundle.loadString('assets/clean_hip_good_1.csv');
  }
}