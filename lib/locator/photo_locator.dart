import 'package:get_it/get_it.dart';
import 'package:opslagstavlen/api/photo_datahandler.dart';
import 'package:opslagstavlen/api/photo_local_datahandler.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PhotoDataHandler());
  locator.registerLazySingleton(() => PhotoLocalDataHandler());
}