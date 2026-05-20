import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/database/static_database.dart';
import 'core/database/adapters/schedule_adapter.dart';
import 'core/database/adapters/course_adapter.dart';
import 'core/database/adapters/task_adapter.dart';
import 'core/services/notification_service.dart';
import 'features/splash/splash_screen.dart';
import 'shared/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive and register TypeAdapters
  await Hive.initFlutter();
  Hive.registerAdapter(ScheduleItemAdapter());
  Hive.registerAdapter(CourseItemAdapter());
  Hive.registerAdapter(TaskItemAdapter());

  // Open Hive boxes and load data
  await StaticDatabase().init();
  // Initialize notification service and permissions
  await NotificationService().init();
  runApp(const MyIPKApp());
}

class MyIPKApp extends StatelessWidget {
  const MyIPKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyIPK',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/main': (_) => const AppShell(),
      },
    );
  }
}
