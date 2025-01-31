import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/todo.dart'; // Jika menggunakan model data

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Todo>> getTodos() async {
    final url = Uri.parse('$baseUrl/todos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}