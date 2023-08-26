class UserModel {

  String? fullName;
  String? phone;
  String? address;
  String? uId;
  String? email;
  String? imageProfile;
  Map<String , dynamic>? senders;
  String? deviceToken;
  bool? isInfoComplete;

  UserModel({
    this.fullName,
    this.phone,
    this.address,
    this.uId,
    this.email,
    this.imageProfile,
    this.senders,
    this.deviceToken,
    this.isInfoComplete,
  });


  UserModel.fromJson(Map<String , dynamic> json) {

    fullName = json['full_name'];
    phone = json['phone'];
    address = json['address'];
    uId = json['uId'];
    email = json['email'];
    imageProfile = json['image_profile'];
    senders = json['senders'];
    deviceToken = json['device_token'];
    isInfoComplete = json['is_info_complete'];

  }



  Map<String , dynamic> toMap() {

    return {
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'uId': uId,
      'email': email,
      'image_profile': imageProfile,
      'senders': senders,
      'device_token': deviceToken,
      'is_info_complete': isInfoComplete,
    };

  }

}