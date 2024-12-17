import 'package:flutter/material.dart';

class ReactionWidget extends StatefulWidget {
  const ReactionWidget({super.key});

  @override
  State<ReactionWidget> createState() => _ReactionWidgetState();
}

class _ReactionWidgetState extends State<ReactionWidget> {
 final List<Map<String, dynamic>> reactions = [
    {"emoji": "👍", "label": "Like"},
    {"emoji": "❤️", "label": "Love"},
    {"emoji": "😂", "label": "Haha"},
    {"emoji": "😮", "label": "Wow"},
    {"emoji": "😢", "label": "Sad"},
    {"emoji": "😡", "label": "Angry"},
  ];

  // Biến lưu trạng thái cảm xúc được chọn
  String? selectedReaction;

  // Hiển thị menu cảm xúc khi nhấn Like
  void showReactionMenu(BuildContext context, Offset position) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx - 80, // Điều chỉnh vị trí menu ngang
          top: position.dy - 60, // Điều chỉnh vị trí menu dọc
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: reactions.map((reaction) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReaction = reaction['emoji'];
                      });
                     // overlayEntry.remove();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            reaction['emoji'],
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);

    // Tự động ẩn menu sau 3 giây
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              GestureDetector(
                onLongPressStart: (details) {
                  showReactionMenu(context, details.globalPosition);
                },
                onTap: () {
                  setState(() {
                    selectedReaction = selectedReaction != null ? null : "👍";
                  });
                },
                child: Row(
                  children: [
                    // Icon(
                    //   selectedReaction == null ? Icons.favorite_border : Icons.favorite,
                    //   color: selectedReaction != null ? Colors.red : Colors.grey,
                    //   size: 18,
                    // ),
                    const SizedBox(width: 20),
                    Text(
                      selectedReaction ?? "👍",
                      style: TextStyle(
                        color: selectedReaction != null ? Colors.red : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}