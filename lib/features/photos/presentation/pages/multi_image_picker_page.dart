import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:photos_to_pdf/core/locator.dart';
import 'package:photos_to_pdf/core/status.dart';
import 'package:photos_to_pdf/features/photos/presentation/manager/photo_cubit.dart';

class MultiImagePickerPage extends StatefulWidget {
  const MultiImagePickerPage({Key? key}) : super(key: key);

  @override
  State<MultiImagePickerPage> createState() => _MultiImagePickerPage();
}

class _MultiImagePickerPage extends State<MultiImagePickerPage> {
  final controller = MultiImagePickerController(
      maxImages: 10,
      allowedImageTypes: ['jpg', 'jpeg'],
      images: lc<PhotoCubit>().state.images);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            MultiImagePickerView(
              onChange: lc<PhotoCubit>().setImages,
              controller: controller,
              padding: const EdgeInsets.all(10),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pick images to save in pdf'),
            BlocSelector<PhotoCubit, PhotoState, Status>(
              selector: (state) => state.status,
              builder: (context, status) {
                if (status == Status.loading) {
                  return const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(color: Colors.white));
                }
                return IconButton(
                    onPressed: () =>
                        lc<PhotoCubit>().sharePDF(controller.images),
                    icon: const Icon(Icons.share));
              },
            ),
          ],
        ),
      ),
    );
  }
}
