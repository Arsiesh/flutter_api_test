import 'package:flutter/material.dart';

class PersonDetailsPage extends StatelessWidget {
  final Map<String, dynamic> person;

  const PersonDetailsPage({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,title: Text('${person['firstname']} ${person['lastname']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
            ),
            SizedBox(height: 16),
            Text("Name: ${person['firstname']} ${person['lastname']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Email: ${person['email']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Phone: ${person['phone']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Address: ${person['address']['street']}, ${person['address']['city']}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
