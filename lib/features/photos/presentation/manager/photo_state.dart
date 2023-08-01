part of 'photo_cubit.dart';

class PhotoState extends Equatable {
  final Status status;

  @override
  List<Object> get props => [status];

  const PhotoState( {
    this.status = Status.loaded,
  });

  PhotoState copyWith({
    Status? status,
  }) {
    return PhotoState(
      status: status ?? this.status,
    );
  }
}
