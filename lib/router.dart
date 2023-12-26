import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/screens/login_screen.dart';
import 'package:flutter_reddit_clone/features/community/screens/community_screen.dart';
import 'package:flutter_reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:flutter_reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

// Logged-Out routes:
final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

// Authenticated routes:
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  // dynamic route
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
});
