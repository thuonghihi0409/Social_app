import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String commentText;
  final bool isReplying;

  const CommentCard({
    Key? key,
    required this.username,
    required this.timeAgo,
    required this.commentText,
    this.isReplying = false,
  }) : super(key: key);

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
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Text(
              timeAgo,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Spacer(),
            const Icon(Icons.more_vert, size: 18),
          ],
        ),
        const SizedBox(height: 4),

        // Comment Text
        Text(
          commentText,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),

        // Comment Actions
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined, size: 18),
              onPressed: () {},
            ),
            const SizedBox(width: 4),
            const Text("1", style: TextStyle(fontSize: 12)),
            const SizedBox(width: 16),
            const Text("Reply", style: TextStyle(color: Colors.blue, fontSize: 12)),
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
                suffixText: "@amysmith",
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
