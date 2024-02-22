import 'package:flutter/material.dart';
import 'home.dart';
import 'chatbot.dart';
import 'profile.dart';
import 'filter.dart';

class GroceryListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GroceryListScreen(),
      routes: {
        //'/': (context) => filterScreen(),
        '/userProfile': (context) => UserProfileScreen(),
        '/groceryList': (context) => GroceryListApp(),
        '/main': (context) =>Home(),
        '/chatbot':(context) => ChatbotApp(),
        '/filter':(context) => FilterPage(),
      },
    );
  }
}

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<String> groceryItems = [
    'Apples',
    'Bananas',
    'Milk',
    'Bread',
    'Eggs',
    'Chicken',
    'Rice',
    'Pasta',
  ];

  List<bool> checkedItems = List<bool>.generate(8, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: Container(
        color: Colors.green[100], // Background color for the entire page
        child: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(groceryItems[index]),
              value: checkedItems[index],
              onChanged: (value) {
                setState(() {
                  checkedItems[index] = value!;
                });
              },
              activeColor: Colors.transparent, // Removes color of the checkmark when checked
            );
          },
        ),
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