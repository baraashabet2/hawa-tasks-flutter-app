import 'package:flutter/material.dart';
import 'model/task.dart';
import 'wedget/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final List<Task> tasks;
  final void Function(String id) onToggleTask;
  final void Function(String id) onDeleteTask;
  final void Function(Task task) onEditTask;

  const HomeScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onEditTask,
  });

  int get _doneTasks => tasks.where((t) => t.isDone).length;
  double get _progress => tasks.isEmpty ? 0 : _doneTasks / tasks.length;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء النور';
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

  Color _energyBg(TaskEnergy e, AppColors colors) {
    switch (e) {
      case TaskEnergy.low:
        return colors.lowBg;
      case TaskEnergy.medium:
        return colors.mediumBg;
      case TaskEnergy.high:
        return colors.highBg;
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: colors.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'يومك اليوم',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colors.primary,
                          child: Text(
                            'أ',
                            style: TextStyle(
                              color: colors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$_doneTasks من ${tasks.length} مهام',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                ),
                              ),
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _progress,
                              minHeight: 8,
                              backgroundColor: colors.lowBg,
                              valueColor: AlwaysStoppedAnimation(
                                colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 70,
                              color: colors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ابدأ يومك بأول مهمة ✨',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'اضغط + لإضافة مهمة جديدة',
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final timeRange = _taskTimeRange(task);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: Key(task.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: colors.highBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: colors.high,
                                ),
                              ),
                              onDismissed: (_) => onDeleteTask(task.id),
                              child: GestureDetector(
                                onTap: () => onToggleTask(task.id),
                                onLongPress: () => onEditTask(task),
                                child: AnimatedScale(
                                  scale: task.isDone ? 0.97 : 1,
                                  duration: const Duration(milliseconds: 200),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
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
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
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
                                                  decorationThickness: 2,
                                                ),
                                              ),
                                              if (task.note != null &&
                                                  task.note!.trim().isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        top: 4,
                                                      ),
                                                  child: Text(
                                                    task.note!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          colors.textSecondary,
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
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        timeRange,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: colors.primary,
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
                                            color: _energyBg(
                                              task.energy,
                                              colors,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
    );
  }
}
