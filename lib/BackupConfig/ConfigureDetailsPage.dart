import 'package:flutter/material.dart';
import 'package:uniges_backup_manager/BackupConfig/DestinationSauvgarde.dart';

class ConfigureDetailsPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup Configuration - General Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup Steps:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildStepBubble('1', 'General Settings',
                    'Set up general backup configurations.'),
                _buildStepBubble(
                    '2', 'Destination', 'Choose where to save your backups.'),
                _buildStepBubble(
                    '3', 'Source Data', 'Select the data to be backed up.'),
                _buildStepBubble('4', 'Backup Schedule',
                    'Set the schedule for automatic backups.'),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Please enter a name and description for your backup configuration :',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center, // Centrer le texte
                style: TextStyle(fontSize: 16), // Définir la taille de police
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none, // Supprimer la bordure du TextField
                  prefixIcon: Icon(Icons.title),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _descriptionController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationSelectionPage(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        backupHistory: [],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.grey[900],
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBubble(String number, String title, String subtitle) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
