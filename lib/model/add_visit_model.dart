class AddVisitModel {
  String? name;
  String? owner;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? visitTo;
  String? visitor;
  String? visitorsName;
  String? time;
  String? date;
  double? duration;
  String? attachmentUrl;
  String? description;
  String? visitInLatitude;
  String? visitInAddress;
  String? visitInLongitude;
  String? visitInTime;
  String? visitOutLongitude;
  String? visitOutLatitude;
  String? visitOutAddress;
  String? visitOutTime;
  String? employee;
  String? user;
  String? status;

  AddVisitModel(
      {this.name,
      this.owner,
      this.modifiedBy,
      this.docstatus,
      this.idx,
      this.visitTo,
      this.visitor,
      this.visitorsName,
      this.time,
      this.date,
      this.duration,
      this.attachmentUrl,
      this.description,
      this.visitInLatitude,
      this.visitInAddress,
      this.visitInLongitude,
      this.visitInTime,
      this.visitOutLongitude,
      this.visitOutLatitude,
      this.visitOutAddress,
      this.visitOutTime,
      this.employee,
      this.user,
        this.status,});

  AddVisitModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    modifiedBy = json['modified_by'];
    docstatus = toInt(json['docstatus']);
    idx = toInt(json['idx']);
    visitTo = json['visit_to'];
    visitor = json['visitor'];
    visitorsName = json['visitors_name'];
    time = json['time'];
    date = json['date'];
    duration = toDouble(json['duration']);
    attachmentUrl = json['attachment_url'];
    description = json['description'];
    visitInLatitude = json['visit_in_latitude'];
    visitInAddress = json['visit_in_address'];
    visitInLongitude = json['visit_in_longitude'];
    visitInTime = json['visit_in_time'];
    visitOutLongitude = json['visit_out_longitude'];
    visitOutLatitude = json['visit_out_latitude'];
    visitOutAddress = json['visit_out_address'];
    visitOutTime = json['visit_out_time'];
    employee = json['employee'];
    user = json['user'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['modified_by'] = this.modifiedBy;
    data['docstatus'] = this.docstatus;
    data['idx'] = this.idx;
    data['visit_to'] = this.visitTo;
    data['visitor'] = this.visitor;
    data['visitors_name'] = this.visitorsName;
    data['time'] = this.time;
    data['date'] = this.date;
    data['duration'] = this.duration;
    data['attachment_url'] = this.attachmentUrl;
    data['description'] = this.description;
    data['visit_in_latitude'] = this.visitInLatitude;
    data['visit_in_address'] = this.visitInAddress;
    data['visit_in_longitude'] = this.visitInLongitude;
    data['visit_in_time'] = this.visitInTime;
    data['visit_out_longitude'] = this.visitOutLongitude;
    data['visit_out_latitude'] = this.visitOutLatitude;
    data['visit_out_address'] = this.visitOutAddress;
    data['visit_out_time'] = this.visitOutTime;
    data['employee'] = this.employee;
    data['user'] = this.user;
    data['status'] = status;
    return data;
  }
}
double? toDouble(dynamic value) {
  if (value == null) return null;
  return (value as num).toDouble();
}
int? toInt(dynamic value) {
  if (value == null) return null;
  return (value as num).toInt();
}
