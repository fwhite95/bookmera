import 'dart:async';
import 'package:bookmera/src/models/bookshelf_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/volume_model.dart';
//import 'package:flutter/foundation.dart';

class ApiProvider {
  Client client = Client(); //HTTP
  final String _apiKey = "API";

//Method for sending get request for volumes at book endpoint
  Future<VolumeModel> getVolumesList(String search) async {
    
    final response = await client.get(
      "https://www.googleapis.com/books/v1/volumes?q=$search&projection=full&maxResults=15&key=$_apiKey");

    if(response.statusCode == 200){
      return VolumeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load getVolumesList");
    }
  }

  //Get for list of bookshelves using user oauth token
  Future<BookshelfModel> getBookshelfList(GoogleSignInAccount user) async {
    
    final response = await client.get(
      'https://www.googleapis.com/books/v1/mylibrary/bookshelves'
      '?requestMask.includeField=person.names',
      headers: await user.authHeaders,
    );

    if(response.statusCode == 200){
      return BookshelfModel.fromJson(json.decode(response.body));
    }else {
      throw Exception("Failed to load getBookshelfList");
    }
  }

  //Get list of volumes from the bookshelf
  Future<VolumeModel> getBookshelfVolumesList(GoogleSignInAccount user, int id) async {
    //print('The id: $id');

    try{
      final response = await client.get(
      'https://www.googleapis.com/books/v1/mylibrary/bookshelves/$id/volumes?'
      '?requestMask.includeField=person.names',
      headers: await user.authHeaders,
    );
    //print('getBookShelfVolumesList: ${response.statusCode}');

    if(response.statusCode == 200){
      return VolumeModel.fromJson(json.decode(response.body));
    }else {
      throw Exception("Failed to load getBookshelfVolumesList");
    }

    }catch(e){
      print(e);
    }
    

    // if(response.statusCode == 200){
    //   return VolumeModel.fromJson(json.decode(response.body));
    // }else {
    //   throw Exception("Failed to load getBookshelfVolumesList");
    // }
  }
}
