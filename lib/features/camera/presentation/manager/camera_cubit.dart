import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path/path.dart' as path;
import 'package:photos_to_pdf/features/camera/domain/entities/RotatableFile.dart';
import 'package:share_plus/share_plus.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

  Future<void> addPhoto(Future<XFile> aPhoto) async {
    final xFile = await aPhoto;
    emit(state.copyWith(photos: [...state.photos, RotatableFile(xFile.path)]));
    GallerySaver.saveImage(xFile.path, toDcim: true);
  }

  removeAllImages() {
    emit(state.copyWith(photos: []));
  }

  Future<ShareResult> sharePdf() async {
    final rotatedImages = _rotateImage();
    final file = await _convertImagesToPdf(rotatedImages);
    return Share.shareXFiles([XFile(file.path)]);
  }

  List<RotatableFile> _rotateImage() {
    final result = <RotatableFile>[];
    for (int i = 0; i < state.photos.length; i++) {
      final file = state.photos[i];
      final image = decodeImage(file.readAsBytesSync());
      final rotatedImage = copyRotate(image!, angle: 90);
      result
          .add(RotatableFile(file.path)..writeAsBytes(encodeJpg(rotatedImage)));
    }
    return result;
  }

  void rotateImage(int index) {
    final result = <RotatableFile>[];
    for (int i = 0; i < state.photos.length; i++) {
      if (i != index) {
        result.add(state.photos[i]);
      }
      if (i == index) {
        final file = RotatableFile(
            state.photos[i].file.path, state.photos[i].degree + 90);
        result.add(file);
      }
    }
    emit(state.copyWith(photos: result));
  }

  void deleteImage(int index) {
    final result = <RotatableFile>[];
    for (int i = 0; i < state.photos.length; i++) {
      if (i != index) {
        result.add(state.photos[i]);
      }
    }
    emit(state.copyWith(photos: result));
  }

  Future<File> _convertImagesToPdf(List<RotatableFile> photos) async {
    final document = pdf.Document();
    for (final photo in photos) {
      document.addPage(pdf.Page(
        build: (context) => pdf.Image(pdf.MemoryImage(photo.readAsBytesSync())),
      ));
    }
    Future<Uint8List> documentData = document.save();
    final file = File(path.join(
        (await getApplicationDocumentsDirectory()).path, "result.pdf"));
    return file.writeAsBytes(await documentData);
  }
}

// Image.file(File()),
