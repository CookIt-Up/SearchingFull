import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookitup/searchingPage.dart';
import 'package:cookitup/upload_recipe.dart';
import 'package:flutter/material.dart';// Corrected import statement
import 'package:cookitup/recipe_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cookitup/camera1.dart';
import 'package:cookitup/profile.dart';
import 'package:cookitup/grocery.dart';
import 'package:cookitup/chatbot.dart';
import 'package:cookitup/filter.dart';


class Home extends StatelessWidget {
  const Home({Key? key});

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
        '/userProfile': (context) => UserProfileScreen(),
        '/camera': (context) => CameraScreen(),
        '/groceryList': (context) => GroceryListApp(),
        '/filter': (context) => FilterPage(),
        '/chatbot': (context) => ChatbotApp(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textFieldController = TextEditingController();
  String searchTitle = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E7D2),
      appBar: AppBar(
        backgroundColor: Color(0xFFD1E7D2),
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                // Navigate to UserProfileScreen using named route
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.account_circle,
                size: 30,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchingPage()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          right: 0,
          left: 0,
          bottom: 10,
        ),
        child: MainScreen(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFD1E7D2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterPage()),
                );
              },
              icon: Icon(Icons.soup_kitchen_sharp),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourRecipe()),
                );
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryListApp()),
                );
              },
              icon: Icon(Icons.list_alt_outlined),
            ),
            IconButton(
              onPressed: () {
               // Navigator.pushNamed(context, '/chatbot');
              },
              icon: Icon(Icons.person_4_sharp),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({Key? key});

  final CollectionReference recipe =
      FirebaseFirestore.instance.collection('recipe');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1E7D2),
      body: SafeArea(
        child: StreamBuilder(
          stream: recipe.orderBy('likes', descending: true).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  var document = snapshot.data.docs[index];
                  var title = document['title'];
                  var thumbnailPath = document['thumbnail'];

                  return FutureBuilder(
                    future: getImageUrl(thumbnailPath),
                    builder: (context, urlSnapshot) {
                      if (urlSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color.fromARGB(255, 255, 255, 255),
                          ),
                          strokeWidth: 2.0,
                        );
                      } else if (urlSnapshot.hasError) {
                        return Text('Error: ${urlSnapshot.error}');
                      } else {
                        var url = urlSnapshot.data as String;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailsPage(
                                  recipeSnapshot: document,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<String> getImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    final url = await ref.getDownloadURL();
    return url;
  }
}
