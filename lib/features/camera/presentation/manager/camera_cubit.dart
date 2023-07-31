import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:photos_to_pdf/core/status.dart';

import 'package:photos_to_pdf/features/camera/domain/entities/rotatable_file.dart';
import 'package:photos_to_pdf/features/camera/domain/use_cases/rotate_images.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/use_cases/convert_images_to_pdf.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final ConvertImagesToPDF convertImagesToPDF;
  final RotateImages rotateImages;

  CameraCubit({required this.convertImagesToPDF, required this.rotateImages})
      : super(const CameraState());

  void switchIncreasedResolution(){
    emit(state.copyWith(increasedResolution: !state.increasedResolution));
  }

  Future<void> addPhoto(Future<XFile> aPhoto) async {
    final xFile = await aPhoto;
    final image = await decodeJpgFile(xFile.path);
    emit(state.copyWith(
        images: [...state.images, RotatableImage(image!, xFile.path)]));
  }

  removeAllImages() {
    emit(state.copyWith(images: []));
  }

  Future<void> sharePdf() async {
    emit(state.copyWith(status: Status.loading));
    final s = Stopwatch()..start();
    final rotatedImages = rotateImages(state.images);
    final pdf = await convertImagesToPDF(rotatedImages);
    print(s.elapsed);
    await Share.shareXFiles([XFile(pdf.path)]);
    emit(state.copyWith(status: Status.loaded));
  }

  void rotateImage(int index) {
    final result = <RotatableImage>[];
    for (int i = 0; i < state.images.length; i++) {
      if (i != index) {
        result.add(state.images[i]);
      }
      if (i == index) {
        final file = RotatableImage(state.images[i].image, state.images[i].path,
            state.images[i].degree + 90);
        result.add(file);
      }
    }
    emit(state.copyWith(images: result));
  }

  void deleteImage(int index) {
    final result = <RotatableImage>[];
    for (int i = 0; i < state.images.length; i++) {
      if (i != index) {
        result.add(state.images[i]);
      }
    }
    emit(state.copyWith(images: result));
  }
}
