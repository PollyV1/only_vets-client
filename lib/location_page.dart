import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import fluttertoast package
import 'package:only_vets_client/home_page.dart';
import 'package:provider/provider.dart';
import 'bloc/location_bloc.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final List<String> locations = [
    'Bombon',
    'Calabanga',
    'Canaman',
    'Magarao',
    'Tinambac',
    'Siruma',
    'Naga'
  ];

  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Provider<LocationBloc>(
      create: (context) => LocationBloc(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Select Location',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), // Customize back button icon
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
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
                  child: const Text(
                    'Please set your location according to your Municipality/ City for accurate notification during Dr. Orozco’s rounds.',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 220, // Adjust the width as needed
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        icon: const SizedBox.shrink(),
                        value: selectedLocation,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        dropdownColor: const Color(0xFF9e17b4), // Dropdown background color
                        style: const TextStyle(color: Colors.white, fontSize: 18), // Text style of selected item
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: const Text(
                            'Select Location',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                          _showLocationChangeConfirmationDialog(value!);
                        },
                        items: locations.map((location) {
                          return DropdownMenuItem(
                            alignment: Alignment.centerLeft,
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLocationChangeConfirmationDialog(String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Location Change',style: TextStyle(fontSize: 30)),
          content: Text('Are you sure you want to change location to $location?',style: TextStyle(fontSize: 18),),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                setState(() {
                  selectedLocation = location;
                });
                context.read<LocationBloc>().add(LocationSelected(location));
                Navigator.of(context).pop(); // Close dialog
                _showToast('Location changed to $location');
              },
            ),
          ],
        );
      },
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

