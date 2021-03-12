import 'package:bookmera/src/bloc/search_bloc.dart';
import 'package:bookmera/src/models/volume_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/bookshelf_model.dart';

class BookshelfBloc{
  final _repository = Repository();
  final _bookshelfFetcher = PublishSubject<BookshelfModel>();
  final _bookshelfVolumeFetcher = PublishSubject<VolumeModel>();
  final _bookshelfVolumeListFetcher = PublishSubject<List<VolumeModel>>();

  Stream<BookshelfModel> get allBookshelves => _bookshelfFetcher.stream;
  Stream<VolumeModel> get allBookshelfVolumes => _bookshelfVolumeFetcher.stream;
  Stream<VolumeModel> get allBookshelfVolumesByList => _bookshelfVolumeFetcher.stream;
  Stream<List<VolumeModel>> get allBookshelfVolumesByStreamList => _bookshelfVolumeListFetcher.stream;

  fetchBookshelves(GoogleSignInAccount user) async {
    BookshelfModel bookshelfModel = await _repository.fetchBookshelves(user);
    _bookshelfFetcher.sink.add(bookshelfModel);
  }

  fetchBookshelfVolumes(GoogleSignInAccount user, int id) async{
    VolumeModel volumeModel = await _repository.fetchBookshelfVolumes(user, id);
    _bookshelfVolumeFetcher.sink.add(volumeModel);
  }

  fetchBookshelfVolumesByStreamList(GoogleSignInAccount user, List<dynamic> items) async {
    List<VolumeModel> volumeModelList = [];
    VolumeModel volumeModel;
    for(int i = 0; i < items.length; i++){
      print('The for loop');
      volumeModel = await _repository.fetchBookshelfVolumes(user, items[i].id);
      volumeModelList.add(volumeModel);
      
    }
    _bookshelfVolumeListFetcher.sink.add(volumeModelList);

  }

  //Getting volumes by list of ids
  fetchBookshelfVolumesByList(GoogleSignInAccount user, List<dynamic> items) async{
    VolumeModel volumeModel;
    for(int i = 0; i < items.length; i++){
      volumeModel = await _repository.fetchBookshelfVolumes(user, items[i].id);
      
      _bookshelfVolumeFetcher.sink.add(volumeModel);
    }
    
  }

  dispose() {
    _bookshelfFetcher.close();
    _bookshelfVolumeFetcher.close();
    _bookshelfVolumeListFetcher.close();
  }
}

//an initialized VolumeBloc object to call allVolumes from
final bookshelfBloc = BookshelfBloc();