import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';
import 'package:social_app/social/bloc/photo_bloc/photos_bloc.dart';
import 'package:social_app/social/widgets/add_comment_widget.dart';
import 'package:social_app/social/widgets/list_comment_image.dart';
import 'package:social_app/social/widgets/reaction_widget.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late final PhotosBloc _photosBloc;
  final _pageController = PageController();
  late final CommentsBloc commentsBloc;
  @override
  void initState() {
    super.initState();
    commentsBloc = context.read<CommentsBloc>();
    _pageController.addListener(_onPage);
    _photosBloc = context.read<PhotosBloc>();
    _photosBloc.add(PhotosFetched());
  }

  void _onPage() {}

  @override
  void dispose() {
    _pageController.removeListener(_onPage);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _photosBloc.add(PhotoRefresh()); // add event refreshed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PhotosBloc, PhotosState>(
          buildWhen: (previous, current) => previous.photos != current.photos,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: PageView.builder(
                controller: _pageController,
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Fullscreen Image
                      Image.network(
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
                      ),

                      // Top User Info with Blur Background
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 100,
                        child: _buildBlurContainer(
                          child: _buildUserInfo(),
                        ),
                      ),

                      // Bottom Actions with Blur Background
                      Positioned(
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: _buildBlurContainer(
                          child: _buildBottomActions(state.photos[index].id),
                        ),
                      ),
                    ],
                  );
                },
                onPageChanged: (index) {
                  if (index >= state.photos.length - 2) {
                    _photosBloc.add(PhotosFetched());
                  }
                },
                scrollDirection: Axis.vertical,
              ),
            );
          },
        ),
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
          Expanded(
            child: Column(
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
                Text(
                  'The best day with my best friends! @sam_rogerson @alice_cooper',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Actions
  Widget _buildBottomActions(int id) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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

          // Action Icons
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          _showCommentsEmage(id);
                        },
                        icon: Icon(Icons.comment, color: Colors.white70)),
                    const SizedBox(width: 4),
                    BlocBuilder<CommentsBloc, CommentsState>(
                        builder: (context, state) {
                      return Text("${state.comments.length}",
                          style: const TextStyle(color: Colors.white));
                    }),
                    ReactionWidget()
                  ],
                ),
              ),
            ],
          ),

          // Add Comment
          AddCommentWidget(commentsBloc: commentsBloc, id: id),
        ],
      ),
    );
  }

  // Tag Widget
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

  // Blur Container
  Widget _buildBlurContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0.02),
          child: child,
        ),
      ),
    );
  }

  void _showCommentsEmage(int id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.8, child: ListCommentImage(id));
        });
  }
}
