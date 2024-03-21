class MessageModel {
  String? image;
  String? msg;
  String? senderId;
  String? userImage;
  String? username;
  DateTime? createdAt;

  MessageModel({
    this.createdAt,
    this.username,
    this.userImage,
    this.image,
    this.msg,
    this.senderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': this.image,
      'msg': this.msg,
      'senderId': this.senderId,
      'userImage': this.userImage,
      'username': this.username,
      'createdAt': this.createdAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      image: map['image'] as String,
      msg: map['msg'] as String,
      senderId: map['senderId'] as String,
      userImage: map['userImage'] as String,
      username: map['username'] as String,
      createdAt: map['createdAt'] as DateTime,
    );
  }
}
