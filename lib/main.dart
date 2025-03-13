import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'challenges_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('challengesBox');
  await Hive.openBox('achievementsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafíos Personales',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ChallengesPage(),
    );
  }
}
