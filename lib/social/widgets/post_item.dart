import 'package:flutter/material.dart';
import 'package:social_app/social/models/post.dart';
import 'package:social_app/social/widgets/reaction_widget.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  // Các biểu tượng cảm xúc

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://via.placeholder.com/150"),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 6,
                child: Text(
                  widget.post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 4),
              const Spacer(),
              const Icon(Icons.more_vert, size: 18),
            ],
          ),
          const SizedBox(height: 4),
      
          // Post Text
          Text(
            widget.post.body,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ReactionWidget(),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: const [
                    Icon(Icons.comment, size: 18, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Comment", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
      
          // Actions Row
          
          const Divider(height: 24),
        ],
      ),
    );
  }
}
