import 'package:foto_ta/data/repositories/auth_repository.dart';
import 'package:foto_ta/data/repositories/activity_repository.dart';
import 'package:foto_ta/data/repositories/event_repository.dart';
import 'package:foto_ta/data/repositories/drive_search_repository.dart';
import 'package:foto_ta/data/repositories/drive_search_detail_repository.dart';
import 'package:foto_ta/data/services/activity_service.dart';
import 'package:foto_ta/data/services/auth_service.dart';
import 'package:foto_ta/data/services/event_service.dart';
import 'package:foto_ta/data/services/drive_search_service.dart';
import 'package:foto_ta/data/services/drive_search_detail_service.dart';
import 'package:foto_ta/data/services/local_service.dart';
import 'package:foto_ta/presentation/cubits/auth/auth_cubit.dart';
import 'package:foto_ta/presentation/cubits/camera/camera_cubit.dart';
import 'package:foto_ta/presentation/cubits/activities/activities_cubit.dart';
import 'package:foto_ta/presentation/cubits/bookmark/bookmark_cubit.dart';
import 'package:foto_ta/presentation/cubits/cubit.dart';
import 'package:foto_ta/presentation/cubits/event/event_cubit.dart';
import 'package:foto_ta/presentation/cubits/face_detection/face_detection_cubit.dart';
import 'package:foto_ta/presentation/cubits/drive_search/drive_search_cubit.dart';
import 'package:foto_ta/presentation/cubits/drive_search_detail/drive_search_detail_cubit.dart';
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
  sl.registerLazySingleton<ActivityService>(
    () => ActivityServiceImpl(client: sl()),
  );
  sl.registerLazySingleton<EventService>(() => EventServiceImpl(client: sl()));

  // { Repository }
  sl.registerFactory<AuthRepositoryImpl>(() => AuthRepositoryImpl(sl(), sl()));
  sl.registerFactory<ActivityRepository>(
    () => ActivityRepositoryImpl(activityService: sl()),
  );
  sl.registerFactory<EventRepository>(
    () => EventRepositoryImpl(eventService: sl()),
  );

  // { Cubit }
  sl.registerFactory(() => SignInCubit(sl()));
  sl.registerFactory(() => ObscureCubit());
  sl.registerFactory(() => ObscureCubitConfirmPassword());
  sl.registerLazySingleton(() => CameraCubit());
  sl.registerFactory(() => ActivitiesCubit(activityRepository: sl()));
  sl.registerFactory(() => EventCubit(eventRepository: sl()));
  sl.registerFactory(() => BookmarkCubit(activityRepository: sl()));
  sl.registerFactory(() => FaceDetectionCubit(eventRepository: sl()));
  // Register Drive Search related dependencies
  sl.registerFactory<DriveSearchService>(
    () => DriveSearchServiceImpl(client: sl<http.Client>()),
  );

  sl.registerFactory<DriveSearchRepository>(
    () =>
        DriveSearchRepositoryImpl(driveSearchService: sl<DriveSearchService>()),
  );

  sl.registerFactory<DriveSearchCubit>(
    () => DriveSearchCubit(driveSearchRepository: sl<DriveSearchRepository>()),
  );

  // Register Drive Search Detail related dependencies
  sl.registerFactory<DriveSearchDetailService>(
    () => DriveSearchDetailServiceImpl(client: sl<http.Client>()),
  );

  sl.registerFactory<DriveSearchDetailRepository>(
    () => DriveSearchDetailRepositoryImpl(
      driveSearchDetailService: sl<DriveSearchDetailService>(),
    ),
  );

  sl.registerFactory<DriveSearchDetailCubit>(
    () => DriveSearchDetailCubit(
      driveSearchDetailRepository: sl<DriveSearchDetailRepository>(),
    ),
  );
}
