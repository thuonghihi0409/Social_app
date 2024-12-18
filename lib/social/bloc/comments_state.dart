part of 'comments_bloc.dart';

enum CommentsStatus { initial, success, failure }

class CommentsState extends Equatable {
  CommentsState(
      {this.status = CommentsStatus.initial,
      this.comments = const <Comment>[],
      this.hasReachedMax = false,
      this.id = 0});

  @override
  // TODO: implement props
  List<Object?> get props => [status, comments, hasReachedMax];
  final CommentsStatus status;
  final List<Comment> comments;
  final bool hasReachedMax;
  final int id;

  CommentsState copyWith(
      {CommentsStatus? status,
      List<Comment>? comments,
      bool? hasReachedMax,
      int? id}) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      id: id ?? this.id,
    );
  }
}
