import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';
import 'package:photos_to_pdf/main.dart';

class Camera extends StatefulWidget {
  CameraController cameraController;

  Camera({required this.cameraController, super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) => Stack(children: [
        LayoutBuilder(
          builder: (context, constraints) =>
              BlocSelector<CameraCubit, CameraState, bool>(
            selector: (state) => state.increasedResolution,
            builder: (context, _) {
              return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: CameraPreview(widget.cameraController));
            },
          ),
        ),
        Positioned(
          left: 10,
          child: SafeArea(
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)))),
              onPressed: _changeCameraResolution,
              child: BlocSelector<CameraCubit, CameraState, bool>(
                selector: (state) => state.increasedResolution,
                builder: (context, increasedResolution) {
                  if (increasedResolution == true) {
                    return const Text("1080p");
                  }
                  return const Text("720p");
                },
              ),
            ),
          ),
        )
      ]);

  _changeCameraResolution() async {
    widget.cameraController = CameraController(
        cameras[0],
        lc<CameraCubit>().state.increasedResolution
            ? ResolutionPreset.high
            : ResolutionPreset.veryHigh,
        enableAudio: false);
    await widget.cameraController.initialize();
    lc<CameraCubit>().switchIncreasedResolution();
    // setState(() {});
  }
}
