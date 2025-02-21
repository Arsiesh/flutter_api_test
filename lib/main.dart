import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FakerAPI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 73, 175, 153)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter FakerAPI Fetch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> persons = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPersons();
  }
  Future<void> fetchPersons() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://fakerapi.it/api/v1/persons?_quantity=10'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => persons = data['data']);
    }
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: isLoading 
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(itemCount: persons.length, itemBuilder: (context, index) {
        return ListTile( 
          leading: CircleAvatar(backgroundImage: NetworkImage('https://picsum.photos/200')), //The FakerAPI image link does not work
          title: Text(persons[index]['firstname'] + ' ' + persons[index]['lastname']),
          subtitle: Text(persons[index]['email']),
        );
      })
    );
  }
}
