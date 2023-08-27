import 'package:opslagstavlen/model/photo.dart';

enum PhotoStates { initial, loading, completed, error }

class PhotoState {
  final PhotoStates _state;
  final List<Photo> _photos;

  PhotoStates get currentState => _state;
  List<Photo> get photos => _photos;

  PhotoState({required PhotoStates state, List<Photo>? photos})
      : _state = state,
        _photos = photos ?? [];
}