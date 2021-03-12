import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'bookshelf_screen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String> [
    'email',
    'https://www.googleapis.com/auth/books',
  ],
);

class LoginScreen extends StatefulWidget {
LoginScreen({
  Key key,
}) : super(key: key);

  @override 
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print(_currentUser);
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    super.dispose();

  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();


  Widget _buildGoogleLoginButton() {
    return RaisedButton(
            child: const Text('Google Sign In'),
            onPressed: _handleSignIn,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          );
  }

  Widget _buildLoginScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'BookMera',
          textAlign: TextAlign.center,
          textScaleFactor: 2.0,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 30,
          ),
          ),
        SizedBox(height: 45),
        SizedBox(
          height: MediaQuery.of(context).size.height/6,
          child: Image.asset(
            'lib/assets/images/books_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 45,
        ),
        Text('Log in with your Google account'),
        SizedBox(height: 25),
        _buildGoogleLoginButton(),
        
      ],
    );
  }

  Widget _loggedInScreen() {
    
  }

  //Sorta works, error with the routing from the builds. Need to work on checking if logged in, then navigation and
  //handling the states. 
  @override
   Widget build(BuildContext context) {
     if(_currentUser == null){
       return Scaffold(
       body: Center(
         child: _buildLoginScreen(),
       ),
     );
     }else{
       //Fix this and need to handle states better everywhere.
       Navigator.push(context,
       MaterialPageRoute(builder: (context) {
         return BookShelfScreen(currentUser: _currentUser);
       })
       );
       return Scaffold(
         body: Center(
           child: CircularProgressIndicator(),
         ),
       );
     }
     
   }
}