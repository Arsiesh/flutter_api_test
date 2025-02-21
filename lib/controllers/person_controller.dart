import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonController {
  int page = 1;
  int fetchCount = 0;
  bool noMoreData = false;
  bool isLoading = false;

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    if (isLoading || noMoreData) return [];

    isLoading = true;
    final response = await http.get(Uri.parse('https://fakerapi.it/api/v1/persons?_quantity=10&_page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['data'].isEmpty || fetchCount == 3) {
        noMoreData = true;
        isLoading = false;
        return [];
      }

      page++;
      fetchCount++;
      isLoading = false;
      return List<Map<String, dynamic>>.from(data['data']);
    }

    isLoading = false;
    return [];
  }
}
