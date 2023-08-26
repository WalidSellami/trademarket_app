class DataModel {

  Data? data;

  DataModel.fromJson(Map<String , dynamic> json) {
    data = (json['data'] != null) ? Data.fromJson(json['data']) : null;
  }

}


class Data {

  String? title;
  String? message;

  Data.fromJson(Map<String , dynamic> json) {

    title = json['title'];
    message = json['message'];

  }

}