import 'dart:async';
import 'package:bookmera/src/models/bookshelf_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'api_provider.dart';
import '../models/volume_model.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<VolumeModel> fetchVolumes(String search) =>
    apiProvider.getVolumesList(search);

  Future<BookshelfModel> fetchBookshelves(GoogleSignInAccount user) =>
    apiProvider.getBookshelfList(user);

  Future<VolumeModel> fetchBookshelfVolumes(GoogleSignInAccount user, int id) =>
    apiProvider.getBookshelfVolumesList(user, id);
}