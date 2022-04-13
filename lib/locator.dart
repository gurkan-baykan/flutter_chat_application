import 'package:firebase_proje/repository/user_repository.dart';
import 'package:firebase_proje/services/fakeService.dart';
import 'package:firebase_proje/services/firestorage_service.dart';
import 'package:firebase_proje/services/firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'services/firebase_auth_service.dart';
GetIt locator = GetIt.instance;

void setupLocator()
{
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStore());
  locator.registerLazySingleton(() => FireStorageService());
}

