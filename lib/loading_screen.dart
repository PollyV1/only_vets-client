import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  LoadingScreen({required this.navigatorKey});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoadingProcess();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _startLoadingProcess() {
    _timer = Timer(Duration(seconds: 5), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    bool isLoggedIn = await _verifyToken(token);

    print('Token: $token');
    print('Is Logged In: $isLoggedIn');

    String initialRoute = isLoggedIn ? '/home' : '/login';
    widget.navigatorKey.currentState?.pushReplacementNamed(initialRoute);
  }

  Future<bool> _verifyToken(String? token) async {
    if (token == null) return false;

    // Add your token verification logic here.
    // For example, make a network request to verify the token with your server.

    try {
      // Simulate network request
      await Future.delayed(Duration(seconds: 1));
      // Replace the line below with your actual token verification logic
      bool isValid = true; // Assume the token is valid for demonstration purposes

      return isValid;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/gradientBG.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Container(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                  child: Text(
                    'Dr. Orozco',
                    style: GoogleFonts.acme(
                      textStyle: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.2),
                Container(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                  child: Text(
                    'The Best Care For your Pets',
                    style: GoogleFonts.acme(
                      textStyle: const TextStyle(color: Colors.white, fontSize: 52),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Image.asset('assets/images/dogCat.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
