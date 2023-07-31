part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final Status status;
  final bool increasedResolution;
  final List<RotatableImage> images;

  const CameraState({
    this.increasedResolution = false,
    this.status = Status.loaded,
    this.images = const [],
  });

  @override
  List<Object> get props => [status, images, increasedResolution];

  CameraState copyWith({
    Status? status,
    bool? increasedResolution,
    List<RotatableImage>? images,
  }) {
    return CameraState(
      status: status ?? this.status,
      increasedResolution: increasedResolution ?? this.increasedResolution,
      images: images ?? this.images,
    );
  }
}
