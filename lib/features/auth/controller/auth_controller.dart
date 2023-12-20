import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/utils.dart';
import 'package:flutter_reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:flutter_reddit_clone/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        // isLoading variable default value to false:
        super(false);

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;

    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }
}
