import 'dart:async';
import 'dart:convert' show json;

import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String> [
    'email',
    'https://www.googleapis.com/auth/books',
  ],
);

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetBookshelf();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetBookshelf() async {
    setState(() {
      _contactText = "Loading bookshelf info...";
    });
    final http.Response response = await http.get(
      'https://www.googleapis.com/books/v1/mylibrary/bookshelves/7/volumes/'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      
      setState(() {
        _contactText = "Books API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('Books API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    final String bookshelf = _pickFirstNamedBookshelf(data);
    setState(() {
      if (bookshelf != null) {
        _contactText = "$bookshelf";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedBookshelf(Map<String, dynamic> data) {
    final List<dynamic> items = data['items'];
    final Map<String, dynamic> title = items?.firstWhere(
      (dynamic title) => title['volumeInfo'] != null,
      orElse: () => null,
    );
    if(title != null){
      return title['volumeInfo']['authors'][0].toString();
    }

    // if (title != null) {
    //   final Map<String, dynamic> name = title['volumeInfo'].firstWhere(
    //     (dynamic name) => name['authors'] != null,
    //     orElse: () => null,
    //   );
    //   if (name != null) {
    //     return name['authors'][0];
    //   }
    // }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            //leading: GoogleUserCircleAvatar(
              //identity: _currentUser,
            //),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetBookshelf,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign In'),
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}

// Widget myGridTile(Text text) {
  //   return Container(
  //     padding: EdgeInsets.all(3.0),
  //     margin: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.blueGrey)
  //     ),
  //     child: Center(
  //       child: text,
  //     ),
  //   );
  // }

  // List<Widget> myGridList() {
  //   List<Widget> list = List<Widget>();
  //   list.add(myGridTile(Text('One')));
  //   list.add(myGridTile(Text('Two')));
  //   list.add(myGridTile(Text('Three')));
  //   list.add(myGridTile(Text('Four')));
  //   list.add(myGridTile(Text('Five')));
  //   list.add(myGridTile(Text('Six')));
  //   list.add(myGridTile(Text('Seven')));
  //   list.add(myGridTile(Text('Eight')));
  //   list.add(myGridTile(Text('Nine')));
  //   list.add(myGridTile(Text('One')));
  //   list.add(myGridTile(Text('Two')));
  //   list.add(myGridTile(Text('Three')));
  //   list.add(myGridTile(Text('Four')));
  //   list.add(myGridTile(Text('Five')));
  //   list.add(myGridTile(Text('Six')));
  //   list.add(myGridTile(Text('Seven')));
  //   list.add(myGridTile(Text('Eight')));
  //   list.add(myGridTile(Text('Nine')));

  //   return list;
  // }

  // Widget _buildSearchField() {
  //   return TextField(
  //     autofocus: false,
  //     decoration: InputDecoration(
  //       contentPadding: EdgeInsets.all(5),
  //       icon: Icon(Icons.search),
  //       hintText: 'Search...',
  //       hintStyle: TextStyle(color: Colors.white),
  //       focusColor: Colors.blueGrey,
        
  //     ),
      
  //     style: TextStyle(
  //       color: Colors.white,
  //       fontSize: 16,
  //     ),
  //   );

  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.black,
  //       title: _buildSearchField(),
  //     ),
  //     body: GridView.count(
  //       crossAxisCount: 3,
  //       children: myGridList(),
  //     ),
  //   );
  // }