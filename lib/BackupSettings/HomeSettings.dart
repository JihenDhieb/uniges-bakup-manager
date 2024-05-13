import 'package:flutter/material.dart';
import 'package:uniges_backup_manager/BackupSettings/LoginPage.dart';
import 'package:uniges_backup_manager/BackupSettings/Signup.dart';

class HomeSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'If you want to secure your backups, please sign up.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(),
                  ),
                );
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
