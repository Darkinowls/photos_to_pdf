part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final Status status;
  final List<RotatableImage> files;

  const CameraState({
    this.status = Status.loaded,
    this.files = const [],
  });

  @override
  List<Object> get props => [status, files];

  CameraState copyWith({
    Status? status,
    List<RotatableImage>? photos,
  }) {
    return CameraState(
      status: status ?? this.status,
      files: photos ?? files,
    );
  }
}
