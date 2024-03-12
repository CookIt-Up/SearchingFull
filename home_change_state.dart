// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookitup/takevideo.dart';
import 'package:cookitup/recipe_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cookitup/camera1.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'grocery.dart';
import 'chatbot.dart';
import 'filter.dart';
import 'home_search.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
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
        //  '/home': (context) => HomeScreen(),
        '/userProfile': (context) => UserProfileScreen(),
        '/camera': (context) => CameraScreen(),
        '/groceryList': (context) => GroceryListApp(),
        '/filter': (context) => FilterPage(),
        '/chatbot': (context) => ChatbotApp(),
      },
    );
  }
}

TextEditingController textFieldController = TextEditingController();
String searchTitle = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showHomeSearch = false;
  bool showFilterPage = false;

  String recipe = "";
  List<DocumentSnapshot>? postDocumentsList;

  TextEditingController textFieldController = TextEditingController();
  String searchTitle = '';

  @override
  void initState() {
    super.initState();
    textFieldController.text = searchTitle; // Set the initial value
  }

  void initSearching(String value) {
    String searchQuery = value.toLowerCase();

    FirebaseFirestore.instance.collection("recipe").get().then((querySnapshot) {
      Set<String> uniqueTitles = {}; // Set to store unique titles
      List<DocumentSnapshot> filteredDocuments = [];

      querySnapshot.docs.forEach((doc) {
        var title = doc['title'].toLowerCase();
        if (title.contains(searchQuery) && !uniqueTitles.contains(title)) {
          uniqueTitles.add(title); // Add title to the set
          filteredDocuments.add(doc);
        }
      });

      setState(() {
        postDocumentsList = filteredDocuments;
      });
    }).catchError((error) {
      print("Error searching: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFD1E7D2),
        appBar: AppBar(
          backgroundColor: Color(0xFFD1E7D2),
          //automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to UserProfileScreen using named route
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen()),
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
                    onChanged: (value) {
                      setState(() {
                        showHomeSearch = false;
                        recipe = value;
                      });
                      initSearching(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Navigate to CameraView using named route
                Navigator.pushNamed(context, '/camera');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CameraScreen()),
                // );
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
        body: showHomeSearch
            ? HomeSearch(title: searchTitle)
            : (recipe.isNotEmpty && postDocumentsList != null)
                ? ListView.builder(
                    itemCount: postDocumentsList!.length,
                    itemBuilder: (context, index) {
                      var document = postDocumentsList![index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            searchTitle = document['title'];
                            showHomeSearch = true;
                          });
                        },
                        child: ListTile(
                          title: Text(document['title']),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        right: 0,
                        left: 0,
                        bottom: 10,
                      ),
                      child: MainScreen(),
                    ),
                  ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFFD1E7D2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Change this to MainAxisAlignment.spaceBetween
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/home');
                  },
                  icon: Icon(Icons.home),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      showFilterPage = true;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FilterPage()),
                    );
                  },
                  icon: Icon(Icons.soup_kitchen_sharp),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => YourRecipe()),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroceryListApp()),
                    );
                  },
                  icon: Icon(Icons.list_alt_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                  icon: Icon(Icons.person_4_sharp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final CollectionReference recipe =
      FirebaseFirestore.instance.collection('recipe');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFD1E7D2),
        body: SafeArea(
          child: StreamBuilder(
            stream: recipe.orderBy('likes', descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    var document = snapshot.data.docs[index];
                    var title = document['title'];

                    // Assuming 'thumbnail' field contains the path or name of the image in Firebase Storage
                    var thumbnailPath = document['thumbnail'];

                    return FutureBuilder(
                      future: getImageUrl(thumbnailPath),
                      builder: (context, urlSnapshot) {
                        if (urlSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            // Define the color of the CircularProgressIndicator
                            valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 255, 255, 255)),

                            // Define the thickness of the CircularProgressIndicator
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
                                      recipeSnapshot: document),
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
      ),
    );
  }

  Future<String> getImageUrl(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    final url = await ref.getDownloadURL();
    return url;
  }
}
