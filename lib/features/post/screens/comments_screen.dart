import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/common/loader.dart';
import 'package:flutter_reddit_clone/core/common/post_card.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/post/controller/post_controller.dart';
import 'package:flutter_reddit_clone/features/post/widgets/comment_card.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
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

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
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
                  onSubmitted: (val) => addComment(data),
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'What are your thoughts?',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final comment = data[index];
                            return CommentCard(comment: comment);
                          },
                        ),
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      if (kDebugMode) {
                        print(error.toString());
                      }
                      return Center(child: Text(error.toString()));
                    },
                    loading: () => const Loader())
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
