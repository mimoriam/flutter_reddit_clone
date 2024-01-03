import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/common/loader.dart';
import 'package:flutter_reddit_clone/core/common/post_card.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/post/controller/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              children: [
                PostCard(post: data),
                TextField(
                  onSubmitted: (val) => {},
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'What are your thoughts?',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              ],
            );
          },
          error: (Object error, StackTrace stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () => const Loader()),
    );
  }
}
