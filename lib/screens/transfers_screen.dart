import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tekkers/Providers/transfer_provider.dart';
import 'package:tekkers/models/transfer.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  String timeAgo(String dateString) {
    try {
      final confirmedDate = DateTime.parse(dateString);
      final difference = DateTime.now().difference(confirmedDate);

      if (difference.inDays > 1) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 1) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfers'),
      ),
      body: Consumer<TransferProvider>(
        builder: (context, transferProvider, child) {
          if (transferProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (transferProvider.hasError) {
            return Center(child: Text(transferProvider.errorMessage));
          }

          if (transferProvider.transfers.isEmpty) {
            return const Center(child: Text('No transfers available'));
          }

          return ListView.builder(
            itemCount: transferProvider.transfers.length,
            itemBuilder: (context, index) {
              final Transfer transfer = transferProvider.transfers[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transfer.player} moves from ${transfer.fromTeam} to ${transfer.toTeam}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transfer type: ${transfer.transferType}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Confirmed: ${timeAgo(transfer.transferDate)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}