import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';

import '../../../../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraController cameraController =
      CameraController(cameras[0], ResolutionPreset.low);

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
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: CameraPreview(cameraController)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocSelector<CameraCubit, CameraState, int>(
              selector: (state) => state.photos.length,
              builder: (context, size) => size != 0
                  ? Ink(
                      width: 55,
                      height: 55,

                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle),
                      child: Text(size.toString()),
                    )
                  : const SizedBox(width: 55)),
          FloatingActionButton.large(
              backgroundColor: Colors.white,
              onPressed: () async => await BlocProvider.of<CameraCubit>(context)
                  .addPhoto(cameraController.takePicture()),
              child: Container(
                width: 85,
                height: 85,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
              )),
          FloatingActionButton(onPressed: () {}),
        ],
      ),
    );
  }
}
