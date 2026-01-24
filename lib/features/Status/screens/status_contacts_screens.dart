import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/Status/controller/status_controller.dart';
import 'package:whatsapp/models/status_model.dart';

class StatusContactsScreen extends ConsumerStatefulWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusContactsScreen> createState() =>
      _StatusContactsScreenState();
}

class _StatusContactsScreenState extends ConsumerState<StatusContactsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statusControllerProvider.notifier).getStatus(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ref.watch(statusControllerProvider);
    if (statuses.isEmpty) {
      return const Center(child: Text('No statuses available'));
    }
    return ListView.builder(
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        var statusData = statuses[index];
        return Column(
          children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(
                    statusData.username,
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      statusData.profilePic,
                    ),
                    radius: 30,
                  ),
                ),
              ),
            ),
            const Divider(color: dividerColor, indent: 85),
          ],
        );
      },
    );
  }
}
