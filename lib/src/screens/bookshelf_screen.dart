import 'package:bookmera/src/models/volume_model.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/bookshelf_model.dart';
import '../bloc/bookshelf_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BookShelfScreen extends StatefulWidget {
  final GoogleSignInAccount _currentUser;

BookShelfScreen({
  Key key,
  @required currentUser,
}) : _currentUser = currentUser, super(key: key);

  @override 
  _BookShelfScreenState createState() => _BookShelfScreenState();
}


class _BookShelfScreenState extends State<BookShelfScreen> {
  List<String> list = ['Title 1', 'Title 2', 'Title 3', 'Title 4'];
  List<String> bookTitleList = ['Book 1', 'Book 2', 'Book 3'];
  List<VolumeModel> volumesList = [];
  Map<dynamic, VolumeModel> map;

  @override
  void initState() {
    super.initState();
    bookshelfBloc.fetchBookshelves(widget._currentUser);
    
  }

  @override
  void dispose() {
    bookshelfBloc.dispose();
    super.dispose();
  }



//Assumes item is of class BookshelfItems
  // Future<void> updatebookshelfBloc(dynamic item) async{
  //   bookshelfBloc.fetchBookshelfVolumesByList(widget._currentUser, item);
  // }

  Widget _buildPage() {
    //List<VolumeModel> list = [];
    return StreamBuilder(
      stream: bookshelfBloc.allBookshelves,
      builder: (context, AsyncSnapshot<BookshelfModel> snapshot) {
        if(snapshot.hasData){
          bookshelfBloc.fetchBookshelfVolumesByList(widget._currentUser, snapshot.data.bookshelfitems);
          return StreamBuilder(
            stream: bookshelfBloc.allBookshelfVolumesByList,
            builder: (context, AsyncSnapshot<VolumeModel> asyncSnapshot) {
              if(asyncSnapshot.hasData){
                return _buildPageTest(snapshot.data.bookshelfitems, asyncSnapshot.data.items);
              }else if(asyncSnapshot.hasError){
                return Text(asyncSnapshot.error.toString());
              }
              return Center(
                child: Text('DYING'),
              );
            },
          );
        }else if(snapshot.hasError){
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }


//TODO: Currently creates all carousel objects with the same volumeItems
//you can see it remake the coursels with each new list of volumeItems
  Widget _buildPageTest(dynamic bookshelfItems, dynamic volumeItems) {
     return ListView.builder(
      itemCount: bookshelfItems.length,
      itemBuilder: (context, int index){
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5,),
          child: Column(
            children: [
              Text(bookshelfItems[index].title,
              style: TextStyle(
                fontSize: 20,
              ),
              ),
              SizedBox(
                height: 5,
              ),
              _buildCarouselTest(volumeItems),
            ],
          ),
        );
      },
    );
  }


  Widget _buildCarouselTest(dynamic volumeItems) { 
    return CarouselSlider(
  options: CarouselOptions(
    height: MediaQuery.of(context).size.height/4,
    viewportFraction: .35,
    aspectRatio: 2.0,
    ),
  items: volumeItems.map<Widget>((item) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width/2,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Text('${item.volumeInfo.title}', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
);
  }

  @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Bookshelves'),
       ),
       body: _buildPage(),
     );
   }
}
