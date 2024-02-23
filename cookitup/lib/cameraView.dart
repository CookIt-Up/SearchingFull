// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late CameraController cameraController;
//   late CameraImage cameraImage;
//   late List recognitionsList;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     loadModel();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     cameraController?.dispose();
//     Tflite.close();
//   }

//   Future<void> initializeCamera() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     final cameras = await availableCameras();
//     cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     await cameraController.initialize();
//     cameraController.startImageStream((CameraImage image) {
//       setState(() {
//         cameraImage = image;
//         runModel();
//       });
//     });
//   }

//   Future<void> loadModel() async {
//     Tflite.close();
//     await Tflite.loadModel(
//         model: "assets/ssd_mobilenet.tflite",
//         labels: "assets/ssd_mobilenet.txt");
//   }

//   Future<void> runModel() async {
//     if (cameraImage == null) return;
//     final List<dynamic> results = await Tflite.detectObjectOnFrame(
//       bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
//       imageHeight: cameraImage.height,
//       imageWidth: cameraImage.width,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       numResultsPerClass: 1,
//       threshold: 0.4,
//     );

//     setState(() {
//       recognitionsList = results;
//     });
//   }

//   List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
//     if (recognitionsList == null) return [];

//     double factorX = screen.width;
//     double factorY = screen.height;

//     return recognitionsList.map<Widget>((result) {
//       return Positioned(
//         left: result["rect"]["x"] * factorX,
//         top: result["rect"]["y"] * factorY,
//         width: result["rect"]["w"] * factorX,
//         height: result["rect"]["h"] * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(10.0)),
//             border: Border.all(color: Colors.pink, width: 2.0),
//           ),
//           child: Text(
//             "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               backgroundColor: Colors.pink,
//               color: Colors.black,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     List<Widget> list = [];

//     list.add(
//       Positioned(
//         top: 0.0,
//         left: 0.0,
//         width: size.width,
//         height: size.height - 100,
//         child: Container(
//           height: size.height - 100,
//           child: (!cameraController.value.isInitialized)
//               ? Container()
//               : AspectRatio(
//                   aspectRatio: cameraController.value.aspectRatio,
//                   child: CameraPreview(cameraController),
//                 ),
//         ),
//       ),
//     );

//     if (cameraImage != null) {
//       list.addAll(displayBoxesAroundRecognizedObjects(size));
//     }

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Container(
//           margin: EdgeInsets.only(top: 50),
//           color: Colors.black,
//           child: Stack(
//             children: list,
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() => runApp(MyApp());
