import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

class TodoService {
  static const String _storageKey = 'todos_data';

  Future<List<Todo>> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosJson = prefs.getString(_storageKey);

      if (todosJson == null) return [];

      final List<dynamic> decodedList = jsonDecode(todosJson);
      return decodedList.map((item) => Todo.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading todos: $e');
      return [];
    }
  }

  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedList = jsonEncode(
        todos.map((todo) => todo.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encodedList);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }
}