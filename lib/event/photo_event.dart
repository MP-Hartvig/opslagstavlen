import 'package:opslagstavlen/model/photo.dart';

abstract class PhotoEvent {}

class PhotoGetEvent implements PhotoEvent {}

class PhotoGetListEvent implements PhotoEvent {}

class PhotoGetLocalListEvent implements PhotoEvent {}

class PhotoDeleteLocalListEvent implements PhotoEvent {}

class PhotoCreateEvent implements PhotoEvent {
  final Photo _photo;

  Photo get photo => _photo;

  PhotoCreateEvent(this._photo);
}

class PhotoUpdateEvent implements PhotoEvent {}

class PhotoDeleteEvent implements PhotoEvent {}
