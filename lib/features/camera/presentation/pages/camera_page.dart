import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/features/camera/domain/entities/rotatable_file.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';
import 'package:photos_to_pdf/features/camera/presentation/pages/camera.dart';

import '../../../../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController cameraController =
      CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

  @override
  void initState() {
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    cameraController.setFocusMode(FocusMode.locked);
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Camera(cameraController: cameraController),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocSelector<CameraCubit, CameraState, List<RotatableImage>>(
            selector: (state) => state.images,
            builder: (context, photos) => GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/selected_photos'),
              child: AnimatedContainer(
                width: 55,
                height: photos.isNotEmpty ? 55 : 0,
                decoration: BoxDecoration(
                    image: photos.isNotEmpty
                        ? DecorationImage(
                            fit: BoxFit.fill,
                            image: FileImage(File(photos.last.path)))
                        : null,
                    shape: BoxShape.circle),
                duration: const Duration(milliseconds: 250),
                child: Center(
                    child: Text(
                  photos.length.toString(),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                )),
              ),
            ),
          ),
          FloatingActionButton.large(
              backgroundColor: Colors.white,
              splashColor: Colors.blue,
              onPressed: () => BlocProvider.of<CameraCubit>(context)
                  .addPhoto(cameraController.takePicture()),
              child: Container(
                width: 85,
                height: 85,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
              )),
          BlocSelector<CameraCubit, CameraState, List<RotatableImage>>(
            selector: (state) => state.images,
            builder: (context, photos) => GestureDetector(
              onTap: lc<CameraCubit>().removeAllImages,
              child: AnimatedContainer(
                width: 55,
                height: photos.isNotEmpty ? 55 : 0,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                duration: const Duration(milliseconds: 250),
                child: photos.isNotEmpty ? const Icon(Icons.delete) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// '/picker_view'
