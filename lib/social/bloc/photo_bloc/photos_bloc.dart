import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/models/photo.dart';
import 'package:social_app/social/reponsitory/photo_reponsitory.dart';

part 'photos_state.dart';
part 'photos_event.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc() : super(PhotosState()) {
    on<PhotosFetched>(_fetchPhotos);
    on<PhotoRefresh>(_refreshPhotos);
    on<PhotoDeleted>(_deletedPhoto);
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

  Future<void> _deletedPhoto(
      PhotoDeleted event, Emitter<PhotosState> emit) async {
    log("=======deleted${state.photos.length}");
    List<Photo> photos = List.from(state.photos);

    photos.removeWhere((photoItem) => photoItem.id == event.id);
    photos.removeWhere((photoItem) => photoItem.id == event.id);
    emit(state.copyWith(
      status: PhotosStatus.success,
      photos: photos,
      hasReachedMax: false,
    ));
    log("=======deleted${state.photos.length}");
  }

  Future<void> _refreshPhotos(
      PhotoRefresh event, Emitter<PhotosState> emit) async {
    emit(state.copyWith(
        status: PhotosStatus.initial, photos: [], hasReachedMax: false));
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
