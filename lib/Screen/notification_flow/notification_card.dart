import 'package:flutter/material.dart';
import 'package:enquire/Screen/notification_flow/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notificationModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = notificationModel.status == 'approved';
    final bg = isApproved ? Colors.green[50] : Colors.red[50];
    final icon = isApproved
        ? Icons.check_circle
        : (notificationModel.status == 'rejected' ? Icons.cancel : Icons.info);

    return Card(
      color: bg,
      margin: const EdgeInsets.all(15),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black54, size: 32),
      ),
    );
  }
}
