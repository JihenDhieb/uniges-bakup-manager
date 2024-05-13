import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uniges_backup_manager/BackupConfig/SourceDataSelection.dart';
import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';
import 'package:ftpconnect/ftpconnect.dart';

class DestinationSelectionPage extends StatefulWidget {
  final String name;
  final String description;
  final List<BackupInfo> backupHistory;
  DestinationSelectionPage({
    required this.name,
    required this.description,
    required this.backupHistory,
  });

  @override
  _DestinationSelectionPageState createState() =>
      _DestinationSelectionPageState();
}

class _DestinationSelectionPageState extends State<DestinationSelectionPage> {
  String? storageType;
  String? folderPath;
  String? ftpServer;
  String? ftpPort;
  String? ftpServerPath;
  String? ftpUsername;
  String? ftpPassword;
  String? sftpServer;
  String? sftpPort;
  String? sftpServerPath;
  bool fieldsFilled = false;
  bool connectionEstablished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup Configuration - Destination Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 24,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Description: ${widget.description}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: storageType,
                items: [
                  DropdownMenuItem<String>(
                    value: 'local',
                    child: Text('Local Storage'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'ftp',
                    child: Text('FTP'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'sftp',
                    child: Text('SFTP'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    storageType = value;
                    checkFieldsFilled();
                  });
                },
                hint: Text('Select Storage Type'),
              ),
              if (storageType == 'ftp') ...[
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    ftpServer = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'FTP Server'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ftpPort = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'FTP Port'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ftpServerPath = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'FTP Server Path'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ftpUsername = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'FTP Username'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    ftpPassword = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'FTP Password'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool isConnected = await testFTPConnection(
                      ftpServer!,
                      ftpUsername!,
                      ftpPassword!,
                      int.parse(ftpPort!),
                    );

                    setState(() {
                      connectionEstablished = isConnected;
                    });

                    if (!connectionEstablished) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Failed to Connect'),
                            content: Text(
                                'Unable to establish FTP connection. Please check your credentials and try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Test FTP Connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              if (storageType == 'sftp') ...[
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    sftpServer = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'SFTP Server'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    sftpPort = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'SFTP Port'),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    sftpServerPath = value;
                    checkFieldsFilled();
                  },
                  decoration: InputDecoration(labelText: 'SFTP Server Path'),
                ),
              ],
              if (storageType == 'local') ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    folderPath = await FilePicker.platform.getDirectoryPath();
                    if (folderPath != null) {
                      setState(() {
                        checkFieldsFilled();
                      });
                      // Handle selected folder path
                      print('Selected folder path: $folderPath');
                    } else {
                      // No folder path selected
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('No folder selected.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.grey[900]),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(
                    'Choose Folder',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SourceDataSelectionPage(
                        name: widget.name,
                        description: widget.description,
                        storageType: storageType!,
                        folderPath: folderPath,
                        ftpUsername: ftpUsername,
                        ftpPassword: ftpPassword,
                        ftpServer: ftpServer,
                        ftpPort: ftpPort,
                        ftpServerPath: ftpServerPath,
                        sftpServer: sftpServer,
                        sftpPort: sftpPort,
                        sftpServerPath: sftpServerPath,
                        backupHistory: widget.backupHistory,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkFieldsFilled() {
    if (storageType == 'local' && folderPath != null) {
      setState(() {
        fieldsFilled = true;
      });
    } else if (storageType == 'ftp' &&
        folderPath != null &&
        ftpServer != null &&
        ftpPort != null &&
        ftpServerPath != null &&
        ftpUsername != null &&
        ftpPassword != null) {
      setState(() {
        fieldsFilled = true;
      });
    } else if (storageType == 'sftp' &&
        folderPath != null &&
        sftpServer != null &&
        sftpPort != null &&
        sftpServerPath != null) {
      setState(() {
        fieldsFilled = true;
      });
    } else {
      setState(() {
        fieldsFilled = false;
      });
    }
  }

  Future<bool> testFTPConnection(
      String server, String username, String password, int port) async {
    try {
      FTPConnect ftpConnect =
          FTPConnect(server, user: username, pass: password, port: port);
      bool isConnected = await ftpConnect.connect();

      if (isConnected) {
        await ftpConnect.disconnect();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('FTP Connection Error: $e');
      return false;
    }
  }
}
