import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spiritual_currency/models/home.dart';

import 'common/theme.dart';
import 'package:spiritual_currency/models/goal.dart';
import 'package:spiritual_currency/models/mantra.dart';
import 'package:spiritual_currency/models/mantra_audio.dart';
import 'package:spiritual_currency/models/mentor.dart';
import 'package:spiritual_currency/models/repetition.dart';
import 'package:spiritual_currency/screens/goal.dart';
import 'package:spiritual_currency/screens/mantra.dart';
import 'package:spiritual_currency/screens/mantra_audio.dart';
import 'package:spiritual_currency/screens/mentor.dart';
import 'package:spiritual_currency/screens/repetition.dart';
import 'package:spiritual_currency/screens/login.dart';
import 'package:spiritual_currency/screens/home.dart';

void main() {
  runApp(const MyApp()); //const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const MyLogin(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MyHomePage(title: 'Cureman'),
        routes: [
          GoRoute(
            path: 'goal',
            builder: (context, state) => const MyGoal(),
          ),
          GoRoute(
            path: 'mentor',
            builder: (context, state) => const MyMentor(),
          ),
          GoRoute(
            path: 'mantra',
            builder: (context, state) => const MyMantra(),
          ),
          GoRoute(
            path: 'mantraAudio',
            builder: (context, state) => const MyMantraAudio(),
          ),
          GoRoute(
            path: 'repetition',
            builder: (context, state) => const MyRepetition(),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeModel()),
        ChangeNotifierProvider(create: (context) => GoalModel()),
        ChangeNotifierProvider(create: (context) => MentorModel()),
        ChangeNotifierProvider(create: (context) => MantraModel()),
        ChangeNotifierProvider(create: (context) => MantraAudioModel()),
        ChangeNotifierProvider(create: (context) => RepetitionModel()),
      ],
      child: MaterialApp.router(
        title: 'Cureman',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}