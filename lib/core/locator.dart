import 'package:get_it/get_it.dart';
import 'package:photos_to_pdf/features/camera/domain/use_cases/convert_images_to_pdf.dart';
import 'package:photos_to_pdf/features/camera/domain/use_cases/rotate_images.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';

import '../features/photos/presentation/manager/photo_cubit.dart';

final lc = GetIt.instance;

Future<void> setupLocator() async {
  lc.registerLazySingleton<ImagesIntoPdfConvertor>(
      () => ImagesIntoPdfConvertor());

  lc.registerLazySingleton<CameraCubit>(() => CameraCubit(
      imagesIntoPdfConvertor: lc<ImagesIntoPdfConvertor>(),
      rotateImages: RotateImages()));

  lc.registerLazySingleton<PhotoCubit>(
      () => PhotoCubit(lc<ImagesIntoPdfConvertor>()));
}
