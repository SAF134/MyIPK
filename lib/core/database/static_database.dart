import 'package:hive/hive.dart';
import '../services/notification_service.dart';

// ── Box Names ─────────────────────────────────────────────────────────
const String _kSchedulesBox = 'schedules';
const String _kCoursesBox = 'courses';
const String _kTasksBox = 'tasks';
const String _kProfileBox = 'profile';

// ── Profile Keys ──────────────────────────────────────────────────────
const String _kProfileName = 'name';
const String _kProfileUniv = 'univ';
const String _kProfileMajor = 'major';
const String _kProfilePic = 'pic';

// ── Models ────────────────────────────────────────────────────────────

class ScheduleItem {
  final String id;
  final String courseName;
  final String day;
  final String startTime;
  final String endTime;
  final String room;

  ScheduleItem({
    required this.id,
    required this.courseName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseName': courseName,
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
  };

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
    id: json['id'] as String,
    courseName: json['courseName'] as String,
    day: json['day'] as String,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    room: json['room'] as String,
  );
}

class CourseItem {
  final String id;
  final String name;
  final int sks;
  final String grade; // A, AB, B, BC, C, D, E
  final int semester;

  CourseItem({
    required this.id,
    required this.name,
    required this.sks,
    required this.grade,
    required this.semester,
  });

  double get gradePoint {
    switch (grade) {
      case 'A': return 4.0;
      case 'AB': return 3.5;
      case 'B': return 3.0;
      case 'BC': return 2.5;
      case 'C': return 2.0;
      case 'D': return 1.0;
      case 'E': return 0.0;
      default: return 0.0;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sks': sks,
    'grade': grade,
    'semester': semester,
  };

  factory CourseItem.fromJson(Map<String, dynamic> json) => CourseItem(
    id: json['id'] as String,
    name: json['name'] as String,
    sks: json['sks'] as int,
    grade: json['grade'] as String,
    semester: json['semester'] as int,
  );
}

class TaskItem {
  final String id;
  final String courseName;
  final String description;
  final DateTime deadline; // full date+time

  TaskItem({
    required this.id,
    required this.courseName,
    required this.description,
    required this.deadline,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseName': courseName,
    'description': description,
    'deadline': deadline.toIso8601String(),
  };

  factory TaskItem.fromJson(Map<String, dynamic> json) => TaskItem(
    id: json['id'] as String,
    courseName: json['courseName'] as String,
    description: json['description'] as String,
    deadline: DateTime.parse(json['deadline'] as String),
  );
}

// ── Persistent Database (Hive) ────────────────────────────────────────

class StaticDatabase {
  // Singleton pattern
  static final StaticDatabase _instance = StaticDatabase._internal();
  factory StaticDatabase() => _instance;
  StaticDatabase._internal();

  // ── Hive Boxes ──────────────────────────────────────────────────
  late Box<ScheduleItem> _schedulesBox;
  late Box<CourseItem> _coursesBox;
  late Box<TaskItem> _tasksBox;
  late Box _profileBox;
  bool _isInitialized = false;

  // ── Initialization ──────────────────────────────────────────────
  /// Must be called once before using the database (e.g. in main()).
  /// Hive.initFlutter() and adapter registration must happen before this.
  Future<void> init() async {
    if (_isInitialized) return;

    _schedulesBox = await Hive.openBox<ScheduleItem>(_kSchedulesBox);
    _coursesBox = await Hive.openBox<CourseItem>(_kCoursesBox);
    _tasksBox = await Hive.openBox<TaskItem>(_kTasksBox);
    _profileBox = await Hive.openBox(_kProfileBox);

    _isInitialized = true;
  }

  // ── Profile Getters & Saving ────────────────────────────────────
  String get profileName => _profileBox.get(_kProfileName, defaultValue: 'Budi Sudarsono') as String;
  String get profileUniv => _profileBox.get(_kProfileUniv, defaultValue: 'Universitas Gadjah Mada') as String;
  String get profileMajor => _profileBox.get(_kProfileMajor, defaultValue: 'Teknik Informatika') as String;
  String? get profilePicBase64 => _profileBox.get(_kProfilePic) as String?;

