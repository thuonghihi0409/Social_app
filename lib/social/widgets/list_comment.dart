import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comments_bloc.dart';
import 'package:social_app/social/bloc/posts_bloc.dart';
import 'package:social_app/social/widgets/buttom_loader.dart';
import 'package:social_app/social/widgets/comment_item.dart';

class ListComment extends StatefulWidget {
  final int id;

  const ListComment({super.key, required this.id});
  @override
  State<ListComment> createState() => _ListCommentState();
}

class _ListCommentState extends State<ListComment> {
  late final CommentsBloc commentsBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo bloc
    commentsBloc = context.read<CommentsBloc>();
    commentsBloc..add(commentsFetched(id: widget.id));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      commentsBloc.add(commentsFetched(id: widget.id));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child:
          BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
        switch (state.status) {
          case CommentsStatus.failure:
            return const Center(child: Text('Failed to fetch posts'));
          case CommentsStatus.success:
            if (state.comments.isEmpty) {
              return const Center(child: Text('No posts'));
            }
            return ListView.builder(
                itemCount: state.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.comments.length
                      ? const BottomLoader()
                      : CommentCard(
                          comment: state.comments[index],
                        );
                });
          case CommentsStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
