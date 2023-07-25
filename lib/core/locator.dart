import 'package:get_it/get_it.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';

final lc = GetIt.instance;

Future<void> setupLocator() async {
  lc.registerLazySingleton<CameraCubit>(() => CameraCubit());
}
