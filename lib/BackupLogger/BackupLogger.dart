import 'package:flutter/material.dart';
import 'package:uniges_backup_manager/BackupSchedule/BackupScheduleForm.dart';
import 'package:intl/intl.dart';

class BackupLogger extends StatelessWidget {
  final List<BackupInfo> backupList;

  BackupLogger({required this.backupList});

  @override
  Widget build(BuildContext context) {
    Map<String, List<BackupInfo>> groupedBackups = {};
    backupList.forEach((backup) {
      String formattedDate =
          DateFormat('dd/MM/yyyy').format(DateTime.parse(backup.dateTime));
      if (!groupedBackups.containsKey(formattedDate)) {
        groupedBackups[formattedDate] = [];
      }
      groupedBackups[formattedDate]!.add(backup);
    });

    // Sort dates in descending order
    List<String> dates = groupedBackups.keys.toList();
    dates.sort((a, b) => b.compareTo(a));

    String _getLocalizedDate(BuildContext context, String date) {
      DateTime dateTime = DateFormat('dd/MM/yyyy').parse(date);
      DateTime today = DateTime.now();
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      if (dateTime.year == today.year &&
          dateTime.month == today.month &&
          dateTime.day == today.day) {
        return 'Aujourd\'hui';
      } else if (dateTime.year == yesterday.year &&
          dateTime.month == yesterday.month &&
          dateTime.day == yesterday.day) {
        return 'Hier';
      } else {
        return DateFormat('dd/MM/yyyy').format(dateTime);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Backup History'),
      ),
      body: dates.isEmpty
          ? Center(
              child: Text('No backup history available.'),
            )
          : ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                final backups = groupedBackups[date]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _getLocalizedDate(context, date),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color.fromARGB(255, 109, 118, 125),
                        ),
                      ),
                    ),
                    Column(
                      children: backups.map((backup) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors
                                .grey[200], // Couleur de fond du conteneur
                            borderRadius:
                                BorderRadius.circular(10), // Bordures arrondies
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Couleur de l'ombre
                                spreadRadius: 3, // Rayon de diffusion
                                blurRadius: 7, // Rayon de flou
                                offset: Offset(0, 3), // Décalage de l'ombre
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(Icons.backup,
                                color: Colors.green), // Icône
                            title: Text(
                              'Name: ${backup.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Couleur du texte
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${backup.description}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  'Storage Type: ${backup.storageType}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 20, 20, 20)),
                                ),
                                Text(
                                  'Folder Path: ${backup.folderPath}',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 23, 23, 23)),
                                ),
                              ],
                            ),
                            trailing: Text(
                              'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(backup.dateTime))}',
                              style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
