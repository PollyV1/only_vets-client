import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_vets_client/home_page.dart';
import 'package:provider/provider.dart';
import 'bloc/location_bloc.dart';

class DisclaimerPage extends StatefulWidget {
  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {

  @override
  Widget build(BuildContext context) {
    return Provider<LocationBloc>(
      create: (context) => LocationBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Disclaimer',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), // Customize back button icon
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/gradientBG.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 60,),
                      const Text(
                        'The "Orozco Vet" App uses location data, mobile data, and WiFi to maintain real-time communication with Dr. Orozco, ensuring timely updates of his location during pet visits. By using this app, you consent to the collection and use of this data for service enhancement.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 10,),
                      const Text(
                        'All data is securely stored and used solely to improve our veterinary services. We respect your privacy and comply with applicable privacy laws and regulations.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 30,),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
