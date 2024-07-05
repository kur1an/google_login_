import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Sign-In with MongoDB'),
        ),
        body: SignInDemo(),
      ),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? result = await _googleSignIn.signIn();
      if (result != null) {
        print('User signed in: ${result.displayName}');
        final response = await http.post(
          Uri.parse('http://192.168.1.34:5555'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'googleId': result.id,
            'displayName': result.displayName ?? '',
            'email': result.email,
          }),
        );
        if (response.statusCode == 201) {
          print('User stored in MongoDB');
        } else {
          print('Failed to store user');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _handleSignIn,
        child: Text('Sign in with Google'),
      ),
    );
  }
}
