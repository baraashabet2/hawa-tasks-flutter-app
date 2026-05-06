import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_task_sheet.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'stats_screen.dart';
import 'tasks_screen.dart';
import 'model/task.dart';
import 'wedget/app_colors.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  List<Task> _tasks = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('saved_tasks');

    if (tasksJson != null) {
      final List<dynamic> decodedList = json.decode(tasksJson);
      setState(() {
        _tasks = decodedList.map((item) => Task.fromMap(item)).toList();
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _tasks.map((task) => task.toMap()).toList(),
    );
    await prefs.setString('saved_tasks', encodedData);
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isDone = !task.isDone;
    });
    _saveTasks();
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    _saveTasks();
  }

  void _editTask(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddTaskSheet(
        initialTask: task,
        onSubmit: (title, energy, note, startTime, endTime) {
          setState(() {
            final index = _tasks.indexWhere((t) => t.id == task.id);
            if (index != -1) {
              _tasks[index] = task.copyWith(
                title: title,
                energy: energy,
                note: note,
                startTime: startTime,
                endTime: endTime,
              );
            }
          });

          _saveTasks();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم حفظ التعديلات بنجاح ✨'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AddTaskSheet(
        onSubmit: (title, energy, note, startTime, endTime) {
          setState(() {
            _tasks.add(
              Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                energy: energy,
                note: note,
                startTime: startTime,
                endTime: endTime,
              ),
            );
          });

          _saveTasks();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تمت إضافة المهمة بنجاح ✨'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final screens = [
      HomeScreen(
        tasks: _tasks,
        onToggleTask: _toggleTask,
        onDeleteTask: _deleteTask,
        onEditTask: _editTask,
      ),
      TasksScreen(
        tasks: _tasks,
        onToggle: _toggleTask,
        onDelete: _deleteTask,
        onEditTask: _editTask,
      ),
      StatsScreen(tasks: _tasks),
      const ProfileScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: IndexedStack(index: _currentIndex, children: screens),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: _addTask,
          backgroundColor: colors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          child: Icon(Icons.add, color: colors.background, size: 28),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: colors.surface,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'اليوم', colors),
                _buildNavItem(1, Icons.checklist_rounded, 'مهامي', colors),
                const SizedBox(width: 48),
                _buildNavItem(2, Icons.bar_chart_rounded, 'إحصائيات', colors),
                _buildNavItem(3, Icons.person, 'أنا', colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    AppColors colors,
  ) {
    final bool isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colors.primary
                  : colors.textSecondary.withOpacity(0.65),
              size: 26,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colors.primary
                    : colors.textSecondary.withOpacity(0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
