import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of image URLs
    final List<String> images = [
      'https://via.placeholder.com/150/92c952',
      'https://via.placeholder.com/150/771796',
      'https://via.placeholder.com/150/24f355',
      'https://via.placeholder.com/150/d32776'
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for images
            PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.cover,
                );
              },
              scrollDirection: Axis.vertical,
            ),

            // Content Overlay
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top User Info
                  _buildUserInfo(),
                  _buildBottomActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top User Info
  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
            ),
          ),
          const SizedBox(width: 12),
          // User Text Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '@marina_bothman',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: const Text(
                  'The best day with my best friends! @sam_rogerson @alice_cooper',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Actions: Tags, Comments, Likes, and Icons
  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Row(
            children: [
              _buildTag("#amazing"),
              _buildTag("#air_balloon"),
            ],
          ),
          const SizedBox(height: 8),

          // Icons Row
          Row(
            children: [
              _buildIconWithText(Icons.favorite, '37k'),
              _buildIconWithText(Icons.chat_bubble_outline, '200k'),
              _buildIconWithText(Icons.favorite_border, '15k'),
              _buildIconWithText(Icons.share, '302k'),
            ],
          ),

          // Add Comment
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Add comment",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildIconWithText(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
