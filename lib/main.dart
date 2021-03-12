import 'package:bookmera/src/screens/login_screen.dart';
import 'package:bookmera/src/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'src/screens/bookshelf_screen.dart';


import 'src/app.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String> [
    'email',
    'https://www.googleapis.com/auth/books',
  ],
);

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  cameras = await availableCameras();
  final firstCamera = cameras.first;

  Widget _defaultHome = LoginScreen();

  GoogleSignInAccount _currentUser = await _googleSignIn.signInSilently();
  if(_currentUser != null){
    //_defaultHome = BookShelfScreen(currentUser: _currentUser,);
    _defaultHome = SearchScreen(camera: firstCamera,);
  }

  //runApp(MyApp(camera: firstCamera,));
  runApp(MaterialApp(
    title: 'Bookmera',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
    home: _defaultHome,
  ));
}
