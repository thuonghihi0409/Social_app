import 'package:flutter/material.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';
import 'package:social_app/social/models/comment.dart';

class AddCommentWidget extends StatefulWidget {
  final CommentsBloc commentsBloc;
  final int id;

  const AddCommentWidget({
    super.key,
    required this.commentsBloc,
    required this.id,
  });

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;

  void _sendComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    Comment comment = Comment(
      body: commentText,
      postId: widget.id,
      id: DateTime.now().second,
      name: 'Khong co name',
      email: 'vanthuong@gmail',
    );

    widget.commentsBloc.add(CommentsAdd(comment: comment, id: widget.id));
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isSending = false;
        _commentController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.1),
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Writing comment...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          _isSending
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendComment,
                ),
        ],
      ),
    );
  }
}
