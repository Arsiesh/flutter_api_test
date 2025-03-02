import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_api_test/screens/my_home_page.dart';
import 'package:flutter_api_test/providers/person_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PersonProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FakerAPI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 73, 175, 153),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter FakerAPI Fetch'),
    );
  }
}
