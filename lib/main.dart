import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';
import 'package:photos_to_pdf/features/camera/presentation/pages/camera_page.dart';
import 'package:photos_to_pdf/features/photos/presentation/pages/photos_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [Permission.storage, Permission.camera].request();
  await setupLocator();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lc<CameraCubit>(),
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Photos to Pdf',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(
                  builder: (context) => const CameraPage());
            }
            if (settings.name == '/selected_photos') {
              return PageTransition(
                  child: PhotosPage(), type: PageTransitionType.leftToRight);
            }
            return null;
          },
        );
      }),
    );
  }
}
