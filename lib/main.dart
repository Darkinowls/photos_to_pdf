import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';
import 'package:photos_to_pdf/features/camera/presentation/pages/camera_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photos to Pdf',
        home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  final List<Widget> _pages = [
    BlocProvider.value(value: lc<CameraCubit>(), child: const CameraPage()),
    Scaffold(
      body: Container(
          color: Colors.green,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () => ImagePicker().pickMultiImage(),
            ),
          )),
    ),
    Container(color: Colors.red, child: Center(child: Text('Page 3'))),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(controller: _pageController, children: _pages),
    );
  }
}
