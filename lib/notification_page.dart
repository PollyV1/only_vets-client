import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({required this.message});

  final RemoteMessage? message;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = "09611666193";
    // Set status bar color to white
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Ensure status bar icons are visible
    ));
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gradientBG.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: statusBarHeight + screenHeight * 0.11),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100), // Adjust the radius as needed
                          child: Image.asset(
                            'assets/images/doc.png',
                            fit: BoxFit.cover,
                            width: 180, // Set the desired width
                            height: 180, // Set the desired height for a square image
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Doctor Orozco is within your Area!',
                              style: GoogleFonts.acme(
                                textStyle: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'If you are in need of on-site check-up, call now',
                              style: GoogleFonts.actor(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 27),
                    AnimatedPhoneIcon(
                      phoneNumber: phoneNumber,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 50,
                        width: screenWidth * 0.85,
                        child: ElevatedButton(
                          onPressed: () {
                            // Exit the app when Decline button is pressed
                            SystemNavigator.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9C9898), // Set background color here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Set border radius here
                            ),
                          ),
                          child: Text(
                            'Decline',
                            style: GoogleFonts.actor(
                              textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0), // Set text color here
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: statusBarHeight,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.home_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedPhoneIcon extends StatefulWidget {
  const AnimatedPhoneIcon({required this.phoneNumber});

  final String phoneNumber;

  @override
  _AnimatedPhoneIconState createState() => _AnimatedPhoneIconState();
}

class _AnimatedPhoneIconState extends State<AnimatedPhoneIcon> {
  bool _isTapped = false;

  void _launchPhoneCall(BuildContext context) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: widget.phoneNumber,
    );

    try {
      if (await canLaunch(phoneLaunchUri.toString())) {
        await launch(phoneLaunchUri.toString());
      } else {
        throw 'Could not launch ${phoneLaunchUri.toString()}';
      }
    } catch (e) {
      print('Error launching phone dialer: $e');
      _showErrorDialog(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Could not make the call'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Failed to initiate phone call. Please try again later.'),
                const SizedBox(height: 10),
                Text('Phone Number: ${widget.phoneNumber}'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Copy'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.phoneNumber));
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Phone number copied to clipboard')),
                        );
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }

  void _onTap() {
    setState(() {
      _isTapped = true;
    });

    // Perform the phone call launch
    _launchPhoneCall(context);

    // Reset the animation state after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isTapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedScale(
        scale: _isTapped ? 1.2 : 1.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80), // Adjust the radius as needed
              child: Image.asset(
                'assets/images/phoneWhite.png',
                fit: BoxFit.cover,
                width: 120, // Set the desired width
                height: 120, // Set the desired height for a square image
              ),
            ),
          ],
        ),
      ),
    );
  }
}
