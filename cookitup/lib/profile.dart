import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ),
        body: Container(
          color: Colors.green[100], // Light green background color
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Village Food Channel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.verified,
                    color: Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '7.48M Followers . 142 Videos',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  );
                },
                child: Text('Edit Profile'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: FoodItemCard()),
                          SizedBox(width: 10),
                          Expanded(child: FoodItemCard()),
                          SizedBox(width: 10),
                          Expanded(child: FoodItemCard()),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: FoodItemCard()),
                          SizedBox(width: 10),
                          Expanded(child: FoodItemCard()),
                          SizedBox(width: 10),
                          Expanded(child: FoodItemCard()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 50,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          'Food Item',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.green[100], // Light green background color
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Village Food Channel',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '7.48M Followers . 42 Videos',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update profile picture
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: Text('Change Picture'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              color: Colors.black,
              child: ElevatedButton(
                onPressed: () {
                  // Implement logic to update profile
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                ),
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green[100], // Light green background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), // Top-left corner radius
            topRight: Radius.circular(20), // Top-right corner radius
          ),
        ),
        height: 150,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.save, color: Colors.black), // Black icon
              title: Text(
                'Saved',
                style: TextStyle(color: Colors.black), // Black text color
              ),
              onTap: () {
                // Handle "Saved" action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black), // Black icon
              title: Text(
                'About Us',
                style: TextStyle(color: Colors.black), // Black text color
              ),
              onTap: () {
                // Handle "About Us" action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.exit_to_app, color: Colors.black), // Black icon
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.black), // Black text color
              ),
              onTap: () {
                // Handle "Logout" action
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}


