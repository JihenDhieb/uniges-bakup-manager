import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';

enum DatabaseType {
  SQL,
  MongoDB,
  None,
}

class SourceDataSelectionPage extends StatefulWidget {
  final String name;
  final String description;
  final String storageType;
  final String? folderPath;
  final String? ftpUsername;
  final String? ftpPassword;
  final String? ftpServer;
  final String? ftpPort;
  final String? ftpServerPath;
  final String? sftpServer;
  final String? sftpPort;
  final String? sftpServerPath;
  final List<BackupInfo> backupHistory;

  SourceDataSelectionPage({
    required this.name,
    required this.description,
    required this.storageType,
    this.folderPath,
    this.ftpUsername,
    this.ftpPassword,
    this.ftpServer,
    this.ftpPort,
    this.ftpServerPath,
    this.sftpServer,
    this.sftpPort,
    this.sftpServerPath,
    required this.backupHistory,
  });

  @override
  _SourceDataSelectionPageState createState() =>
      _SourceDataSelectionPageState();
}

class _SourceDataSelectionPageState extends State<SourceDataSelectionPage> {
  final List<String?> _selectedPaths = [];
  final DatabaseBackupManager _backupManager = DatabaseBackupManager();
  DatabaseType? _selectedDatabaseType;

  Future<void> _selectFilesOrDirectories() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: ['*'],
    );

    if (result != null) {
      setState(() {
        _selectedPaths.addAll(result.paths);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup Configuration - Source Data Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Source Data Selection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(
                      Icons.person, // Icône pour le nom
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Name: ${widget.name}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.description, // Icône pour la description
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Description: ${widget.description}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.storage, // Icône pour le type de stockage
                      size: 24,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Storage Type: ${widget.storageType ?? 'Not selected'}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.storageType == 'ftp') ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'FTP Server: ${widget.ftpServer ?? 'Not selected'}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.router, // Icône pour le port FTP
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'FTP Port: ${widget.ftpPort ?? 'Not selected'}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.folder, // Icône pour le chemin du serveur FTP
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'FTP Server Path: ${widget.ftpServerPath ?? 'Not selected'}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons
                            .account_circle, // Icône pour le nom d'utilisateur FTP
                        size: 24,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'FTP Username: ${widget.ftpUsername ?? 'Not selected'}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            if (widget.storageType == 'sftp') ...[
              SizedBox(height: 10),
              Text(
                'SFTP Server: ${widget.sftpServer ?? 'Not selected'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'SFTP Port: ${widget.sftpPort ?? 'Not selected'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'SFTP Server Path: ${widget.sftpPort ?? 'Not selected'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
            if (widget.storageType == 'local') ...[
              SizedBox(height: 10),
              Text(
                'Folder Path: ${widget.folderPath ?? 'Not selected'}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: Text('Select Action'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              _selectFilesOrDirectories();
                            },
                            child: Text('Select Files or Directories',
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: 10),
                          Text('Select Database Type:'),
                          Column(
                            children: [
                              RadioListTile<DatabaseType>(
                                title: const Text('SQL'),
                                value: DatabaseType.SQL,
                                groupValue: _selectedDatabaseType,
                                onChanged: (DatabaseType? value) {
                                  setState(() {
                                    _selectedDatabaseType = value;
                                  });
                                  Navigator.of(dialogContext).pop();

                                  showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext databaseDialogContext) {
                                      return _backupManager
                                          .buildBackupConfigurationDialog(
                                              databaseDialogContext,
                                              widget.folderPath ?? '',
                                              DatabaseType.SQL, onSave: (server,
                                                  username,
                                                  password,
                                                  database,
                                                  port,
                                                  backupPath) {
                                        print('Server: $server');
                                        print('Username: $username');
                                        print('Password: $password');
                                        print('Database: $database');
                                        print('Port: $port');
                                        print('Backup Path: $backupPath');
                                      });
                                    },
                                  );
                                },
                              ),
                              RadioListTile<DatabaseType>(
                                title: const Text('MongoDB'),
                                value: DatabaseType.MongoDB,
                                groupValue: _selectedDatabaseType,
                                onChanged: (DatabaseType? value) {
                                  setState(() {
                                    _selectedDatabaseType = value;
                                  });
                                  Navigator.of(dialogContext).pop();

                                  showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext databaseDialogContext) {
                                      return _backupManager
                                          .buildBackupConfigurationDialog(
                                        databaseDialogContext,
                                        widget.folderPath ?? '',
                                        DatabaseType.MongoDB,
                                        onSave: (server, username, password,
                                            database, port, backupPath) {
                                          print('Server: $server');
                                          print('Username: $username');
                                          print('Password: $password');
                                          print('Database: $database');
                                          print('Port: $port');
                                          print('Backup Path: $backupPath');
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                'Select Files or Database',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _selectedPaths.isNotEmpty
                  ? ListView(
                      children: _selectedPaths.map((path) {
                        return Card(
                          child: ListTile(
                            title: Text(path ?? ''),
                          ),
                        );
                      }).toList(),
                    )
                  : _selectedDatabaseType != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [],
                        )
                      : SizedBox(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedPaths.isNotEmpty &&
                    _selectedDatabaseType != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BackupScheduleForm(
                        name: widget.name,
                        description: widget.description,
                        storageType: widget.storageType,
                        folderPath: widget.storageType == 'local'
                            ? widget.folderPath
                            : null,
                        ftpUsername: widget.ftpUsername,
                        ftpPassword: widget.ftpPassword,
                        ftpServer: widget.ftpServer,
                        ftpPort: widget.ftpPort,
                        ftpServerPath: widget.ftpServerPath,
                        selectedPaths: _selectedPaths,
                        server: _backupManager._serverController.text,
                        username: _backupManager._usernameController.text,
                        password: _backupManager._passwordController.text,
                        database: _backupManager._databaseController.text,
                        port: _backupManager._portController.text,
                        backupPath: _backupManager._backupPathController.text,
                        databaseType: _selectedDatabaseType ?? DatabaseType.SQL,
                        backupHistory: widget.backupHistory,
                      ),
                    ),
                  );
                } else if (_selectedDatabaseType != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BackupScheduleForm(
                        name: widget.name,
                        description: widget.description,
                        storageType: widget.storageType,
                        folderPath: widget.storageType == 'local'
                            ? widget.folderPath
                            : null,
                        ftpUsername: widget.ftpUsername,
                        ftpPassword: widget.ftpPassword,
                        ftpServer: widget.ftpServer,
                        ftpPort: widget.ftpPort,
                        ftpServerPath: widget.ftpServerPath,
                        selectedPaths: [],
                        server: _backupManager._serverController.text,
                        username: _backupManager._usernameController.text,
                        password: _backupManager._passwordController.text,
                        database: _backupManager._databaseController.text,
                        port: _backupManager._portController.text,
                        backupPath: _backupManager._backupPathController.text,
                        databaseType: _selectedDatabaseType ?? DatabaseType.SQL,
                        backupHistory: widget.backupHistory,
                      ),
                    ),
                  );
                } else if (_selectedPaths.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BackupScheduleForm(
                        name: widget.name,
                        description: widget.description,
                        storageType: widget.storageType,
                        folderPath: widget.storageType == 'local'
                            ? widget.folderPath
                            : null,
                        ftpUsername: widget.ftpUsername,
                        ftpPassword: widget.ftpPassword,
                        ftpServer: widget.ftpServer,
                        ftpPort: widget.ftpPort,
                        ftpServerPath: widget.ftpServerPath,
                        selectedPaths: _selectedPaths,
                        server: '',
                        username: '',
                        password: '',
                        database: '',
                        port: '',
                        backupPath: '',
                        databaseType:
                            _selectedDatabaseType ?? DatabaseType.None,
                        backupHistory: widget.backupHistory,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please select files or database.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK',
                              style: TextStyle(color: Colors.grey[900])),
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

class DatabaseBackupManager {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _databaseController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _backupPathController = TextEditingController();
  bool _enableCompression = false;
  void executeBackupCommand(DatabaseType databaseType, String server,
      String username, String password, String database, String path,
      {bool enableCompression = false}) {
    String backupCommand = '';
    if (databaseType == DatabaseType.SQL) {
      backupCommand =
          'sqlcmd -S $server -U $username -P $password -Q "BACKUP DATABASE [$database] TO DISK = \'$path\\$database.bak\'WITH COMPRESSION"';
    } else if (databaseType == DatabaseType.MongoDB) {
      backupCommand = _enableCompression
          ? 'mongodump --uri="$server" --out $path --gzip'
          : 'mongodump --uri="$server" --out $path';
    }

    // Exécuter la commande de sauvegarde
    Process.run('cmd', ['/c', backupCommand]).then((ProcessResult results) {
      if (results.exitCode == 0) {
        print('Backup successful');
      } else {
        print('Backup failed: ${results.stderr}');
      }
    });
  }

  Widget buildBackupConfigurationDialog(
      BuildContext context, String folderPath, DatabaseType databaseType,
      {required Function(String, String, String, String, String, String)
          onSave}) {
    String dialogTitle = databaseType == DatabaseType.SQL
        ? 'SQL Backup Configuration'
        : 'MongoDB Backup Configuration';

    return AlertDialog(
      title: Text(dialogTitle),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _serverController,
                  decoration: InputDecoration(labelText: 'Server'),
                ),
                TextField(
                  controller: _portController,
                  decoration: InputDecoration(labelText: 'Port'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                if (databaseType == DatabaseType.SQL) ...[
                  TextField(
                    controller: _databaseController,
                    decoration: InputDecoration(labelText: 'Database'),
                  ),
                ],
                TextField(
                  controller: _backupPathController,
                  decoration: InputDecoration(labelText: 'Backup Path'),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _enableCompression,
                      onChanged: (bool? value) {
                        setState(() {
                          _enableCompression = value ?? false;
                        });
                      },
                      activeColor: Colors.grey,
                    ),
                    Text('Enable Compression'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(color: Colors.grey[900])),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            String server = _serverController.text;
            String username = _usernameController.text;
            String password = _passwordController.text;
            String database = _databaseController.text;
            String port = _portController.text;
            String backupPath = _backupPathController.text;

            onSave(server, username, password, database, port, backupPath);
            Navigator.of(context).pop();
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
