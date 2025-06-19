import 'package:foto_ta/data/repositories/auth_repository.dart';
import 'package:foto_ta/data/service/client/auth_service.dart';
import 'package:foto_ta/data/service/local/local_service.dart';
import 'package:foto_ta/presentation/cubits/auth/auth_cubit.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => http.Client());

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // { Service }
  sl.registerLazySingleton<AuthService>(() => AuthService(sl()));
  sl.registerLazySingleton<LocalService>(() => LocalService(sl()));

  // { Repository }
  sl.registerFactory<AuthRepositoryImpl>(() => AuthRepositoryImpl(sl(), sl()));

  // { Cubit }
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => ObscureCubit());
}
