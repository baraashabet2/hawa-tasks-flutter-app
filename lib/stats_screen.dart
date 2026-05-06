import 'package:flutter/material.dart';
import 'model/task.dart';
import 'wedget/app_colors.dart';

class StatsScreen extends StatelessWidget {
  final List<Task> tasks;

  const StatsScreen({super.key, required this.tasks});

  int get doneCount => tasks.where((t) => t.isDone).length;
  int get pendingCount => tasks.where((t) => !t.isDone).length;
  int get lowCount => tasks.where((t) => t.energy == TaskEnergy.low).length;
  int get mediumCount =>
      tasks.where((t) => t.energy == TaskEnergy.medium).length;
  int get highCount => tasks.where((t) => t.energy == TaskEnergy.high).length;
  double get progress => tasks.isEmpty ? 0 : doneCount / tasks.length;

  Widget _statCard(String title, String value, Color color, AppColors colors) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _energyRow(String label, int count, Color color, AppColors colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: colors.textPrimary),
          ),
          const Spacer(),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ─────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تابع تقدمك اليومي',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'إحصائياتي',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Progress Card ───────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نسبة الإنجاز الإجمالية',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                          Text(
                            '$doneCount من ${tasks.length} مهام',
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: colors.lowBg,
                          valueColor: AlwaysStoppedAnimation(colors.primary),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Stats Cards ────────────────
                Row(
                  children: [
                    _statCard('مكتملة', '$doneCount', colors.primary, colors),
                    const SizedBox(width: 12),
                    _statCard('متبقية', '$pendingCount', colors.high, colors),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    _statCard(
                      'الإجمالي',
                      '${tasks.length}',
                      colors.medium,
                      colors,
                    ),
                    const SizedBox(width: 12),
                    _statCard(
                      'الحالة العامّة',
                      tasks.isEmpty
                          ? 'هادئ'
                          : (progress > 0.5 ? 'ممتاز' : 'جيد'),
                      colors.primary,
                      colors,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Energy Distribution ────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'توزيع مستويات الطاقة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _energyRow('مهام خفيفة', lowCount, colors.low, colors),
                      _energyRow(
                        'مهام متوسطة',
                        mediumCount,
                        colors.medium,
                        colors,
                      ),
                      _energyRow('مهام عالية', highCount, colors.high, colors),
                    ],
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
