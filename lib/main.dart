import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';
import 'package:photos_to_pdf/features/camera/presentation/pages/camera_page.dart';
import 'package:photos_to_pdf/features/photos/presentation/manager/photo_cubit.dart';
import 'package:photos_to_pdf/features/photos/presentation/pages/photos_page.dart';

import 'features/photos/presentation/pages/multi_image_picker_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  while ((await [Permission.storage, Permission.camera].request()).containsValue(PermissionStatus.denied)){}
  await setupLocator();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: lc<CameraCubit>()),
            BlocProvider.value(value: lc<PhotoCubit>())
          ],
          child: Builder(
            builder: (context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Photos into pdf',
                onGenerateRoute: (settings) {
                  if (settings.name == '/') {
                    return MaterialPageRoute(
                        builder: (context) => const CameraPage());
                  }
                  if (settings.name == '/selected_photos') {
                    return MaterialPageRoute(
                        builder: (context) => const PhotosPage());
                  }
                  if (settings.name == '/picker_view') {
                    return MaterialPageRoute(
                        builder: (context) => const MultiImagePickerPage());
                  }
                  return null;
                },
              );
            },
          ));
}
