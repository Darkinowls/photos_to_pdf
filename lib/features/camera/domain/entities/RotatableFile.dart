import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class RotatableFile extends Equatable {
  final int degree;
  late final File file;

  RotatableFile(String path, [this.degree = 0]) {
    file = File(path);
  }

  get path => file.path;

  Uint8List readAsBytesSync () => file.readAsBytesSync();

  writeAsBytes (bytes) => file.writeAsBytes(bytes);

  @override
  List<Object> get props => [file, degree];
}
