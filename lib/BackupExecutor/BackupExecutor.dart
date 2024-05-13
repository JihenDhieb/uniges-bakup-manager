import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:cron/cron.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniges_backup_manager/BackupConfig/SourceDataSelection.dart';

class BackupExecutor {
  static DatabaseBackupManager _backupManager = DatabaseBackupManager();
  static List<SuccessfulBackup> successfulBackups = [];
  static SharedPreferences? prefs;
  static bool _enableCompression = false;
  static Future<void> startBackup(
      List<String?> selectedFiles,
      String folderPath,
      String cronExpression,
      String? storageType,
      String? ftpUsername,
      String? ftpPassword,
      String? ftpServer,
      String? ftpPort,
      String? ftpPath,
      String? sftpServer,
      String? sftpPort,
      String? sftpPath,
      String server,
      String name,
      String description,
      String username,
      String password,
      String database,
      String port,
      DatabaseType databaseType) async {
    print(selectedFiles);
    Directory backupFolder = Directory(folderPath);
    if (!backupFolder.existsSync()) {
      backupFolder.createSync(recursive: true);
    }
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    var cron = Cron();

    cron.schedule(Schedule.parse(cronExpression), () async {
      if (storageType == 'local') {
        if (selectedFiles.isNotEmpty) {
          for (String? filePath in selectedFiles) {
            if (filePath != null) {
              File file = File(filePath);
              if (file.existsSync()) {
                String fileName = path.basename(filePath);
                await file.copy('${backupFolder.path}/$fileName');
              }
            }
          }
          print('Files backed up to local folder successfully!');
        }
        if (server.isNotEmpty) {
          _backupManager.executeBackupCommand(
            databaseType,
            server,
            username,
            password,
            database,
            folderPath,
            enableCompression: _enableCompression,
          );
        }

        successfulBackups.add(
          SuccessfulBackup(
            name: name,
            description: description,
            Storage: storageType,
            cronExpression: cronExpression,
            folderPath: folderPath,
          ),
        );

        prefs!.setStringList(
          'successfulBackups',
          successfulBackups
              .map((backup) => jsonEncode(backup.toJson()))
              .toList(),
        );

        print('Updated successfulBackups list:');
        successfulBackups.forEach((backup) {
          print(backup.toJson());
        });
      } else if (storageType == 'ftp') {
        if (ftpServer != null &&
            ftpPort != null &&
            ftpPath != null &&
            ftpUsername != null &&
            ftpPassword != null) {
          await sendFilesViaFTP(
              selectedFiles,
              ftpUsername,
              ftpPassword,
              ftpServer,
              ftpPort,
              ftpPath,
              server,
              username,
              password,
              database,
              databaseType);
        }
      } else if (storageType == 'sftp') {
        if (sftpServer != null && sftpPort != null && sftpPath != null) {
          await sendFilesViaSFTP(selectedFiles, sftpServer, sftpPort, sftpPath,
              server, username, password, database, databaseType);
        }
      }
    });
  }

  static Future<void> sendFilesViaSFTP(
      List<String?> selectedFiles,
      String sftpServer,
      String sftpPort,
      String sftpPath,
      String server,
      String username,
      String password,
      String database,
      DatabaseType databaseType) async {
    if (selectedFiles.isNotEmpty) {
      for (String? filePath in selectedFiles) {
        if (filePath != null) {
          File file = File(filePath);
          if (file.existsSync()) {
            String fileName = path.basename(filePath);
            String sftpFilePath = '$sftpPath/$fileName';
            await sendFileViaSFTP(file, sftpServer, sftpPort, sftpFilePath);
          }
        }
      }
      _backupManager.executeBackupCommand(
        databaseType,
        server,
        username,
        password,
        database,
        sftpPath,
        enableCompression: _enableCompression,
      );
      print('Files sent via SFTP successfully!');
    }
  }

  static Future<void> sendFilesViaFTP(
      List<String?> selectedFiles,
      String ftpUsername,
      String ftpPassword,
      String ftpServer,
      String ftpPort,
      String ftpPath,
      String server,
      String username,
      String password,
      String database,
      DatabaseType databaseType) async {
    if (selectedFiles.isNotEmpty) {
      for (String? filePath in selectedFiles) {
        if (filePath != null) {
          File file = File(filePath);
          if (file.existsSync()) {
            String fileName = path.basename(filePath);
            String ftpFilePath = '$ftpPath/$fileName';
            await sendFileViaFTP(file, ftpServer, ftpPort, ftpFilePath,
                ftpUsername, ftpPassword);
          }
        }
      }
      _backupManager.executeBackupCommand(
        databaseType,
        server,
        username,
        password,
        database,
        ftpPath,
        enableCompression: _enableCompression,
      );
      print('Files sent via FTP successfully!');
    }
  }

  static Future<void> sendFileViaFTP(
      File file,
      String ftpUsername,
      String ftpPassword,
      String ftpServer,
      String ftpPort,
      String ftpFilePath) async {
    try {
      Socket socket = await Socket.connect(ftpServer, int.parse(ftpPort));
      socket.writeln('PUT $ftpFilePath HTTP/1.1');
      socket.writeln('Host: $ftpServer');
      socket.writeln('');
      await socket.addStream(file.openRead());
      await socket.flush();
      await socket.close();
    } catch (e) {
      print('Error sending file via FTP: $e');
    }
  }

  static Future<void> sendFileViaSFTP(File file, String sftpServer,
      String sftpPort, String sftpFilePath) async {
    try {
      Socket socket = await Socket.connect(sftpServer, int.parse(sftpPort));
      socket.writeln('PUT $sftpFilePath HTTP/1.1');
      socket.writeln('Host: $sftpServer');
      socket.writeln('');
      await socket.addStream(file.openRead());
      await socket.flush();
      await socket.close();
    } catch (e) {
      print('Error sending file via SFTP: $e');
    }
  }
}

class SuccessfulBackup {
  late String name;
  late String description;
  late String folderPath;
  late String? Storage;
  late String cronExpression;

  SuccessfulBackup({
    required this.name,
    required this.description,
    required this.folderPath,
    required this.Storage,
    required this.cronExpression,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'folderPath': folderPath,
      'Storage': Storage,
      'cronExpression': cronExpression,
    };
  }
}