  Future<void> saveProfile({
    required String name,
    required String university,
    required String major,
    String? profilePicBase64,
  }) async {
    await _profileBox.put(_kProfileName, name);
    await _profileBox.put(_kProfileUniv, university);
    await _profileBox.put(_kProfileMajor, major);
    if (profilePicBase64 != null) {
      await _profileBox.put(_kProfilePic, profilePicBase64);
    } else {
      await _profileBox.delete(_kProfilePic);
    }
  }

  // ── Schedule Methods ────────────────────────────────────────────
  List<ScheduleItem> getSchedules() => _schedulesBox.values.toList();

  List<ScheduleItem> getSchedulesByDay(String day) {
    return _schedulesBox.values.where((s) => s.day == day).toList();
  }

  void addSchedule(ScheduleItem item) {
    _schedulesBox.put(item.id, item);
    NotificationService().scheduleClassReminder(item);
  }

  void deleteSchedule(String id) {
    _schedulesBox.delete(id);
    NotificationService().cancelScheduleReminder(id);
  }

  void updateSchedule(ScheduleItem updatedItem) {
    _schedulesBox.put(updatedItem.id, updatedItem);
    NotificationService().scheduleClassReminder(updatedItem);
  }

  // ── Course Methods ──────────────────────────────────────────────
  List<CourseItem> getCourses() => _coursesBox.values.toList();

  List<CourseItem> getCoursesBySemester(int semester) {
    return _coursesBox.values.where((c) => c.semester == semester).toList();
  }

  void addCourse(CourseItem item) {
    _coursesBox.put(item.id, item);
  }

  void deleteCourse(String id) {
    _coursesBox.delete(id);
  }

  void updateCourse(CourseItem updatedItem) {
    _coursesBox.put(updatedItem.id, updatedItem);
  }

  // ── Calculations ────────────────────────────────────────────────

  int get totalSks {
    return _coursesBox.values.fold(0, (sum, item) => sum + item.sks);
  }

  int get totalCourses {
    return _coursesBox.length;
  }

  double get overallGpa {
    final courses = _coursesBox.values.toList();
    if (courses.isEmpty) return 0.0;
    double weightedPoints = 0.0;
    int totalSksCount = 0;
    for (var course in courses) {
      weightedPoints += course.gradePoint * course.sks;
      totalSksCount += course.sks;
    }
    return totalSksCount == 0 ? 0.0 : double.parse((weightedPoints / totalSksCount).toStringAsFixed(2));
  }

  int getSksBySemester(int semester) {
    return getCoursesBySemester(semester).fold(0, (sum, item) => sum + item.sks);
  }

  double getIpsBySemester(int semester) {
    final semesterCourses = getCoursesBySemester(semester);
    if (semesterCourses.isEmpty) return 0.0;
    double weightedPoints = 0.0;
    int totalSksCount = 0;
    for (var course in semesterCourses) {
      weightedPoints += course.gradePoint * course.sks;
      totalSksCount += course.sks;
    }
    return totalSksCount == 0 ? 0.0 : double.parse((weightedPoints / totalSksCount).toStringAsFixed(2));
  }

  // ── Task Methods ─────────────────────────────────────────────────
  List<TaskItem> getTasks() => _tasksBox.values.toList();

  /// Returns up to [limit] tasks sorted by nearest deadline (future only).
  /// If [limit] is null, returns all upcoming tasks.
  List<TaskItem> getUpcomingTasks({int? limit}) {
    final now = DateTime.now();
    final upcoming = _tasksBox.values.where((t) => t.deadline.isAfter(now)).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return limit != null ? upcoming.take(limit).toList() : upcoming;
  }

  void addTask(TaskItem item) {
    _tasksBox.put(item.id, item);
    NotificationService().scheduleTaskReminder(item);
  }

  void deleteTask(String id) {
    _tasksBox.delete(id);
    NotificationService().cancelTaskReminder(id);
  }

  void updateTask(TaskItem updatedItem) {
    _tasksBox.put(updatedItem.id, updatedItem);
    NotificationService().scheduleTaskReminder(updatedItem);
  }
}
