part of 'posts_bloc.dart';

 enum PostStatus { initial, success, failure }
 class PostsState extends Equatable {

 PostsState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [status, posts, hasReachedMax];
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;


  PostsState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

}