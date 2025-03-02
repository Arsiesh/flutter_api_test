import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_api_test/providers/person_provider.dart';
import 'package:flutter_api_test/screens/person_details_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Detect when user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        Provider.of<PersonProvider>(context, listen: false).fetchPersons();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (kIsWeb)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: personProvider.refreshPersons,
            ),
        ],
      ),
      body: Consumer<PersonProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshPersons,
            child: provider.persons.isEmpty
                ? const Center(child: Text("No data available"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: provider.persons.length + 1,
                    itemBuilder: (context, index) {
                      if (index < provider.persons.length) {
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://picsum.photos/200'),
                          ),
                          title: Text(
                            '${provider.persons[index]['firstname']} ${provider.persons[index]['lastname']}',
                          ),
                          subtitle: Text(provider.persons[index]['email']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PersonDetailsPage(
                                    person: provider.persons[index]),
                              ),
                            );
                          },
                        );
                      } else {
                        return provider.noMoreData
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: Text('No more data available')),
                              )
                            : const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          );
        },
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: personProvider.fetchPersons,
              child: const Icon(Icons.download),
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
