import 'package:flutter/material.dart';
import 'model/task.dart';
import 'wedget/app_colors.dart';

enum TaskFilter { all, done, pending }

enum TaskSort { newest, oldest }

class TasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final void Function(String id) onToggle;
  final void Function(String id) onDelete;
  final void Function(Task task) onEditTask;

  const TasksScreen({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onEditTask,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _filter = TaskFilter.all;
  TaskSort _sort = TaskSort.newest;

  List<Task> get _filteredTasks {
    List<Task> list = [...widget.tasks];

    if (_filter == TaskFilter.done) {
      list = list.where((t) => t.isDone).toList();
    } else if (_filter == TaskFilter.pending) {
      list = list.where((t) => !t.isDone).toList();
    }

    if (_sort == TaskSort.newest) {
      list = list.reversed.toList();
    }

    return list;
  }

  Color _energyColor(TaskEnergy e, AppColors colors) {
    switch (e) {
      case TaskEnergy.low:
        return colors.low;
      case TaskEnergy.medium:
        return colors.medium;
      case TaskEnergy.high:
        return colors.high;
    }
  }

  String _energyLabel(TaskEnergy e) {
    switch (e) {
      case TaskEnergy.low:
        return 'خفيفة';
      case TaskEnergy.medium:
        return 'متوسطة';
      case TaskEnergy.high:
        return 'عالية';
    }
  }

  String? _taskTimeRange(Task task) {
    if ((task.startTime == null || task.startTime!.trim().isEmpty) &&
        (task.endTime == null || task.endTime!.trim().isEmpty)) {
      return null;
    }
    return '${task.startTime ?? '--'} - ${task.endTime ?? '--'}';
  }

  Widget _filterChip({
    required String title,
    required bool active,
    required VoidCallback onTap,
    required AppColors colors,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? colors.primary
                  : colors.textSecondary.withOpacity(0.14),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? colors.background : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sortChip(AppColors colors) {
    final label = _sort == TaskSort.newest ? 'الأحدث' : 'الأقدم';

    return PopupMenuButton<TaskSort>(
      color: colors.surface,
      onSelected: (value) => setState(() => _sort = value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (_) => const [
        PopupMenuItem(value: TaskSort.newest, child: Text('الأحدث')),
        PopupMenuItem(value: TaskSort.oldest, child: Text('الأقدم')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.textSecondary.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort_rounded, size: 18, color: colors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final tasks = _filteredTasks;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: colors.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رتّب كل مهامك بسهولة',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'مهامي',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'عرض المهام',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    _sortChip(colors),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _filterChip(
                      title: 'الكل',
                      active: _filter == TaskFilter.all,
                      onTap: () => setState(() => _filter = TaskFilter.all),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      title: 'مكتملة',
                      active: _filter == TaskFilter.done,
                      onTap: () => setState(() => _filter = TaskFilter.done),
                      colors: colors,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      title: 'غير مكتملة',
                      active: _filter == TaskFilter.pending,
                      onTap: () => setState(() => _filter = TaskFilter.pending),
                      colors: colors,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: tasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_rounded,
                                size: 54,
                                color: colors.textSecondary.withOpacity(0.30),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'ما في نتائج حالياً',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'جرّب تغيّر الفلتر أو أضف مهمة جديدة',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final timeRange = _taskTimeRange(task);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Dismissible(
                                key: Key(task.id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => widget.onDelete(task.id),
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    color: colors.highBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: colors.high,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () => widget.onToggle(task.id),
                                  onLongPress: () => widget.onEditTask(task),
                                  child: AnimatedScale(
                                    scale: task.isDone ? 0.97 : 1,
                                    duration: const Duration(milliseconds: 200),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: task.isDone
                                            ? colors.lowBg
                                            : colors.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: task.isDone
                                              ? colors.primary
                                              : Colors.transparent,
                                          width: 1.4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.04,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: task.isDone
                                                  ? colors.primary
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: task.isDone
                                                    ? colors.primary
                                                    : colors.textSecondary
                                                          .withOpacity(0.4),
                                                width: 2,
                                              ),
                                            ),
                                            child: task.isDone
                                                ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: colors.background,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.title,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: task.isDone
                                                        ? colors.textSecondary
                                                        : colors.textPrimary,
                                                    decoration: task.isDone
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : TextDecoration.none,
                                                    decorationColor: task.isDone
                                                        ? colors.textSecondary
                                                        : null,
                                                    decorationThickness: 2,
                                                  ),
                                                ),
                                                if (task.note != null &&
                                                    task.note!
                                                        .trim()
                                                        .isNotEmpty)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 4,
                                                        ),
                                                    child: Text(
                                                      task.note!,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: colors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                  ),
                                                if (timeRange != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 5,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_rounded,
                                                          size: 13,
                                                          color: colors.primary,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          timeRange,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                colors.primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _energyColor(
                                                task.energy,
                                                colors,
                                              ).withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              _energyLabel(task.energy),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: _energyColor(
                                                  task.energy,
                                                  colors,
                                                ),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
