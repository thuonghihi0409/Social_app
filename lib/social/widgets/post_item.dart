import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';
import 'package:social_app/social/bloc/post_bloc/posts_bloc.dart';
import 'package:social_app/social/models/post.dart';

import 'package:social_app/social/widgets/list_comment.dart';
import 'package:social_app/social/widgets/reaction_widget.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final PostsBloc postsBloc;
  const PostItem({super.key, required this.post, required this.postsBloc});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // late final CommentsBloc _commentsBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage("https://via.placeholder.com/150"),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 6,
                child: Text(
                  widget.post.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 4),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      break;
                    case 'delete':
                      _showComfirmDelete();
                      break;
                    case 'hide':
                      // _hideRental(index);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem(
                    value: 'hide',
                    child: Text('Hide'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Post Text
          Text(
            widget.post.body,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
            return Row(
              children: [
                ReactionWidget(),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    _showComments();
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.comment, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      widget.post.id == state.id
                          ? Text("Comment (${state.comments.length})",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12))
                          : Text("Comment",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12))
                    ],
                  ),
                ),
              ],
            );
          }),

          // Actions Row

          const Divider(height: 24),
        ],
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.8, child: ListComment(widget.post));
        });
  }

  void _showComfirmDelete() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm deletion"),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Center(
                child: Text("Do you want to continue deleting the post ?"),
              ),
            ),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  widget.postsBloc.add(PostDeleted(post: widget.post));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
