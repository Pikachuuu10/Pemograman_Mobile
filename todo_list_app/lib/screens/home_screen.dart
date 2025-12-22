import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/todo_card.dart';
import '../widgets/filter_chip_widget.dart';
import 'add_todo_screen.dart';
import 'edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 My Todo List'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete_completed',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: AppTheme.accentOrange),
                    SizedBox(width: 12),
                    Text('Hapus Selesai'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever_rounded, color: AppTheme.accentRed),
                    SizedBox(width: 12),
                    Text('Hapus Semua'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete_completed') {
                _showDeleteCompletedDialog();
              } else if (value == 'delete_all') {
                _showDeleteAllDialog();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.veryLightBlue,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildStatisticsCard(),
            _buildFilterChips(),
            Expanded(
              child: Consumer<TodoProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (provider.todos.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.todos.length,
                    itemBuilder: (context, index) {
                      final todo = provider.todos[index];
                      return TodoCard(
                        todo: todo,
                        onToggle: () => provider.toggleTodo(todo.id),
                        onEdit: () => _navigateToEditScreen(todo.id, todo.title),
                        onDelete: () => _showDeleteDialog(todo.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddScreen,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Todo'),
      ),
    );
  }
  
  Widget _buildStatisticsCard() {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.primarySoftBlue,
                AppTheme.secondaryBlue,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.list_alt_rounded,
                provider.totalTodos.toString(),
                'Total',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                Icons.check_circle_rounded,
                provider.completedTodos.toString(),
                'Selesai',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                Icons.pending_rounded,
                provider.incompleteTodos.toString(),
                'Belum',
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
  
  Widget _buildFilterChips() {
    return Consumer<TodoProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              FilterChipWidget(
                filterType: FilterType.all,
                isSelected: provider.currentFilter == FilterType.all,
                onTap: () => provider.setFilter(FilterType.all),
                label: 'Semua',
                icon: Icons.list_rounded,
              ),
              const SizedBox(width: 10),
              FilterChipWidget(
                filterType: FilterType.completed,
                isSelected: provider.currentFilter == FilterType.completed,
                onTap: () => provider.setFilter(FilterType.completed),
                label: 'Selesai',
                icon: Icons.check_circle_rounded,
              ),
              const SizedBox(width: 10),
              FilterChipWidget(
                filterType: FilterType.incomplete,
                isSelected: provider.currentFilter == FilterType.incomplete,
                onTap: () => provider.setFilter(FilterType.incomplete),
                label: 'Belum',
                icon: Icons.pending_rounded,
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak ada todo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap tombol + untuk menambah todo baru',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoScreen()),
    );
  }
  
  void _navigateToEditScreen(String id, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTodoScreen(id: id, currentTitle: title),
      ),
    );
  }
  
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Todo?'),
        content: const Text('Apakah Anda yakin ingin menghapus todo ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoProvider>().deleteTodo(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todo berhasil dihapus'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteCompletedDialog() {
    final completedCount = context.read<TodoProvider>().completedTodos;
    
    if (completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada todo yang selesai'),
          backgroundColor: AppTheme.accentOrange,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Todo Selesai?'),
        content: Text('Hapus $completedCount todo yang sudah selesai?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoProvider>().deleteCompletedTodos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todo selesai berhasil dihapus'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentOrange,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Semua Todo?'),
        content: const Text('Semua todo akan dihapus. Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoProvider>().clearAllTodos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua todo berhasil dihapus'),
                  backgroundColor: AppTheme.accentGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
            ),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }
}