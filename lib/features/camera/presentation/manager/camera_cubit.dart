import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photos_to_pdf/core/status.dart';



part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

  Future<void> addPhoto(Future<XFile> aPhoto) async {
    final xFile = await aPhoto;
    emit(state.copyWith(photos: [...state.photos, xFile]));
    await GallerySaver.saveImage(xFile.path, toDcim: true);
  }
}

// Image.file(File()),
