import 'package:flutter/material.dart';

class VolumeModel {
  String _kind;
  int _totalItems;
  List<_Items> _items = [];

  VolumeModel.fromJson(Map<String, dynamic> parsedJson) {
    _kind = parsedJson['kind'];
    _totalItems = parsedJson['totalItems'];

    List<_Items> temp = [];
    if(_totalItems != 0){
      for(int i = 0; i < parsedJson['items'].length; i++){
        _Items item = _Items(parsedJson['items'][i]);
        temp.add(item);
      }
    }
    _items = temp;
    
  }

  List<_Items> get items => _items;
  String get kind => _kind;
  int get totalItems => _totalItems;

}

class _Items {
  String _kind;
  String _id;
  String _etag;
  String _selfLink;
  _VolumeInfo _volumeInfo;

  _Items(items) {
    _kind = items['kind'];
    _id = items['id'];
    _etag = items['etag'];
    _selfLink = items['selfLink'];
    _volumeInfo = _VolumeInfo(items['volumeInfo']);
  }

  String get kind => _kind;
  String get id => _id;
  String get etag => _etag;
  String get selfLink => _selfLink;
  _VolumeInfo get volumeInfo => _volumeInfo;

}

class _VolumeInfo {
  String _title;
  List<String> _authors = [];
  String _publisher;
  String _publishedDate;
  String _description;
  int _pageCount;
  String _printType;
  String _averageRating;
  _ImageLinks _imageLinks;

  _VolumeInfo(volumeInfo){
    _title = volumeInfo['title'];
    _publisher = volumeInfo['publisher'];
    _publishedDate = volumeInfo['publishedDate'];
    _description = volumeInfo['description'];
    _pageCount = volumeInfo['pageCount'];
    _printType = volumeInfo['printType'];
    _averageRating = volumeInfo['averageRating'].toString();

    List<String> temp = [];
    // for(int i = 0; i < volumeInfo['authors'].length; i++){
    //   String author = volumeInfo['authors'][i];
    //   temp.add(author);
    // }
    _authors = temp;

    _imageLinks = _ImageLinks(volumeInfo['imageLinks']);
  }

  String get title => _title;

  String get publisher => _publisher;

  String get printType => _printType;

  String get averageRating => _averageRating;

  String get description => _description;

  String get publishedDate => _publishedDate;

  int get pageCount => _pageCount;

  List<String> get authors => _authors;

  _ImageLinks get imageLinks => _imageLinks;

}

class _ImageLinks {
  String _smallThumbnail;
  String _thumbnail;

  _ImageLinks(imageLinks){
    _smallThumbnail = imageLinks['smallThumbnail'];
    _thumbnail = imageLinks['thumbnail'];
  }

  String get smallThumbnail => _smallThumbnail;
  String get thumbnail => _thumbnail;

}