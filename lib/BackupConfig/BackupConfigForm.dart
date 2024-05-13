import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniges_backup_manager/BackupConfig/ConfigureDetailsPage.dart';
import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';
import 'dart:io';

class BackupConfigForm extends StatefulWidget {
  @override
  _BackupConfigFormState createState() => _BackupConfigFormState();
}

class _BackupConfigFormState extends State<BackupConfigForm> {
  bool configureDetails = false;
  bool addImport = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup Configuration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Backup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: configureDetails,
                  onChanged: (value) {
                    setState(() {
                      configureDetails = value!;
                      if (value == true) {
                        addImport = false;
                      }
                    });
                  },
                  activeColor: Colors.grey,
                ),
                Text(
                  'Configure Details',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (configureDetails) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigureDetailsPage(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  elevation: 3, backgroundColor: Colors.grey[900]),
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
    );
  }
}
