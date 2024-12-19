part of 'comments_bloc.dart';

class CommentsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class CommentsFetched extends CommentsEvent {
  final int id;
  CommentsFetched({required this.id});
}

final class CommentsAdd extends CommentsEvent {
  final int id;
  final Comment comment;
  CommentsAdd({required this.comment, required this.id});
}
