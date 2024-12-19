import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/social/bloc/post_bloc/posts_bloc.dart';

import 'package:social_app/social/widgets/buttom_loader.dart';

import 'package:social_app/social/widgets/post_item.dart';

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
      appBar: AppBar(
        title: const Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text('Posts'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 30,
                )),
          ),
        ],
      ),
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
                        : PostItem(
                            post: state.posts[index],
                            postsBloc: _postsBloc,
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
}
