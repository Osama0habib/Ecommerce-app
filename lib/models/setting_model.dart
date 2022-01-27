class SettingModel {
  bool? status;
  String? message;
  SettingData? data;


  SettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  SettingData.fromJson(json['data']) : null;
  }


}

class SettingData {
  String? about;
  String? terms;


  SettingData.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    terms = json['terms'];
  }


}
