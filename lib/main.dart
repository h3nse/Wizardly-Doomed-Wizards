import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/pages/find_opponent_page.dart';
import 'package:wizardly_fucked_wizards/pages/front_page.dart';
import 'package:wizardly_fucked_wizards/pages/game_countdown_page.dart';
import 'package:wizardly_fucked_wizards/pages/game_page.dart';
import 'package:wizardly_fucked_wizards/pages/incoming_challenge_page.dart';
import 'package:wizardly_fucked_wizards/pages/outgoing_challenge_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  const supabaseUrl = 'https://jcwxzybnrickofvzkgge.supabase.co';
  final supabaseKey = dotenv.env['SUPABASE_KEY']!;

  await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      realtimeClientOptions: const RealtimeClientOptions(
          eventsPerSecond: 10)); // Change eventsPerSecond to sync more often
  runApp(const WfwApp());
}

class WfwApp extends StatelessWidget {
  const WfwApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 119, 26, 123),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromARGB(255, 255, 0, 0),
          onSecondary: Color.fromARGB(255, 255, 0, 0),
          error: Color.fromARGB(255, 255, 0, 0),
          onError: Color.fromARGB(255, 255, 0, 0),
          background: Color.fromARGB(255, 255, 255, 255),
          onBackground: Color.fromARGB(255, 197, 190, 186),
          surface: Color.fromARGB(255, 255, 255, 255),
          onSurface: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: const FrontPage(),
    );
  }
}
