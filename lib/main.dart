import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_api_test/controllers/person_controller.dart';
import 'package:flutter_api_test/screens/person_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final PersonController personController = PersonController();
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  List<Map<String, dynamic>> persons = [];

  @override
  void initState() {
    super.initState();
    fetchPersons();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        fetchPersons();
      }
    });
  }

  Future<void> fetchPersons() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    List<Map<String, dynamic>> newPersons = await personController.fetchPersons();

    setState(() {
      persons.addAll(newPersons);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            persons.clear();
            personController.page = 1;
            personController.fetchCount = 0;
            personController.noMoreData = false;
          });
          await fetchPersons();
        },
        child: Center(
          child: SizedBox(
            height: kIsWeb ? 600 : null, 
            child: ListView.builder(
              controller: scrollController,
              itemCount: persons.length + 1,
              itemBuilder: (context, index) {
                if (index < persons.length) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200')), // FakerAPI image doesn't work
                    title: Text(
                        '${persons[index]['firstname']} ${persons[index]['lastname']}'),
                    subtitle: Text(persons[index]['email']),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PersonDetailsPage(person: persons[index])));
                    },
                  );
                } else {
                  return personController.noMoreData
                      ? const Center(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No more data available')))
                      : const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
