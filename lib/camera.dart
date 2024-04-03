import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late File _image;
  final picker = ImagePicker();
  List<String> detectedRecipeTitles = [];
  
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
  List<String> titles = [];
  for (var result in output) {
    double confidence = result['confidence'];
    if (confidence > 0.3) {
      String detectedLabel = result['label'];
      // Check if the detected label exists in Firestore as an ingredient
      var ingredientDoc = await FirebaseFirestore.instance.collection('ingredient').doc(detectedLabel).get();
      if (ingredientDoc.exists) {
        var ingredientData = ingredientDoc.data();
        if (ingredientData != null) {
          for (var key in ingredientData.keys) {
            var ingredientValue = ingredientData[key];
            var recipeQuerySnapshot = await FirebaseFirestore.instance.collection('recipe').get();
            recipeQuerySnapshot.docs.forEach((recipeDoc) {
              if (recipeDoc.id == ingredientValue) {
                var title = recipeDoc['title'];
                print('Recipe ID: ${recipeDoc.id}, Title: $title');
                titles.add(title);
              }
            });
          }
        }
      }
    } else {
      print('No objects recognized!');
    }
  }
  setState(() {
    detectedRecipeTitles = titles;
  });
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
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Titles'),
      ),
      body: ListView.builder(
        itemCount: detectedRecipeTitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(detectedRecipeTitles[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}