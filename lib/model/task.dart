enum TaskEnergy { low, medium, high }

class Task {
  final String id;
  final String title;
  final TaskEnergy energy;
  bool isDone;

  final String? note;
  final String? startTime;
  final String? endTime;

  Task({
    required this.id,
    required this.title,
    required this.energy,
    this.isDone = false,
    this.note,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'energy': energy.index,
      'isDone': isDone,
      'note': note,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      energy: TaskEnergy.values[map['energy'] as int],
      isDone: map['isDone'] ?? false,
      note: map['note'] as String?,
      startTime: map['startTime'] as String?,
      endTime: map['endTime'] as String?,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    TaskEnergy? energy,
    bool? isDone,
    String? note,
    String? startTime,
    String? endTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      energy: energy ?? this.energy,
      isDone: isDone ?? this.isDone,
      note: note,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
