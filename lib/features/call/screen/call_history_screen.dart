import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/models/call.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.watch(callControllerProvider).callRepository.getCallHistory(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text(
              'No call history yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        final calls =
            snapshot.data.docs.map((doc) => Call.fromMap(doc.data())).toList();
        return ListView.builder(
          itemCount: calls.length,
          itemBuilder: (context, index) {
            final call = calls[index];
            final isOutgoing = call.hasDialled;
            final contactName = call.receiverName;
            final contactPic = call.receiverPic;
            final time = DateFormat('HH:mm').format(call.timestamp);
            final date = DateFormat('dd/MM/yyyy').format(call.timestamp);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(contactPic),
                radius: 25,
              ),
              title: Text(
                contactName,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Row(
                children: [
                  Icon(
                    isOutgoing ? Icons.call_made : Icons.call_received,
                    color: isOutgoing ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$time, $date',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () {},
              ),
            );
          },
        );
      },
    );
  }
}
