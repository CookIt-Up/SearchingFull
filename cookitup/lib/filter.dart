
import 'package:flutter/material.dart';
import 'profile.dart';
import 'grocery.dart';
import 'home.dart';
import 'chatbot.dart';


class FilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define named routes
routes: {
        '/': (context) => filterScreen(),
        '/userProfile': (context) => UserProfileScreen(),
        '/groceryList': (context) => GroceryListApp(),
        '/main': (context) =>Home(),
        '/chatbot':(context) => ChatbotApp(),
        '/filter':(context) => FilterPage(),
      },
    );
  }
}

class filterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diets',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DietCircle(name: 'Keto'),
                    DietCircle(name: 'Paleo'),
                    DietCircle(name: 'Vegan'),
                    DietCircle(name: 'Vegetarian'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Occasions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DietCircle(name: 'Breakfast'),
                    DietCircle(name: 'Lunch'),
                    DietCircle(name: 'Dinner'),
                    DietCircle(name: 'Snacks'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DietCircle(name: 'Main Course'),
                    DietCircle(name: 'Side Dish'),
                    DietCircle(name: 'Dessert'),
                    DietCircle(name: 'Appetizer'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                 Navigator.pushNamed(context, '/main');
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

class DietCircle extends StatelessWidget {
  final String name;

  const DietCircle({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color.fromARGB(255, 78, 78, 78),
          
        ),
        SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
