import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:photos_to_pdf/features/camera/domain/use_cases/convert_images_to_pdf.dart';
import 'package:share_plus/share_plus.dart';

part 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  final ImagesIntoPdfConvertor imagesIntoPdfConvertor;

  PhotoCubit(this.imagesIntoPdfConvertor) : super(const PhotoState());

  sharePDF(Iterable<ImageFile> images) async {
    if (state.status == Status.success) {
      final pdf = await imagesIntoPdfConvertor.getResultFile();
      await Share.shareXFiles([XFile(pdf.path)]);
      return;
    }
    emit(state.copyWith(status: Status.loading));
    final pdf = await imagesIntoPdfConvertor.convertImages(
        [for (final image in images) (await decodeJpgFile(image.path!))!]);
    emit(state.copyWith(status: Status.success));
    await Share.shareXFiles([XFile(pdf.path)]);
  }

  setLoadedStatus() => emit(state.copyWith(status: Status.loaded));
}
