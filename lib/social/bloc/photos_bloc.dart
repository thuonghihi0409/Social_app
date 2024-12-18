import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/models/photo.dart';
import 'package:social_app/social/reponsitory/photo_reponsitory.dart';

part 'photos_state.dart';
part 'photos_event.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc() : super(PhotosState()) {
    on<PhotosFetched>(_fetchPhotos);
  }

  Future<void> _fetchPhotos(
      PhotosFetched event, Emitter<PhotosState> emit) async {
    if (state.hasReachedMax) return;
    PhotoRepository photoRepository = PhotoRepository();
    try {
      if (state.status == PhotosStatus.initial) {
        final photos = await photoRepository.fetchPhotos(state.photos.length);
        return emit(state.copyWith(
            status: PhotosStatus.success,
            photos: List.of(state.photos)..addAll(photos),
            hasReachedMax: false));
      }
      final photos = await photoRepository.fetchPhotos(state.photos.length);
      return emit(photos.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PhotosStatus.success,
              photos: List.of(state.photos)..addAll(photos),
              hasReachedMax: false));
    } catch (e) {
      emit(state.copyWith(status: PhotosStatus.failure));
    }
  }
}
