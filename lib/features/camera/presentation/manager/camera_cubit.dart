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

  Future<void> addPhoto(Future<XFile> aPhoto) async {
    final xFile = await aPhoto;
    final image = await decodeJpgFile(xFile.path);
    emit(state.copyWith(
        photos: [...state.files, RotatableImage(image!, xFile.path)]));
  }

  removeAllImages() {
    emit(state.copyWith(photos: []));
  }

  Future<void> sharePdf() async {
    emit(state.copyWith(status: Status.loading));
    final s = Stopwatch()..start();
    final rotatedImages = rotateImages(state.files);
    final pdf = await convertImagesToPDF(rotatedImages);
    print(s.elapsed);
    await Share.shareXFiles([XFile(pdf.path)]);
    emit(state.copyWith(status: Status.loaded));
  }

  void rotateImage(int index) {
    final result = <RotatableImage>[];
    for (int i = 0; i < state.files.length; i++) {
      if (i != index) {
        result.add(state.files[i]);
      }
      if (i == index) {
        final file = RotatableImage(state.files[i].image, state.files[i].path,
            state.files[i].degree + 90);
        result.add(file);
      }
    }
    emit(state.copyWith(photos: result));
  }

  void deleteImage(int index) {
    final result = <RotatableImage>[];
    for (int i = 0; i < state.files.length; i++) {
      if (i != index) {
        result.add(state.files[i]);
      }
    }
    emit(state.copyWith(photos: result));
  }
}
