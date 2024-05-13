import 'package:flutter/material.dart';
import 'package:uniges_backup_manager/BackupConfig/BackupConfigForm.dart';
import 'package:uniges_backup_manager/BackupLogger/BackupLogger.dart';
import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';
import 'package:uniges_backup_manager/HomePage.dart';
import 'package:uniges_backup_manager/WelcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Backup',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/backupConfig': (context) => BackupConfigForm(),
        });
  }
}
