import 'dart:async';
import 'dart:io';

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
  final ImagesIntoPdfConvertor imagesIntoPdfConvertor;
  final RotateImages rotateImages;

  CameraCubit(
      {required this.imagesIntoPdfConvertor, required this.rotateImages})
      : super(const CameraState());

  void switchIncreasedResolution() {
    emit(state.copyWith(increasedResolution: !state.increasedResolution));
  }

  Future<void> addPhoto(Future<XFile> aPhoto) async {
    final xFile = await aPhoto;
    final image = await decodeImageFile(xFile.path);
    emit(state.copyWith(images: [
      ...state.images,
      RotatableImage(image: image!, path: xFile.path)
    ], status: Status.loaded));
  }

  removeAllImages() => emit(state.copyWith(images: [], status: Status.loaded));

  Future<void> sharePdf() async {
    if (state.status == Status.success) {
      final pdf = await imagesIntoPdfConvertor.getResultFile();
      await Share.shareXFiles([XFile(pdf.path)]);
      return;
    }
    emit(state.copyWith(status: Status.loading));
    final rotatedImages = rotateImages(state.images);
    final pdf = await imagesIntoPdfConvertor.convertImages(rotatedImages);
    emit(state.copyWith(status: Status.success));
    await Share.shareXFiles([XFile(pdf.path)]);
  }

  void rotateImage(int index) {
    emit(state.copyWith(
        images: [...state.images]
          ..[index].copyWith(degree: state.images[index].degree + 90),
        status: Status.loaded));
  }

  void deleteImage(int index) {
    emit(state.copyWith(
        images: [...state.images]..removeAt(index), status: Status.loaded));
  }
}
