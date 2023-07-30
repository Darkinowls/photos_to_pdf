

import 'package:equatable/equatable.dart';
import 'package:image/image.dart';

class RotatableImage extends Equatable {
  final int degree;
  final Image image;
  final String path;

  const RotatableImage(this.image, this.path, [this.degree = 0]);

  @override
  List<Object> get props => [image, degree, path];
}
