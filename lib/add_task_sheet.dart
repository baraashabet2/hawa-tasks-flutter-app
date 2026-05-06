import 'package:flutter/material.dart';
import 'model/task.dart';
import 'wedget/app_colors.dart';

class AddTaskSheet extends StatefulWidget {
  final void Function(
    String title,
    TaskEnergy energy,
    String? note,
    String? startTime,
    String? endTime,
  )
  onSubmit;

  final Task? initialTask;

  const AddTaskSheet({super.key, required this.onSubmit, this.initialTask});

  bool get isEditing => initialTask != null;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();

  TaskEnergy _selectedEnergy = TaskEnergy.medium;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _startTimeText;
  String? _endTimeText;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
    _noteFocusNode.addListener(() => setState(() {}));

    final task = widget.initialTask;
    if (task != null) {
      _controller.text = task.title;
      _noteController.text = task.note ?? '';
      _selectedEnergy = task.energy;
      _startTimeText = task.startTime;
      _endTimeText = task.endTime;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _noteFocusNode.dispose();
    _controller.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Color _getEnergyColor(TaskEnergy e, AppColors colors) {
    switch (e) {
      case TaskEnergy.low:
        return colors.low;
      case TaskEnergy.medium:
        return colors.medium;
      case TaskEnergy.high:
        return colors.high;
    }
  }

  Color _getEnergyBg(TaskEnergy e, AppColors colors) {
    switch (e) {
      case TaskEnergy.low:
        return colors.lowBg;
      case TaskEnergy.medium:
        return colors.mediumBg;
      case TaskEnergy.high:
        return colors.highBg;
    }
  }

  String _getEnergyLabel(TaskEnergy e) {
    switch (e) {
      case TaskEnergy.low:
        return 'خفيفة';
      case TaskEnergy.medium:
        return 'متوسطة';
      case TaskEnergy.high:
        return 'عالية';
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? _startTime ?? TimeOfDay.now()),
      builder: (context, child) {
        final colors = AppColors.of(context);
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: colors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startTimeText = picked.format(context);
        } else {
          _endTime = picked;
          _endTimeText = picked.format(context);
        }
      });
    }
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;

    widget.onSubmit(
      _controller.text.trim(),
      _selectedEnergy,
      _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      _startTimeText,
      _endTimeText,
    );

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) Navigator.pop(context);
    });
  }

  InputDecoration _inputDecoration({
    required AppColors colors,
    required String hintText,
    required IconData icon,
    required bool isFocused,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: colors.textSecondary.withOpacity(0.6),
        fontSize: 15,
      ),
      filled: true,
      fillColor: isFocused ? colors.surface : colors.background,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colors.textSecondary.withOpacity(0.18),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
      prefixIcon: Icon(
        icon,
        color: isFocused
            ? colors.primary
            : colors.textSecondary.withOpacity(0.6),
        size: 24,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _timeBox({
    required BuildContext context,
    required String title,
    required String? timeText,
    required VoidCallback onTap,
  }) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.textSecondary.withOpacity(0.18),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: colors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeText == null || timeText.trim().isEmpty
                        ? 'اختيار'
                        : timeText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: timeText == null || timeText.trim().isEmpty
                          ? FontWeight.w400
                          : FontWeight.w600,
                      color: timeText == null || timeText.trim().isEmpty
                          ? colors.textSecondary
                          : colors.textPrimary,
                    ),
                  ),
                ],
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.only(
            top: 32,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colors.textSecondary.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  widget.isEditing ? 'تعديل المهمة' : 'مهمة جديدة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: !widget.isEditing,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _inputDecoration(
                    colors: colors,
                    hintText: 'شو ناوي تنجز اليوم؟',
                    icon: Icons.edit_note_rounded,
                    isFocused: _focusNode.hasFocus,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _noteController,
                  focusNode: _noteFocusNode,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _inputDecoration(
                    colors: colors,
                    hintText: 'ملاحظة (اختياري)',
                    icon: Icons.sticky_note_2_outlined,
                    isFocused: _noteFocusNode.hasFocus,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _timeBox(
                        context: context,
                        title: 'من',
                        timeText: _startTimeText,
                        onTap: () => _pickTime(true),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _timeBox(
                        context: context,
                        title: 'إلى',
                        timeText: _endTimeText,
                        onTap: () => _pickTime(false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'مستوى الطاقة المطلوبة',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: TaskEnergy.values.map((e) {
                    final bool isSelected = _selectedEnergy == e;
                    final Color activeColor = _getEnergyColor(e, colors);
                    final Color bgColor = _getEnergyBg(e, colors);
                    final String label = _getEnergyLabel(e);

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedEnergy = e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? bgColor : colors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? activeColor
                                    : colors.textSecondary.withOpacity(0.18),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? activeColor
                                    : colors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.isEditing ? 'حفظ التعديلات' : 'إضافة المهمة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.background,
                      ),
                    ),
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
