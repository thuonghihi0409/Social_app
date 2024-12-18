import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/photos_bloc.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late final PhotosBloc _photosBloc;
  final _pageController = PageController();

  void initState() {
    super.initState();
    _pageController.addListener(_onPage);
    // Khởi tạo bloc
    _photosBloc = context.read<PhotosBloc>();
    _photosBloc..add(PhotosFetched());
  }

  void _onPage() {
    // if (!_pageController.hasClients) return;
    // final max = _pageController.position.maxScrollExtent;
    // final current = _pageController.position.pixels;
    // if (current >= max - 2) {
    //   _postsBloc.add(PhotosFetched());
    // }
  }

  void dispose() {
    _pageController.removeListener(_onPage);
    _pageController.dispose();
    //_photosBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PhotosBloc, PhotosState>(
            buildWhen: (previous, current) => previous.photos != current.photos,
            builder: (context, state) {
              return Stack(
                children: [
                  // PageView for images
                  PageView.builder(
                    itemCount: state.photos.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        state.photos[index].url,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      );
                    },
                    onPageChanged: (index) {
                      if (index >= state.photos.length - 2) {
                        _photosBloc.add(PhotosFetched());
                      }
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
              );
            }),
      ),
    );
  }

  // Top User Info
  Widget _buildUserInfo() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
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
          SizedBox(width: 12),
          // User Text Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@marina_bothman',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: Text(
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
