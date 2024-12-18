part of 'posts_bloc.dart';

class PostsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class PostFetched extends PostsEvent {}

final class PostRefreshed extends PostsEvent {}

final class PostDeleted extends PostsEvent {
  final Post post;

  PostDeleted({required this.post});
}
