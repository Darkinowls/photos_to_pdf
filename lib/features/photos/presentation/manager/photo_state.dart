part of 'photo_cubit.dart';

class PhotoState extends Equatable {
  final Status status;
  final Iterable<ImageFile> images;

  @override
  List<Object> get props => [status, images];

  const PhotoState({
    this.images = const [],
    this.status = Status.loaded,
  });

  PhotoState copyWith({
    Status? status,
    Iterable<ImageFile>? images,
  }) {
    return PhotoState(
      status: status ?? this.status,
      images: images ?? this.images,
    );
  }
}
