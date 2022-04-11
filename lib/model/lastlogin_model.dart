class LastloginModel {
  LastloginModel({
    required this.phonenumber,
    required this.lastlogin,
    required this.userip,
    required this.location,
    required this.qrnumber,
    required this.qrimage,
  });
  late final String phonenumber;
  late final String lastlogin;
  late final String userip;
  late final String location;
  late final String qrnumber;
  late final String qrimage;

  LastloginModel.fromJson(Map<String, dynamic> json) {
    phonenumber = json['phonenumber'] ?? "";
    lastlogin = json['lastlogin'] ?? "";
    userip = json['userip'] ?? " - ";
    location = json['location'] ?? " - ";
    qrnumber = json['qrnumber'] ?? "";
    qrimage = json['qrimage'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phonenumber'] = phonenumber;
    _data['lastlogin'] = lastlogin;
    _data['userip'] = userip;
    _data['location'] = location;
    _data['qrnumber'] = qrnumber;
    _data['qrimage'] = qrimage;
    return _data;
  }
}
