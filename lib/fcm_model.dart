class FCMDataModel {
  String? badge;
  Alert? alert;
  // Null category;

  FCMDataModel({this.badge, this.alert});

  FCMDataModel.fromJson(Map<String, dynamic> json) {
    badge = json['badge'];
    alert = json['alert'] != null ? new Alert.fromJson(json['alert']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['badge'] = this.badge;
    if (this.alert != null) {
      data['alert'] = this.alert!.toJson();
    }
    return data;
  }
}

class Alert {
  String? body;
  String? title;

  Alert({this.body, this.title});

  Alert.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    return data;
  }
}
