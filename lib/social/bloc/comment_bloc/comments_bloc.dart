import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/models/comment.dart';
import 'package:social_app/social/reponsitory/comment_reponsitory.dart';

part 'comments_state.dart';
part 'comments_event.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc()
      : super(CommentsState(comments: [], status: CommentsStatus.initial)) {
    on<CommentsFetched>(_fetchComments);
    on<CommentsAdd>(_addComments);
  }

  Future<void> _addComments(
      CommentsAdd event, Emitter<CommentsState> emit) async {
    // CommentRepository commentRepository = CommentRepository();
    return emit(state.copyWith(
        status: CommentsStatus.success,
        comments: List.of(state.comments)..add(event.comment),
        hasReachedMax: false));
  }

  Future<void> _fetchComments(
      CommentsFetched event, Emitter<CommentsState> emit) async {
    // Reset state if ID different
    print("============= state=${state.id}   event=${event.id}");
    if (state.id != event.id) {
      emit(CommentsState(
        comments: [],
        status: CommentsStatus.initial,
        hasReachedMax: false,
        id: event.id,
      ));
    }

    if (state.hasReachedMax) return;

    CommentRepository commentRepository = CommentRepository();

    try {
      print("============= state.comments.length=${state.comments.length}");

      if (state.status == CommentsStatus.initial) {
        final comments = await commentRepository.fetchCommentsByIdPost(
            state.comments.length, event.id);

        if (comments.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
          return;
        }

        emit(state.copyWith(
            status: CommentsStatus.success,
            comments: comments,
            hasReachedMax: false));
        return;
      }

      // Lấy thêm dữ liệu
      final comments = await commentRepository.fetchCommentsByIdPost(
          state.comments.length, state.id);

      print("=============2222id=${event.id} comments=${comments.length}");

      emit(comments.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CommentsStatus.success,
              comments: List.of(state.comments)..addAll(comments),
              hasReachedMax: false));
    } catch (e) {
      emit(state.copyWith(status: CommentsStatus.failure));
    }
  }
}
