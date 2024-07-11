import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_vets_client/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false; // New state for password visibility

  // Focus nodes for managing focus on text fields
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _askNotificationPermission();
  }

  void _askNotificationPermission() async {
    // Check if notification permission is not granted
    if (!await Permission.notification.isGranted) {
      // Request notification permission
      PermissionStatus notificationStatus = await Permission.notification.request();
      
      // Check if notification permission is not granted
      if (notificationStatus != PermissionStatus.granted) {
        // Permission not granted, show alert dialog or handle as needed
        _showPermissionDeniedDialog('Notification');
      }
    }

    // Check if phone call permission is not granted
    if (!await Permission.phone.isGranted) {
      // Request phone call permission
      PermissionStatus phoneStatus = await Permission.phone.request();
      
      // Check if phone call permission is not granted
      if (phoneStatus != PermissionStatus.granted) {
        // Permission not granted, show alert dialog or handle as needed
        _showPermissionDeniedDialog('Phone');
      }
    }
  }
  
  void _showPermissionDeniedDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('This app needs access to $permissionType to function properly.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                openAppSettings(); // Open app settings to allow the user to grant permission
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotificationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Permission Required'),
          content: Text('Please grant notification permission to continue.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                _askNotificationPermission(); // Request notification permission again
              },
            ),
          ],
        );
      },
    );
  }

  void _loginUser(BuildContext context) async {
    String errorMessage = 'An unknown error occurred.'; // Default error message

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save token to shared preferences upon successful login
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', userCredential.user!.uid);

      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
      return; // Exit method if login is successful
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'The user corresponding to this email has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'network-request-failed':
          errorMessage = 'No internet connection.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid Password provided.';
          break;
        case 'channel-error':
          errorMessage = 'Please enter a valid Email or correct password';
          break;
        default:
          errorMessage = 'An unknown error occurred.';
          break;
      }
    } catch (e) {
      // Handle other exceptions (if any)
      errorMessage = 'An unknown error occurred.';
    }

    // Print the error message for debugging
    print("Error logging in: $errorMessage");

    // Display toast with the error message
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    // Clean up the focus nodes when the widget is disposed
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Ensure status bar icons are visible
    ));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          // Function to hide the keyboard when tapped outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/gradientBG.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FocusScope(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'OV',
                        style: GoogleFonts.aladin(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                offset: Offset(4, 5),
                              ),
                            ],
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    TextField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white, // Set cursor color here
                      onEditingComplete: () {
                        // Function to unfocus email field when editing is complete
                        _emailFocusNode.unfocus();
                      },
                    ),
                    TextField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_passwordVisible, // Toggle password visibility
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white, // Set cursor color here
                      onEditingComplete: () {
                        // Function to unfocus password field when editing is complete
                        _passwordFocusNode.unfocus();
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Function to unfocus both email and password fields
                        _emailFocusNode.unfocus();
                        _passwordFocusNode.unfocus();
                        _loginUser(context);
                      },
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Register here.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
