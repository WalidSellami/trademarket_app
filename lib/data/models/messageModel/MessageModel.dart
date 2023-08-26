class MessageModel {

  String? messageText;
  String? messageImage;
  String? senderId;
  String? receiverId;
  dynamic timesTamp;



  MessageModel({
    this.messageText,
    this.messageImage,
    this.senderId,
    this.receiverId,
    this.timesTamp,
});


  MessageModel.fromJson(Map<String , dynamic> json) {

    messageText = json['text'];
    messageImage = json['image'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    timesTamp = json['times_tamp'];

  }


  Map<String, dynamic> toMap() {

    return {
      'text' : messageText,
      'image': messageImage,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'times_tamp': timesTamp,
    };

  }


}