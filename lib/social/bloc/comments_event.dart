part of 'comments_bloc.dart';

class CommentsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// ignore: camel_case_types
final class commentsFetched extends CommentsEvent {
  final int id;
  commentsFetched({required this.id});
}

// ignore: camel_case_types
final class commentsAdd extends CommentsEvent {
  final int id;
  final Comment comment;
  commentsAdd({required this.comment, required this.id});
}
