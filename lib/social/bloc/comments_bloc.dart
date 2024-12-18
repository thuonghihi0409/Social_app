import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/models/comment.dart';
import 'package:social_app/social/reponsitory/comment_reponsitory.dart';

part 'comments_state.dart';
part 'comments_event.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsState()) {
    on<commentsFetched>(_fetchComments);
    on<commentsAdd>(_addComments);
  }

  Future<void> _addComments(
      commentsAdd event, Emitter<CommentsState> emit) async {
    CommentRepository commentRepository = CommentRepository();

    try {
      final comments =
          await commentRepository.addComment(event.comment, event.id);
      return emit(comments.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CommentsStatus.success,
              comments: List.of(state.comments)..addAll(comments),
              hasReachedMax: false));
    } catch (e) {
      // emit(state.copyWith(status: CommentsStatus.failure));
    }
  }

  Future<void> _fetchComments(
      commentsFetched event, Emitter<CommentsState> emit) async {
    if (state.hasReachedMax) return;
    CommentRepository commentRepository = CommentRepository();
    try {
      if (state.status == CommentsStatus.initial) {
        final comments = await commentRepository.fetchCommentsByIdPost(
            state.comments.length, event.id);
        return emit(state.copyWith(
            status: CommentsStatus.success,
            comments: List.of(state.comments)..addAll(comments),
            hasReachedMax: false));
      }
      final comments = await commentRepository.fetchCommentsByIdPost(
          state.comments.length, state.id);
      return emit(comments.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CommentsStatus.success,
              comments: List.of(state.comments)..addAll(comments),
              hasReachedMax: false));
    } catch (e) {
      // emit(state.copyWith(status: CommentsStatus.failure));
    }
  }
}
