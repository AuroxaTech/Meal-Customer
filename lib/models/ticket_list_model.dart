class Ticket {
  final int id;
  final String title;
  final String orderNumber;
  final List<Message> messages;
  final bool isClosed;

  Ticket({
    required this.id,
    required this.title,
    required this.orderNumber,
    required this.messages,
    required this.isClosed,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),  // Ensure 'id' is an int
      title: json['title'] ?? 'No Title',
      orderNumber: json['order']['code'] ?? 'No Order Number',
      messages: (json['messages'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      isClosed: json['is_closed'] ?? false,
    );
  }
}






class Message {
  final int id;
  final int ticketId;
  final String message;
  final bool isUser;
  final bool isAdmin;
  final bool isVendor;
  final DateTime createdAt;
  final String? photo;

  Message({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.isUser,
    required this.isAdmin,
    required this.isVendor,
    required this.createdAt,
    this.photo,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),  // Ensure 'id' is an int
      ticketId: json['ticket_id'] is int ? json['ticket_id'] : int.parse(json['ticket_id']),
      message: json['message'] ?? '',
      isUser: json['is_user'] == 1,
      isAdmin: json['is_admin'] == 1,
      isVendor: json['is_vendor'] == 1,
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      photo: json['photo']?.toString(),
    );
  }
}
