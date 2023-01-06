import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import './login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _position;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = _position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location Permission are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _position != null
                  ? Text('Current Location: ' + _position.toString())
                  : Text('No Location data'),
              Text('Home Screen'),
              MaterialButton(
                onPressed: () async {
                  dynamic result = _auth.signOut();
                  if (result == null) {
                    print('error signing out');
                  } else {
                    print('signed out');
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  }
                },
                color: Colors.blue,
                child: Text('Sign Out'),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentLocation,
          child: const Icon(Icons.map),
        ));
  }
}
