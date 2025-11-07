import 'package:flutter/material.dart';
import 'package:enquire/Screen/notification_flow/notification_model.dart';
import 'package:enquire/Screen/notification_flow/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService service;
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  NotificationProvider({required this.service});

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notifications = await service.fetchNotifications();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void add(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
