import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../models/volume_model.dart';
import '../bloc/search_bloc.dart';
import '../ui/photo_bottomBar.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';


class SearchScreen extends StatefulWidget {
  final CameraDescription _camera;

  SearchScreen({Key key, CameraDescription camera})
    :_camera = camera, super(key:key);

  @override 
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "";

  //Camera stuff
  CameraController _controller;
  Future<void> _initControllerFuture;
  bool _isTakingPhoto = false;


  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget._camera,
      ResolutionPreset.high,
    );
    _initControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    volumeBloc.dispose();
    _controller.dispose();
    super.dispose();
  }


  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      onChanged: (query) => updateSearchQuery(query),
      onTap: () {
        _startSearch();
        },
    );
  }

  List<Widget> _buildActions() {
    if(_isSearching) {
      return <Widget> [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            {
              _clearSearchQuery();
              Navigator.pop(context);
              return;
            }
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
      .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

      setState(() {
        _isSearching = true;
        FocusScope.of(context).requestFocus();
      });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if(searchQuery != ""){
        volumeBloc.fetchVolumes(searchQuery);
      }
      
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      FocusScope.of(context).unfocus();
      
    });
  }

  void _clearSearchQuery() {
    setState(() {
          _searchQueryController.clear();
          updateSearchQuery("");
          
        });
  }

  Future<void> _photoSearch() async {
    try{
      await _initControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
      );

      //The photo I just took
      await _controller.takePicture(path);

      final File imageFile = File(path);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);

    //Extract text
    //need to set text correctly (its returning the whole list right now)
    String text = visionText.text;
    String text1;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;
      text1 = text;
      for(TextLine line in block.lines){
        //same getters as textblock
        //return text lines i think
        for(TextElement element in line.elements) {
          //same getters as textblock
        }
      }
    }
    //might need to write a start searching
    //need to update search text in bar to match new text
    updateSearchQuery(text);
    print('in photo search: $searchQuery');
      
    }catch(e) {
      print('Error $e');
    }
  }

//Could have a bool that changes body on fab click
  Widget takePhotoScreen() {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
      future: _initControllerFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        }else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    ),
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        _photoSearch();
        setState(() {
                  _isTakingPhoto = false;
                });
      },
      tooltip: 'Take a photo',
      child: Icon(Icons.camera_alt),
    ),
    );
    
    
  }

  //pass the function to the bar?
  void _onTabTapped(int index) {
    setState(() {
          
        });
  }

  Widget _buildSearchList() {
    return StreamBuilder(
      stream: volumeBloc.allVolumes,
      builder: (context, AsyncSnapshot<VolumeModel> snapshot) {
        if(searchQuery == ""){
          return Container(
            child: Text(""),
          );
        }else if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data.items.length,
            itemBuilder: (context, int index) {
              return Card(
                child: ListTile(
                  leading: Image.network('${snapshot.data.items[index].volumeInfo.imageLinks.smallThumbnail}') ?? Container(),
                  title: Text(snapshot.data.items[index]?.volumeInfo?.title),
                ),
              );
            },
          );
        } else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_isTakingPhoto) ? takePhotoScreen() : Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : Container(),
        title:  _buildSearchField(),
        actions: _buildActions(),
      ),
      body: Center(
        child: _buildSearchList(),
      ),
      bottomNavigationBar: photoBottomBar(_onTabTapped),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('calling photo search');
          setState(() {
                      _isTakingPhoto = true;
                    });
        },
        tooltip: 'Take a photo',
        child: Icon(Icons.camera_alt),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  
}