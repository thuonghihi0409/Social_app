import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';
import 'package:social_app/social/bloc/post_bloc/posts_bloc.dart';
import 'package:social_app/social/models/post.dart';
import 'package:social_app/social/widgets/buttom_loader.dart';
import 'package:social_app/social/widgets/list_comment.dart';
import 'package:social_app/social/widgets/post_item.dart';
import 'package:social_app/social/widgets/reaction_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final PostsBloc _postsBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _postsBloc = context.read<PostsBloc>();
    _postsBloc.add(PostFetched());
    _scrollController.addListener(_onScroll);
  }

  /// call function
  void _onScroll() {
    if (_isBottom) {
      _postsBloc.add(PostFetched());
    }
  }

  /// check scroll
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  /// function to call when last list
  Future<void> _onRefresh() async {
    _postsBloc.add(PostRefreshed()); // add event refreshed
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostStatus.failure:
              return const Center(child: Text('Failed to fetch posts'));
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('No posts'));
              }
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length
                        ? const BottomLoader()
                        : _PostItem(
                            state.posts[index],
                          );
                  },
                  itemCount: state.hasReachedMax
                      ? state.posts.length
                      : state.posts.length + 1,
                  controller: _scrollController,
                ),
              );
            case PostStatus.initial:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _PostItem(Post post) {
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
                  post.title,
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
                      _showComfirmDelete(post);
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
            post.body,
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
                    _showComments(post);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.comment, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      post.id == state.id
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

  void _showComments(Post post) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return FractionallySizedBox(
              heightFactor: 0.8, child: ListComment(post));
        });
  }

  void _showComfirmDelete(Post post) {
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
                  _postsBloc.add(PostDeleted(post: post));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
