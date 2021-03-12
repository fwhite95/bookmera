
import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/volume_model.dart';

class VolumeBloc{
  final _repository = Repository();
  final _volumeFetcher = PublishSubject<VolumeModel>();

  Stream<VolumeModel> get allVolumes => _volumeFetcher.stream;

  //Method that calls repository to a return from the api
  fetchVolumes(search) async {
    VolumeModel volumeModel = await _repository.fetchVolumes(search);
    _volumeFetcher.sink.add(volumeModel);
  }

  dispose() {
    _volumeFetcher.close();
  }
}

//an initialized VolumeBloc object to call allVolumes from
final volumeBloc = VolumeBloc();