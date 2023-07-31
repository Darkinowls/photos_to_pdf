import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:photos_to_pdf/features/camera/domain/entities/rotatable_file.dart';
import 'package:photos_to_pdf/features/camera/presentation/manager/camera_cubit.dart';

class PhotosPage extends StatelessWidget {
  const PhotosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Taken images"),
              BlocSelector<CameraCubit, CameraState, Status>(
                selector: (state) => state.status,
                builder: (context, status) {
                  if (status == Status.loading) {
                    return const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(color: Colors.white));
                  }
                  return IconButton(
                      onPressed: lc<CameraCubit>().sharePdf,
                      icon: const Icon(Icons.share));
                },
              ),
            ],
          ),
        ),
        BlocSelector<CameraCubit, CameraState, List<RotatableImage>>(
          selector: (state) => state.files,
          builder: (context, photos) => SliverList.separated(
            itemCount: photos.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                  height: 500,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Transform.rotate(
                        angle: photos[index].degree * pi / 4,
                        child: photos[index].degree % 180 == 0
                            ? Image.file(
                                height: 450,
                                width: 250,
                                File(photos[index].path))
                            : Image.file(
                                height: 250,
                                width: 250,
                                File(photos[index].path)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  lc<CameraCubit>().rotateImage(index),
                              icon: const Icon(Icons.rotate_left)),
                          const SizedBox(height: 40),
                          IconButton(
                              onPressed: () =>
                                  lc<CameraCubit>().deleteImage(index),
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            (index + 1).toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10)
                        ],
                      )
                    ],
                  )),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 5),
          ),
        )
      ],
    ));
  }
}
