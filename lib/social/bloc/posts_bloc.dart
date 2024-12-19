import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/social/models/post.dart';
import 'package:social_app/social/reponsitory/post_reponsitory.dart';
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsState()) {
    on<PostFetched>(_onPostFetched);
    on<PostRefreshed>(_onPostRefreshed);
  }
  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostsState> emit) async {
    if (state.hasReachedMax) return;
    PostRepository repository = PostRepository();
    try {
      if (state.status == PostStatus.initial) {
        final posts = await repository.fetchPosts(state.posts.length);
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }

      final posts = await repository.fetchPosts(state.posts.length);

      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (_) {
      // emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostRefreshed(
      PostRefreshed event, Emitter<PostsState> emit) async {
    print("====================Refreshed");
    emit(state.copyWith(
      status: PostStatus.initial,
      posts: [],
      hasReachedMax: false,
    ));
    if (state.hasReachedMax) return;
    PostRepository repository = PostRepository();
    try {
      if (state.status == PostStatus.initial) {
        final posts = await repository.fetchPosts(state.posts.length);
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }

      final posts = await repository.fetchPosts(state.posts.length);

      emit(posts.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
            ));
    } catch (_) {
      // emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
