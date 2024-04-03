import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:tflite/tflite.dart';
import 'camera_search.dart';

// Define a global variable to store the list of cameras
late List<CameraDescription> cameras;

// Define a function to load the TensorFlow Lite model
loadModel() async {
  // Load the model from the assets folder
  await Tflite.loadModel(
    model: "assets/last.tflite",
    labels: "assets/last.txt",
  );
}

// Define a function to get the list of cameras
getCameras() async {
  // Get the available cameras
  cameras = await availableCameras();
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isModelRunning = false;
  bool isCameraInitialized = false;
  String result = "";
  Set<String> detectedLabels = {};

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await loadModel();
      await getCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller.initialize();
      setState(() {
        isCameraInitialized = true;
      });
      controller.startImageStream((CameraImage img) {
        runModel(img);
      });
    } catch (e) {
      print("Error initializing camera: $e");
      setState(() {
        isCameraInitialized = false;
      });
    }
  }

  void runModel(CameraImage img) async {
    // Check if the widget is still mounted
    if (!mounted) {
      return;
    }

    // Check if the model is already running
    if (isModelRunning) {
      return;
    }

    // Set the flag to indicate that the model is running
    isModelRunning = true;

    try {
      // Convert the camera image to a list of bytes
      var bytesList = img.planes.map((plane) {
        return plane.bytes;
      }).toList();

      // Run the model on the image bytes
      var output = await Tflite.runModelOnFrame(
        bytesList: bytesList,
        imageHeight: img.height,
        imageWidth: img.width,
        numResults: 2, // The number of classes in the model
        threshold: 0.7, // The confidence threshold for the result
      );

      // Initialize an empty list to store the labels and confidences
      List<String> labels = [];

      // Check if the output is not null
      if (output != null && output.isNotEmpty) {
        // Iterate through the output list and concatenate labels and confidences
        for (var i = 0; i < output.length; i++) {
          String label = output[i]["label"];
          double confidence = output[i]["confidence"];
          labels.add("$label");
        }
      } else {
        // Handle the case where output is null or empty
        //labels.add("No result"); // Or any other appropriate message
      }

      // Set the state and update the result, only if the widget is still mounted
      if (mounted) {
        setState(() {
          detectedLabels.addAll(labels);
          result = labels.join('\n');
          print(detectedLabels);
        });
      }
    } finally {
      // Reset the flag to indicate that the model is not running anymore
      isModelRunning = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("What is in your kitchen"),
    ),
    body: Stack(
      children: <Widget>[
        if (isCameraInitialized)
          CameraPreview(controller),
        if (detectedLabels.isNotEmpty)
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.black54,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: detectedLabels.map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(
                          label,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFFD1E7D2),
                        deleteIconColor: Colors.black,
                        onDeleted: () {
                          setState(() {
                            detectedLabels.remove(label);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
      ],
    ),
floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return CameraSearch(documentIds: detectedLabels);
        },
      ),
    );
  },
  backgroundColor: Color(0xFFD1E7D2),
  foregroundColor: Colors.white,
  elevation: 3.0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: Text("Stop"),
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

  );
    
 
}

}
