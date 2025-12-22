import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

enum FilterType { all, completed, incomplete }

class TodoProvider extends ChangeNotifier {
  final TodoService _service = TodoService();
  final _uuid = const Uuid();

  List<Todo> _todos = [];
  FilterType _currentFilter = FilterType.all;
  bool _isLoading = false;

  List<Todo> get todos {
    switch (_currentFilter) {
      case FilterType.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case FilterType.incomplete:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case FilterType.all:
        return _todos;
    }
  }

  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((t) => t.isCompleted).length;
  int get incompleteTodos => _todos.where((t) => !t.isCompleted).length;
  FilterType get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();
    _todos = await _service.loadTodos();
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(FilterType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title,
    );
    _todos.add(newTodo);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> updateTodo(String id, String newTitle) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = Todo(
        id: id, 
        title: newTitle, 
        isCompleted: _todos[index].isCompleted,
        createdAt: _todos[index].createdAt,
      );
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> deleteCompletedTodos() async {
    _todos.removeWhere((t) => t.isCompleted);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> clearAllTodos() async {
    _todos.clear();
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    await _service.saveTodos(_todos);
  }
}