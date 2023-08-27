import 'package:opslagstavlen/api/photo_datahandler.dart';
import 'package:opslagstavlen/api/photo_local_datahandler.dart';
import 'package:opslagstavlen/event/photo_event.dart';
import 'package:opslagstavlen/locator/photo_locator.dart';
import 'package:opslagstavlen/state/photo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoState(state: PhotoStates.initial)) {
    on<PhotoGetListEvent>(_getPhotoListEvent);
    on<PhotoGetLocalListEvent>(_getPhotoLocalListEvent);
    on<PhotoCreateEvent>(_postPhotoEvent);
    on<PhotoDeleteLocalListEvent>(_deletePhotoLocalListEvent);
  }

  void _getPhotoListEvent(PhotoEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoState(state: PhotoStates.loading));
    final apiService = locator<PhotoDataHandler>();

    try {
      final photos = await apiService.getPhotoCollection();
      emit(PhotoState(state: PhotoStates.completed, photos: photos));
    } catch (e) {
      emit(PhotoState(state: PhotoStates.error));
    }
  }

  void _getPhotoLocalListEvent(
      PhotoEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoState(state: PhotoStates.loading));
    final apiService = locator<PhotoLocalDataHandler>();

    try {
      final photos = await apiService.getPhotoLocalCollection();
      emit(PhotoState(state: PhotoStates.completed, photos: photos));
    } catch (e) {
      emit(PhotoState(state: PhotoStates.error));
    }
  }

  void _deletePhotoLocalListEvent(
      PhotoEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoState(state: PhotoStates.loading));
    final apiService = locator<PhotoLocalDataHandler>();

    try {
      await apiService.deletePhotoLocalCollection();
      emit(PhotoState(state: PhotoStates.completed));
    } catch (e) {
      emit(PhotoState(state: PhotoStates.error));
    }
  }

  void _postPhotoEvent(PhotoCreateEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoState(state: PhotoStates.loading));
    final apiService = locator<PhotoDataHandler>();

    try {
      await apiService.createPhoto(event.photo);
    } catch (e) {
      emit(PhotoState(state: PhotoStates.error));
    }
  }
}
