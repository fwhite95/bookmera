import 'package:bookmera/src/mlkit_camera_testing.dart';
import 'package:bookmera/src/screens/search_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'booksapi_testing.dart';
import 'package:camera/camera.dart';
import 'package:bookmera/src/screens/bookshelf_screen.dart';

import 'screens/login_screen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String> [
    'email',
    'https://www.googleapis.com/auth/books',
  ],
);



class MyApp extends StatelessWidget {
  final CameraDescription _camera;
  

  MyApp({Key key, CameraDescription camera})
  :_camera = camera, super(key:key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: SearchScreen(camera: _camera,)
      //home: CameraApp(camera: _camera,),
    );
  }
}


