import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path/path.dart' as path;

class ImagesIntoPdfConvertor {
  Future<File> convertImages(List<Image> images) async {
    final document = pdf.Document();
    for (final photo in images) {
      document.addPage(
        pdf.Page(
            build: (context) =>
                pdf.Center(child: pdf.Image(pdf.ImageImage(photo)))),
      );
    }
    final file = await getResultFile();

    await compute((File f) async {
      Future<Uint8List> documentData = document.save();
      await f.writeAsBytes(await documentData);
    }, file);
    return file;
  }

  Future<File> getResultFile() async {
    return File(path.join(
        (await getApplicationDocumentsDirectory()).path, "result.pdf"));
  }
}
