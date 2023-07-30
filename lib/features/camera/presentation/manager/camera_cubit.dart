import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path/path.dart' as path;
import 'package:photos_to_pdf/features/camera/domain/entities/rotatable_file.dart';
import 'package:share_plus/share_plus.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

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
    emit(state.copyWith(status:  Status.loading));
    final images = state.files;
    final rotatedImages = _rotateImages(images);
    final pdf = await _convertImagesToPdf(rotatedImages);
    await Share.shareXFiles([XFile(pdf.path)]);
    emit(state.copyWith(status: Status.loaded));
  }

  List<Image> _rotateImages(List<RotatableImage> images) {
    final result = <Image>[];
    for (int i = 0; i < images.length; i++) {
      final rImage = images[i];
      final rotatedImage = copyRotate(rImage.image, angle: rImage.degree);
      result.add(rotatedImage);
    }
    return result;
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

  Future<File> _convertImagesToPdf(List<Image> photos) async {
    final document = pdf.Document();
    for (final photo in photos) {
      document.addPage(
        pdf.Page(
            build: (context) =>
                pdf.Center(child: pdf.Image(pdf.ImageImage(photo)))),
      );
    }
    Future<Uint8List> documentData = document.save();
    final file = File(path.join(
        (await getApplicationDocumentsDirectory()).path, "result.pdf"));
    return file.writeAsBytes(await documentData);
  }
}
