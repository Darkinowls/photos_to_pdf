import 'package:image/image.dart';
import 'package:photos_to_pdf/features/camera/domain/entities/rotatable_file.dart';

class RotateImages{
  List<Image> call(List<RotatableImage> images) {
    final result = <Image>[];
    for (int i = 0; i < images.length; i++) {
      final rImage = images[i];
      var rotatedImage = rImage.image;
      if (rImage.degree % 360 != 0) {
        rotatedImage = copyRotate(rImage.image, angle: rImage.degree);
      }
      result.add(rotatedImage);
    }
    return result;
  }
}