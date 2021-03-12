import 'package:bookmera/src/models/volume_model.dart';

class BookshelfModel {
  String _kind;
  List<_BookshelfItems> _bookshelfItems = [];

  BookshelfModel.fromJson(Map<String, dynamic> parsedJson) {
    _kind = parsedJson['kind'];

    List<_BookshelfItems> temp = [];
    for(int i = 0; i < parsedJson['items'].length; i++){
      _BookshelfItems item = _BookshelfItems(parsedJson['items'][i]);
      temp.add(item);
    }
    _bookshelfItems = temp;
  }

  List<_BookshelfItems> get bookshelfitems => _bookshelfItems;
  String get kind => _kind;

}

class _BookshelfItems {
  String _kind;
  int _id;
  String _title;
  String _access;
  String _updated;
  String _created;
  int _volumeCount;
  String _volumeLastUpdated; 
  //List<VolumeModel> _bookshelfVolumes = [];

  _BookshelfItems(items) {
    _kind = items['kind'];
    _id = items['id'];
    _title = items['title'];
    _access = items['access'];
    _updated = items['updated'];
    _created = items['created'];
    _volumeCount = items['volumeCount'];
    _volumeLastUpdated = items['volumeLastUpdated']; 

    // List<_BookshelfItems> temp = [];
    // for(int i = 0; i < items['items'].length; i++){
    //   _BookshelfItems item = _BookshelfItems(parsedJson['items'][i]);
    //   temp.add(item);
    // }
    // _bookshelfItems = temp;

  }

  String get kind => _kind;
  int get id => _id;
  String get title => _title;
  String get access => _access;
  String get updated => _updated;
  String get  created => _created;
  int get volumeCount => _volumeCount;
  String get volumeLastUpdated => _volumeLastUpdated; 

}