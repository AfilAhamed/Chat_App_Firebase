class MessageModel {
  String toId;
  String msg;
  String readTime;
  Type type;
  String fromId;
  String sendTime;

  MessageModel({
    required this.toId,
    required this.msg,
    required this.readTime,
    required this.type,
    required this.fromId,
    required this.sendTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        toId: json["toId"],
        msg: json["msg"],
        readTime: json["readTime"],
        type: json["type"] == Type.image.name ? Type.image : Type.text,
        fromId: json["fromId"],
        sendTime: json["sendTime"],
      );

  Map<String, dynamic> toJson() => {
        "toId": toId,
        "msg": msg,
        "readTime": readTime,
        "type": type.name,
        "fromId": fromId,
        "sendTime": sendTime,
      };
}

enum Type { text, image }
