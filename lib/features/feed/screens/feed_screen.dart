import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/common/loader.dart';
import 'package:flutter_reddit_clone/core/common/post_card.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/community/controller/community_controller.dart';
import 'package:flutter_reddit_clone/features/post/controller/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
          data: (communities) => ref.watch(userPostsProvider(communities)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (Object error, StackTrace stackTrace) {
                if (kDebugMode) {
                  print(error);
                } // Done due to requiring an indexing link from console error
                return Center(child: Text(error.toString()));
              },
              loading: () => const Loader()),
          error: (Object error, StackTrace stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () => const Loader());
    }

    return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(guestPostsProvider).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                },
              );
            },
            error: (Object error, StackTrace stackTrace) {
              if (kDebugMode) {
                print(error);
              } // Done due to requiring an indexing link from console error
              return Center(child: Text(error.toString()));
            },
            loading: () => const Loader()),
        error: (Object error, StackTrace stackTrace) {
          return Center(child: Text(error.toString()));
        },
        loading: () => const Loader());
  }
}
