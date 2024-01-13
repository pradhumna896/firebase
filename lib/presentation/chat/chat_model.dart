class ChatModel {
  final String name;
  final String message;
  final String time;

  ChatModel({
    required this.name,
    required this.message,
    required this.time,
  });
  // factory
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['name'],
      message: json['message'],
      time: json['time'],
    );
  }
}
