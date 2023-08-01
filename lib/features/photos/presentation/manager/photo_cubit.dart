import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:photos_to_pdf/features/camera/domain/use_cases/convert_images_to_pdf.dart';
import 'package:share_plus/share_plus.dart';

part 'photo_state.dart';

class PhotoCubit extends Cubit<PhotoState> {
  static const String pdfFilename = "result_photo";
  final ImagesIntoPdfConvertor imagesIntoPdfConvertor;

  PhotoCubit(this.imagesIntoPdfConvertor) : super(const PhotoState());

  sharePDF(Iterable<ImageFile> images) async {
    if (state.status == Status.success) {
      final pdf = await imagesIntoPdfConvertor.getResultPdf(pdfFilename);
      await Share.shareXFiles([XFile(pdf.path)]);
      return;
    }
    emit(state.copyWith(status: Status.loading));
    List<Image> decodedImages = await imagesIntoPdfConvertor
        .decodeJPGFilesByPaths(images.map((e) => e.path!));
    final pdf = await imagesIntoPdfConvertor.saveImagesToPdf(
        decodedImages, pdfFilename);
    emit(state.copyWith(status: Status.success));
    await Share.shareXFiles([XFile(pdf.path)]);
  }

  setImages(Iterable<ImageFile> images) =>
      emit(state.copyWith(images: images, status: Status.loaded));
}
