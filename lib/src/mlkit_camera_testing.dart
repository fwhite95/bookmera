import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class CameraApp extends StatefulWidget {
final CameraDescription camera;

CameraApp({
  Key key,
  @required this.camera,
}) : super(key: key);

  @override 
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController _controller;
  Future<void> _initControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, 
    ResolutionPreset.medium);
    _initControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera App")
        ),
        body: FutureBuilder<void>(
          future: _initControllerFuture,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              //Return the ML photo object here?
              return CameraPreview(_controller);
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            try{
              await _initControllerFuture;

              final path = join(
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              //The photo I just took 
              await _controller.takePicture(path);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );

            } catch(e){
              print("Error: $e");
            }
          },
        ),
    );
  }

  //ml stuff in here
  

}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('The photo'),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Image.file(File(imagePath)),
              ),
          ),
          Container(
            child: Center(
              child: FutureBuilder<Widget>(
          future: getImageText(),
          builder: (context, snapshot) {
            String text = snapshot.data.toString();
            print('The output: $text');
            return Center(
              child: Text(text), //throws an error when exiting the class
              );
          }
        ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Widget> getImageText() async{
    final File imageFile = File(imagePath);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);

    //Extract text
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

    textRecognizer.close();
    return Text(text);
  }

  

}

