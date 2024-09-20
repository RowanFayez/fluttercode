import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Firefighting App!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Clear the login status on log out
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn'); // Reset the login status

                // Navigate back to the sign-in screen
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
