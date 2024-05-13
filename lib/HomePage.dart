import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniges_backup_manager/BackupExecutor/BackupExecutor.dart';
import 'package:uniges_backup_manager/BackupLogger/BackupLogger.dart';
import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';
import 'package:uniges_backup_manager/BackupSettings/HomeSettings.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<BackupInfo> backupHistory = [];

  @override
  void initState() {
    super.initState();
    loadBackupHistory();
  }

  // Load backup history from local storage
  Future<void> loadBackupHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? backupHistoryStringList =
        prefs.getStringList('backupHistory');

    if (backupHistoryStringList != null) {
      setState(() {
        backupHistory = backupHistoryStringList
            .map(
                (backupString) => BackupInfo.fromJson(jsonDecode(backupString)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: Container(
              color: Colors.grey[800],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Add New Backup',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.add, color: Colors.white),
                    onTap: () {
                      Navigator.pushNamed(context, '/backupConfig');
                    },
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text(
                      'Backup Logger',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.assignment, color: Colors.white),
                    onTap: () async {
                      await loadBackupHistory();
                      if (backupHistory.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BackupLogger(
                              backupList: backupHistory,
                            ),
                          ),
                        );
                      } else {
                        print('No backup history available.');
                      }
                    },
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text(
                      'Settings',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(Icons.settings, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeSettings(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BackupExecutor.successfulBackups.isNotEmpty
                ? ListView.builder(
                    itemCount: BackupExecutor.successfulBackups.length,
                    itemBuilder: (context, index) {
                      final backup = BackupExecutor.successfulBackups[index];

                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[200]!, Colors.grey[100]!],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Icon(Icons.backup,
                              color: Colors.blueGrey, size: 40),
                          title: Text(
                            'Name: ${backup.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'Description: ${backup.description}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Scheduled Time: ${backup.cronExpression}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Folder Path: ${backup.folderPath}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Storage Type: ${backup.Storage}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.backup, size: 100, color: Colors.grey[900]),
                        SizedBox(height: 10),
                        Text('Add New Backup',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
