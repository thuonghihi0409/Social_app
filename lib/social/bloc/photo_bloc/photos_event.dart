part of 'photos_bloc.dart';

class PhotosEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class PhotosFetched extends PhotosEvent {}

final class PhotoRefresh extends PhotosEvent {}

final class PhotoDeleted extends PhotosEvent {
  final int id;

  PhotoDeleted({required this.id});
}
