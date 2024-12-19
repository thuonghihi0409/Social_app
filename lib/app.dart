import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/social/bloc/comment_bloc/comments_bloc.dart';
import 'package:social_app/social/bloc/photo_bloc/photos_bloc.dart';
import 'package:social_app/social/bloc/post_bloc/posts_bloc.dart';

import 'package:social_app/social/view/image_screen.dart';
import 'package:social_app/social/view/post_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsBloc>(
          create: (BuildContext context) => PostsBloc(),
        ),
        BlocProvider<PhotosBloc>(
          create: (BuildContext context) => PhotosBloc(),
        ),
        BlocProvider<CommentsBloc>(
          create: (BuildContext context) => CommentsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    PostScreen(),
    ImageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _screens,
          ),
          Positioned(
            bottom: 5,
            left: 40,
            right: 40,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    // move page when selected
                    _pageController.jumpToPage(index);
                  },
                  items: [
                    _buildNavItem(
                      icon: Icons.post_add,
                      index: 0,
                      label: 'Posts',
                    ),
                    _buildNavItem(
                      icon: Icons.photo,
                      index: 1,
                      label: 'Photos',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: _selectedIndex == index
              ? [Colors.purple, Colors.blue]
              : [Colors.white.withOpacity(0.7), Colors.white.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
      label: '',
    );
  }
}
