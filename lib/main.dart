import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cureman/models/home.dart';

import 'common/theme.dart';
import 'package:cureman/models/goal.dart';
import 'package:cureman/models/mantra.dart';
import 'package:cureman/models/mantra_audio.dart';
import 'package:cureman/models/mentor.dart';
import 'package:cureman/models/repetition.dart';
import 'package:cureman/screens/goal.dart';
import 'package:cureman/screens/mantra.dart';
import 'package:cureman/screens/mantra_audio.dart';
import 'package:cureman/screens/mentor.dart';
import 'package:cureman/screens/repetition.dart';
import 'package:cureman/screens/login.dart';
import 'package:cureman/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storedMantra = prefs.getString('selectedMantra');
  final initialLocation =
      (storedMantra == null || storedMantra.isEmpty) ? '/mantra' : '/home';

  final goRouter = createRouter(initialLocation);
  runApp(MyApp(router: goRouter));
}

GoRouter createRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/mantra',
        builder: (context, state) => const MyMantra(),
      ),
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
  const MyApp({Key? key, required this.router}) : super(key: key);

  final GoRouter router;

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
        routerConfig: router,
      ),
    );
  }
}
