import 'package:camera/camera.dart';
import 'package:cookitup/profile.dart';
import 'package:cookitup/signUp.dart';
import 'package:cookitup/camera1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'home.dart'; // Import home.dart file
import 'signIn.dart';


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
 // List<CameraDescription> cameras = await availableCameras();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDogvM669-5nP3D8LbZLcEzuptydL8ac24",
      authDomain: "cookitup-23ba5.firebaseapp.com",
      databaseURL: "https://cookitup-23ba5-default-rtdb.firebaseio.com",
      projectId: "cookitup-23ba5",
      storageBucket: "cookitup-23ba5.appspot.com",
      messagingSenderId: "176953686036",
      appId: "1:176953686036:web:f441fe9f06a8ff0ab88f01",
      measurementId: "G-VJYLLY53GX"
    ),
  );
  runApp(MaterialApp(
   home: Home(),
   
 
  ));
}



