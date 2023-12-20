import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/screens/login_screen.dart';
import 'package:flutter_reddit_clone/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

// Logged-Out routes:
final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

// Authenticated routes:
final loggedInRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: HomeScreen())});
