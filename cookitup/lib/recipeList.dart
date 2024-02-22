import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'recipeList.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel(); // Load TFLite model when the widget is initialized
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/quantized_model_float16.tflite',
      labels: 'assets/labels.txt',
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 10, // Set to higher value to detect multiple objects
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (output != null && output.isNotEmpty) {
      for (var result in output) {
        double confidence = result['confidence'];
        if (confidence > 0.3) {
          String detectedLabel = result['label'];
          // Check if the detected label exists in Firestore as an ingredient
          FirebaseFirestore.instance.collection('ingredient').doc(detectedLabel).get().then((ingredientDoc) {
            if (ingredientDoc.exists) {
              var ingredientData = ingredientDoc.data();
              if (ingredientData != null) {
                ingredientData.keys.forEach((key) {
                  var ingredientValue = ingredientData[key];
                  
                  FirebaseFirestore.instance.collection('recipe').get().then((recipeQuerySnapshot) {
                    recipeQuerySnapshot.docs.forEach((recipeDoc) {
                      if (recipeDoc.id == ingredientValue) {
                        // Access the title of the recipe and print it
                        var title = recipeDoc['title'];
                        print('Recipe ID: ${recipeDoc.id}, Title: $title');
                        // Print the title on the screen
                        print(title); // Adjust this part according to your screen printing logic
                      }
                    });
                  }).catchError((error) {
                    print('Error fetching documents: $error');
                  });
                });
              }
            }
          }).catchError((error) {
            print('Error fetching ingredient document: $error');
          });
        } else {
          print('No objects recognized!');
        }
      }
    }
  }
  
  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    pickImage();
    return Container(); // No need for any UI, as the detected labels are printed in the logs
  }
}


