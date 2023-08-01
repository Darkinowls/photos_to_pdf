import 'package:equatable/equatable.dart';
import 'package:image/image.dart';

class RotatableImage extends Equatable {
  final int degree;
  final Image image;
  final String path;

  @override
  List<Object> get props => [image, degree, path];

  RotatableImage copyWith({
    int? degree,
    Image? image,
    String? path,
  }) {
    return RotatableImage(
      degree: degree ?? this.degree,
      image: image ?? this.image,
      path: path ?? this.path,
    );
  }

  const RotatableImage({
    this.degree = 0,
    required this.image,
    required this.path,
  });
}
