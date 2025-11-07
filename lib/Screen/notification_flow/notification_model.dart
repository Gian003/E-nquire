class NotificationModel {
  final int requestId;
  final int userId;
  final String type;
  final String message;
  final Map<String, dynamic>? data;
  final String status;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.requestId,
    required this.userId,
    required this.type,
    required this.message,
    this.data,
    required this.status,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      requestId: json['requestId'],
      userId: json['userId'],
      type: json['type'] ?? 'info',
      message: json['message'],
      data: json['data'],
      status: json['status'] ?? 'pedning' ?? 'approved' ?? 'rejected',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
