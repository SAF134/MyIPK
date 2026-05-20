import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../database/static_database.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle notification tap
        },
      );

      // Request permissions AFTER initialization (Android 13+)
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    } catch (e) {
      // Plugin not available (e.g. during hot restart) — fail silently
      return;
    }

    _isInitialized = true;
  }

  // Generate a unique integer ID from a string ID
  int _generateId(String id, String prefix) {
    return '$prefix-$id'.hashCode;
  }

  Future<void> scheduleClassReminder(ScheduleItem schedule) async {
    if (!_isInitialized) return;
    try {
      final int notificationId = _generateId(schedule.id, 'schedule');

      final tz.TZDateTime nextClassTime = _nextInstanceOfClassTime(schedule.day, schedule.startTime);
      final tz.TZDateTime reminderTime = nextClassTime.subtract(const Duration(minutes: 15));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: notificationId,
        title: 'Pengingat Kelas!',
        body: 'Mata kuliah ${schedule.courseName} akan dimulai 15 menit lagi di ruang ${schedule.room}.',
        scheduledDate: reminderTime,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'class_reminder_channel',
            'Class Reminders',
            channelDescription: 'Notifikasi pengingat jadwal kuliah 15 menit sebelum mulai',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } catch (_) {}
  }

  Future<void> cancelScheduleReminder(String id) async {
    if (!_isInitialized) return;
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _generateId(id, 'schedule'));
    } catch (_) {}
  }

  Future<void> scheduleTaskReminder(TaskItem task) async {
    if (!_isInitialized) return;
    try {
      final int notificationId = _generateId(task.id, 'task');

      // Remove old one just in case
      await cancelTaskReminder(task.id);

      final tz.TZDateTime deadline = tz.TZDateTime.from(task.deadline, tz.local);
      final tz.TZDateTime reminderTime = deadline.subtract(const Duration(hours: 24));

      // Only schedule if the reminder time is in the future
      if (reminderTime.isAfter(tz.TZDateTime.now(tz.local))) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: notificationId,
          title: 'Pengingat Tugas!',
          body: 'Tugas ${task.courseName} (${task.description}) besok adalah tenggat waktunya!',
          scheduledDate: reminderTime,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'task_reminder_channel',
              'Task Reminders',
              channelDescription: 'Notifikasi pengingat tugas 1 hari sebelum deadline',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    } catch (_) {}
  }

  Future<void> cancelTaskReminder(String id) async {
    if (!_isInitialized) return;
    try {
      await flutterLocalNotificationsPlugin.cancel(id: _generateId(id, 'task'));
    } catch (_) {}
  }

  tz.TZDateTime _nextInstanceOfClassTime(String dayName, String timeString) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    
    // Parse timeString e.g. "08:30"
    final parts = timeString.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    // Map dayName to DateTime weekday (1=Monday ... 7=Sunday)
    int targetDay = 1;
    switch (dayName.toLowerCase()) {
      case 'senin': targetDay = DateTime.monday; break;
      case 'selasa': targetDay = DateTime.tuesday; break;
      case 'rabu': targetDay = DateTime.wednesday; break;
      case 'kamis': targetDay = DateTime.thursday; break;
      case 'jumat': targetDay = DateTime.friday; break;
      case 'sabtu': targetDay = DateTime.saturday; break;
      case 'minggu': targetDay = DateTime.sunday; break;
    }

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
        
    while (scheduledDate.weekday != targetDay) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If it's the correct day but the time has already passed today, push to next week
    // We add 15 minutes logic later, but for now we find the exact class time.
    // Wait, since we trigger 15 minutes before, if now is 08:20 and class is 08:30, it has passed the *reminder* time.
    // The exact check should be if the *reminder time* is in the past, add 7 days.
    // But since this method just returns the class time, we'll check it here.
    if (scheduledDate.subtract(const Duration(minutes: 15)).isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    
    return scheduledDate;
  }
}
