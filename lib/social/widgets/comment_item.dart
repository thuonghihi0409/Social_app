import 'package:flutter/material.dart';
import 'package:social_app/social/models/comment.dart';
import 'package:social_app/social/widgets/reaction_widget.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isReplying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment Header
        Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
            ),
            const SizedBox(width: 8),
            Text(
              widget.comment.email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Spacer(),
            const Icon(Icons.more_vert, size: 18),
          ],
        ),
        const SizedBox(height: 4),

        // Comment Text
        Text(
          widget.comment.body,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),

        // Comment Actions
        Row(
          children: [
            ReactionWidget(),
            const SizedBox(width: 4),
            const SizedBox(width: 16),
            InkWell(
              child: const Text("Reply",
                  style: TextStyle(color: Colors.blue, fontSize: 12)),
              onTap: () {
                setState(() {
                  isReplying = !isReplying;
                });
              },
            ),
          ],
        ),

        // Input for Replying
        if (isReplying) _buildReplyInput(),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildReplyInput() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Add a comment...",
                border: InputBorder.none,
                suffixStyle: const TextStyle(color: Colors.blue),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
