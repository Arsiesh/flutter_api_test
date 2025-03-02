import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonProvider extends ChangeNotifier {
  List<Map<String, dynamic>> persons = [];
  int page = 1;
  bool isLoading = false;
  bool noMoreData = false;
  int fetchCount = 0; // ✅ Track number of fetch attempts

  Future<void> fetchPersons() async {
    if (isLoading || noMoreData) return;

    isLoading = true;
    notifyListeners();

    try {
      if (fetchCount == 3) { // ✅ Stop fetching after 3 attempts
        noMoreData = true;
      } else {
        final response = await http.get(Uri.parse(
            'https://fakerapi.it/api/v1/persons?_quantity=10&_page=$page'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['data'].isEmpty) {
            noMoreData = true;
          } else {
            page++;
            fetchCount++; // ✅ Increment fetch count
            persons.addAll(List<Map<String, dynamic>>.from(data['data']));
          }
        }
      }
    } catch (e) {
      print("Error fetching persons: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshPersons() async {
    persons.clear();
    page = 1;
    fetchCount = 0; // ✅ Reset fetch count on refresh
    noMoreData = false;
    await fetchPersons();
  }
}
