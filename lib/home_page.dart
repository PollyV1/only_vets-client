// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_vets_client/disclaimer.dart';
import 'package:only_vets_client/location_page.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the external_app_launcher package

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final phoneNumber = "09611666193";
  String userLocation = '';

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userLocation = userDoc['location'] ?? 'Unknown Location';
        });
      }
    }
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to white
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(162, 116, 57, 1),
      statusBarIconBrightness: Brightness.light, // Ensure status bar icons are visible
    ));

    double statusBarHeight = MediaQuery.of(context).padding.top;
    double docImageHeight = MediaQuery.of(context).size.width * 0.66; // Adjust as needed

    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the check to complete, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == false) {
          // If the user is not logged in, navigate to the login page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          });
          return Container(); // Return an empty container while navigating
        } else {
          // User is logged in, show the HomePage content
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(61, 52, 52, 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Other Functions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 70),
                        Row(
                          children: [
                            const Text(
                              'User Location: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              userLocation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Change User Location'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Disclaimer'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DisclaimerPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      _confirmSignOut(context);
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/gradientBG.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: statusBarHeight,
                  left: 0,
                  right: 0,
                  child: ClipPath(
                    clipper: BottomRoundedClipper(),
                    child: Image.asset(
                      'assets/images/doc.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: statusBarHeight,
                  left: 16,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: statusBarHeight + docImageHeight, left: 15, right: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Orozco',
                          style: GoogleFonts.acme(
                            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'M-F  8:00 AM - 5:00 PM',
                              style: GoogleFonts.acme(
                                textStyle: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'About the Clinic',
                          style: GoogleFonts.acme(
                            textStyle: const TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Based in Brgy. Santa Cruz, Naga City. Dr. Orozco has been in service for the past 10 years caring different breeds of cats and dogs and under different mild to severe conditions.',
                            style: GoogleFonts.acme(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'You may contact him below by:',
                            style: GoogleFonts.acme(
                              textStyle: const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        _buildGrid(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    List<String> gridItems = [
      'Clinic Location',
      'Messenger',
      'Email',
      'Phone Number',
    ];

    List<String> imageFiles = [
      'assets/images/clinic.png',
      'assets/images/message.png',
      'assets/images/email.png',
      'assets/images/phone.png',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1.38,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            _onGridItemClick(context, index);
          },
          child: Card(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageFiles[index],
                  height: 50,
                  width: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  gridItems[index],
                  style: GoogleFonts.acme(
                    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onGridItemClick(BuildContext context, int index) async {
    switch (index) {
      case 0:
        // Handle Clinic Location click
        String googleMapsUrl = 'https://maps.app.goo.gl/o8b1B4itCmGfHDGU9';

        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing by clicking outside
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Redirecting to Google Maps'),
              content: const Text('You will now be redirected to Google Maps to view the clinic location.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'), // Add a Cancel button
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(dialogContext).pop(); // Close the dialog

                    try {
                      // Attempt to launch Google Maps URL
                      await launch(googleMapsUrl);
                    } catch (e) {
                      // Error handling if launch fails
                      print('Error launching Google Maps URL: $e');
                      try {
                        // Try opening Google Maps app directly
                        await LaunchApp.openApp(
                          androidPackageName: 'com.google.android.apps.maps',
                          iosUrlScheme: 'comgooglemaps://',
                          appStoreLink: 'https://apps.apple.com/us/app/google-maps-transit-food/id585027354',
                        );
                      } catch (launchAppError) {
                        // Error handling if opening Google Maps app fails
                        print('Error opening Google Maps app: $launchAppError');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Could not open Google Maps. Please try again later.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
        break;

      case 1:
        // Handle Messenger click
        String messengerUrl = 'http://m.me/';
        try {
          // Attempt to launch Messenger URL
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Redirecting to Messenger'),
                content: const Text('You will now be directed to Messenger to message the Vet.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'), // Add a Cancel button
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      await launch(messengerUrl);
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Error handling if launch fails
          print('Error launching Messenger URL: $e');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Could not open Messenger. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        break;

      case 2:
        // Handle Email click
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: 'jbetito@gbox.adnu.edu.ph',
          queryParameters: {
            'subject': 'Appointment',
          },
        );
        try {
          // Attempt to launch email client
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Redirecting to Mail'),
                content: const Text('You will now be directed to Mail to message the Vet.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'), // Add a Cancel button
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () async {
                      await launch(emailLaunchUri.toString());
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Error handling if launch fails
          print('Error launching email client: $e');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Could not open email client. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        break;

      case 3:
        // Handle Phone Number click
        final Uri phoneLaunchUri = Uri(
          scheme: 'tel',
          path: '09611666193',
        );
        try {
          // Attempt to launch phone dialer
          await launch(phoneLaunchUri.toString());
        } catch (e) {
          // Error handling if launch fails
          print('Error launching phone dialer: $e');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Could not open phone dialer. Please try again later.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        break;

      default:
        // Handle default case
        break;
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token'); // Remove the token
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); // Navigate to login page
              },
            ),
          ],
        );
      },
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20); // start from bottom left corner
    path.quadraticBezierTo(0, size.height, 20, size.height); // bottom left curve
    path.lineTo(size.width - 20, size.height); // bottom right curve
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20); // end at bottom right corner
    path.lineTo(size.width, 0); // line to top right
    path.lineTo(0, 0); // line to top left
    path.close(); // close the path to form a closed shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
