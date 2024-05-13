import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniges_backup_manager/BackupConfig/SourceDataSelection.dart';
import 'package:uniges_backup_manager/BackupExecutor/BackupExecutor.dart';
import 'package:uniges_backup_manager/BackupLogger/BackupLogger.dart';
import 'package:uniges_backup_manager/HomePage.dart';

class BackupScheduleForm extends StatefulWidget {
  final String name;
  final String description;
  final String? storageType;
  final String? folderPath;
  final List<String?> selectedFiles;
  final String? ftpUsername;
  final String? ftpPassword;
  final String? ftpServer;
  final String? ftpPort;
  final String? ftpServerPath;
  final String? sftpServer;
  final String? sftpPort;
  final String? sftpServerPath;
  final String server;
  final String username;
  final String password;
  final String database;
  final String port;
  final String backupPath;
  final DatabaseType databaseType;
  final List<BackupInfo> backupHistory;

  BackupScheduleForm({
    required this.name,
    required this.description,
    this.storageType,
    this.folderPath,
    required List<String?> selectedPaths,
    this.ftpUsername,
    this.ftpPassword,
    this.ftpServer,
    this.ftpPort,
    this.ftpServerPath,
    this.sftpServer,
    this.sftpPort,
    this.sftpServerPath,
    required this.server,
    required this.username,
    required this.password,
    required this.database,
    required this.port,
    required this.backupPath,
    required this.databaseType,
    required this.backupHistory,
  }) : selectedFiles = selectedPaths;

  @override
  _BackupScheduleFormState createState() => _BackupScheduleFormState();
}

class _BackupScheduleFormState extends State<BackupScheduleForm> {
  late TextEditingController _cronController;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _cronController = TextEditingController();
  }

  @override
  void dispose() {
    _cronController.dispose();
    super.dispose();
  }

  Future<void> saveBackupHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? existingBackupList = prefs.getStringList('backupHistory');
    List<String> backupHistoryStringList = [];

    if (existingBackupList != null) {
      backupHistoryStringList.addAll(existingBackupList);
    }

    backupHistoryStringList.addAll(
        widget.backupHistory.map((backup) => jsonEncode(backup.toJson())));

    prefs.setStringList('backupHistory', backupHistoryStringList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schedule Next Backup:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Enter cron expression:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cronController,
              decoration: InputDecoration(
                labelText: 'Cron Expression',
                hintText: '* * * * *',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedOption,
              onChanged: (newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'day',
                  child: Text('Every Day'),
                ),
                DropdownMenuItem(
                  value: 'week',
                  child: Text('Every Week'),
                ),
                DropdownMenuItem(
                  value: 'month',
                  child: Text('Every Month'),
                ),
                DropdownMenuItem(
                  value: 'year',
                  child: Text('Every Year'),
                ),
                DropdownMenuItem(
                  value: 'monday',
                  child: Text('Monday'),
                ),
                DropdownMenuItem(
                  value: 'tuesday',
                  child: Text('Tuesday'),
                ),
                DropdownMenuItem(
                  value: 'wednesday',
                  child: Text('Wednesday'),
                ),
                DropdownMenuItem(
                  value: 'thursday',
                  child: Text('Thursday'),
                ),
                DropdownMenuItem(
                  value: 'friday',
                  child: Text('Friday'),
                ),
                DropdownMenuItem(
                  value: 'saturday',
                  child: Text('Saturday'),
                ),
                DropdownMenuItem(
                  value: 'sunday',
                  child: Text('Sunday'),
                ),
              ],
              hint: Text('Select Schedule Option'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String cronExpression = _cronController.text;
                String? selectedOption = _selectedOption;
                if (cronExpression.isNotEmpty && selectedOption != null) {
                  setState(() {
                    widget.backupHistory.add(
                      BackupInfo(
                        name: widget.name,
                        description: widget.description,
                        dateTime: DateTime.now().toString(),
                        storageType: widget.storageType,
                        folderPath: widget.folderPath,
                      ),
                    );
                    saveBackupHistory();
                  });

                  BackupExecutor.startBackup(
                    widget.selectedFiles ?? [],
                    widget.folderPath ?? '',
                    cronExpression,
                    widget.storageType ?? '',
                    widget.ftpUsername,
                    widget.ftpPassword,
                    widget.ftpServer,
                    widget.ftpPort,
                    widget.ftpServerPath,
                    widget.sftpServer,
                    widget.sftpPort,
                    widget.sftpServerPath,
                    widget.server,
                    widget.name,
                    widget.description,
                    widget.database,
                    widget.backupPath,
                    widget.port,
                    widget.username,
                    widget.databaseType,
                  );
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter a schedule.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.grey[900]),
            ),
          ],
        ),
      ),
    );
  }
}

class BackupInfo {
  final String name;
  final String description;
  final String dateTime;
  final String? storageType;
  final String? folderPath;

  BackupInfo({
    required this.name,
    required this.description,
    required this.dateTime,
    this.storageType,
    this.folderPath,
  });

  factory BackupInfo.fromJson(Map<String, dynamic> json) {
    return BackupInfo(
      name: json['name'],
      description: json['description'],
      dateTime: json['dateTime'],
      storageType: json['storageType'],
      folderPath: json['folderPath'],
    );
  }

  // Serialize BackupInfo object into JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dateTime': dateTime,
      'storageType': storageType,
      'folderPath': folderPath,
    };
  }
}
