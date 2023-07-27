part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final Status status;
  final List<RotatableFile> photos;

  const CameraState({
    this.status = Status.loaded,
    this.photos = const [],
  });

  @override
  List<Object> get props => [status, photos];

  CameraState copyWith({
    Status? status,
    List<RotatableFile>? photos,
  }) {
    return CameraState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
    );
  }
}
