
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

// Define a global variable to store the list of cameras
late List<CameraDescription> cameras ;

// Define a function to load the TensorFlow Lite model
 loadModel() async {
  // Load the model from the assets folder
  await Tflite.loadModel(
    model: "assets/quantized_model_float16.tflite",
    labels: "assets/labels.txt",
  );
}

// Define a function to get the list of cameras
 getCameras() async {
  // Get the available cameras
  cameras = await availableCameras();
}

// Define a widget for the main screen
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// Define the state of the main screen widget
class _MainScreenState extends State<MainScreen> {
  // Define a variable to store the camera controller
 late CameraController controller;
// Define a variable to track whether the model is currently running
bool isModelRunning = false;
  // Define a variable to store the image classification result
  String result = "";

  //list
  Set<String> detectedLabels = {};

  // Define a function to initialize the camera controller
  void initCamera() {
    // Create a camera controller with the first camera and a resolution preset
    controller = CameraController(cameras[0], ResolutionPreset.medium);

    // Initialize the controller and start the camera preview
    controller.initialize().then((_) {
      // Check if the widget is mounted
      if (!mounted) {
        return;
      }

      // Set the state and start the camera stream
      setState(() {
        controller.startImageStream((CameraImage img) {
          // Run the TensorFlow Lite model on the camera image
          runModel(img);
        });
      });
    });
  }

// Define a function to run the TensorFlow Lite model on the camera image
void runModel(CameraImage img) async {
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
      labels.add("No result"); // Or any other appropriate message
    }

    // Set the state and update the result
    setState(() {
      detectedLabels.addAll(labels);
      result = labels.join('\n');
    });
  } finally {
    // Reset the flag to indicate that the model is not running anymore
    isModelRunning = false;
  }
}




  void onStopButtonPressed() {
    print(detectedLabels);
  }
  

  // Define a function to dispose the camera controller
  @override
  void dispose() {
    // Dispose the controller and stop the camera stream
    controller?.dispose();
    super.dispose();
  }

  // Define a function to build the widget

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Teachable Machine Demo"),
    ),
    body: Container(
      alignment: Alignment.center,
      child: controller.value.isInitialized
          ? Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CameraPreview(controller),
                // Add an elevated button at the bottom
                Positioned(
                  bottom: 16.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add functionality for the elevator button here
                      onStopButtonPressed();
                    },
                    child: Text("Stop"),
                  ),
                ),
                // Create a text widget to display the result
                Text(
                  result,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Text("Loading..."),
    ),
  );
}

  // Define a function to run when the widget is created
  @override
  void initState() {
    // Call the super method
    super.initState();
    // Initialize the camera controller
    initCamera();
  }
}

// Define the main function
void runAppWithModel() async {
    WidgetsFlutterBinding.ensureInitialized();
  // Load the TensorFlow Lite model
   await loadModel();
  // Get the list of cameras
  await getCameras();
  // Run the app
  runApp(MaterialApp(
    home: MainScreen(),
  ));
}

