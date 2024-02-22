import 'package:flutter/material.dart';
import 'camera.dart';
import 'package:flutter/services.dart';
import 'profile.dart';
import 'grocery.dart';
import 'filter.dart';
import 'chatbot.dart';




class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      // Define named routes
      routes: {
        '/': (context) => HomeScreen(),
        '/userProfile': (context) => UserProfileScreen(),
        '/cameraView': (context) => CameraView(),
        '/groceryList': (context) => GroceryListApp(),
        //'/filter': (context) => Filter(),
        '/chatbot':(context) => ChatbotApp(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E7D2),
      appBar: AppBar(
        titleSpacing: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Navigate to UserProfileScreen using named route
                Navigator.pushNamed(context, '/userProfile');
              },
              icon: Icon(Icons.account_circle),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to CameraView using named route
              Navigator.pushNamed(context, '/cameraView');
            },
            icon: Icon(Icons.camera_alt),
          ),
          IconButton(
            onPressed: () {
              // Handle voice icon pressed
            },
            icon: Icon(Icons.mic),
          ),
        ],
      ),
      body: Container(
        
      ), // Placeholder
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Handle icon 1 pressed
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                 Navigator.pushNamed(context, '/filter');
              },
              icon: Icon(Icons.soup_kitchen_sharp),
            ),
            IconButton(
              onPressed: () {
                // Handle icon 3 pressed
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/groceryList');
              },
              icon: Icon(Icons.list_alt_outlined),
              
            ),
            IconButton(
              onPressed: () {
               Navigator.pushNamed(context, '/chatbot');
              },
              icon: Icon(Icons.person_4_sharp),
            ),
          ],
        ),
      ),
    );
  }
}
