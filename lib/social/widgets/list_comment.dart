import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';

import 'package:social_app/social/models/post.dart';
import 'package:social_app/social/widgets/add_comment_widget.dart';
import 'package:social_app/social/widgets/buttom_loader.dart';
import 'package:social_app/social/widgets/comment_item.dart';

class ListComment extends StatefulWidget {
  final Post post;
  const ListComment(
    this.post, {
    super.key,
  });
  @override
  State<ListComment> createState() => _ListCommentState();
}

class _ListCommentState extends State<ListComment> {
  late final CommentsBloc commentsBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    commentsBloc = context.read<CommentsBloc>();
    commentsBloc..add(CommentsFetched(id: widget.post.id));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && !commentsBloc.state.hasReachedMax) {
      commentsBloc.add(CommentsFetched(id: widget.post.id));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            padding:
                const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
            child: Text(
              "${widget.post.title}",
              softWrap: true,
            ),
          ),
          Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, state) {
                  switch (state.status) {
                    case CommentsStatus.failure:
                      return const Center(child: Text('Failed to fetch posts'));
                    case CommentsStatus.success:
                      if (state.comments.isEmpty) {
                        return const Center(child: Text('No posts'));
                      }
                      return ListView.builder(
                          controller: _scrollController,
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
              )),
          Container(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AddCommentWidget(
                  commentsBloc: commentsBloc, id: widget.post.id),
            ),
          ),
        ],
      ),
    );
  }
}
