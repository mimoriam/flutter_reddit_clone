import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/constants/constants.dart';
import 'package:flutter_reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/core/type_defs.dart';
import 'package:flutter_reddit_clone/core/utils.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/community/repository/community_repository.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider.autoDispose<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      ref: ref,
      storageRepository: ref.watch(storageRepositoryProvider));
});

final userCommunitiesProvider =
    StreamProvider.family.autoDispose<List<Community>, String>((ref, uid) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities(uid);
});

final getCommunityByNameProvider =
    StreamProvider.family.autoDispose((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider =
    StreamProvider.family.autoDispose((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

final getCommunityPostsProvider =
    StreamProvider.family.autoDispose((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    // final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null) {
      // communities/profile/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      // communities/banner/memes
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, "Community left successfully");
      } else {
        showSnackBar(context, "Community joined successfully");
      }
    });
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
