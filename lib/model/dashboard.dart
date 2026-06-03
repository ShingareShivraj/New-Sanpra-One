class DashBoard {
  String? inTime;
  String? outTime;
  String? lastLogType;
  String? lastLogTime;
  LastLocation? lastLocation;
  List<SalesPerson>? salesPerson;
  String? role;
  bool? trackingEnabled;
  bool? isMeter;
  bool? isPhoto;
  bool? isLocation;
  List<String>? territorylist;
  String? empName;
  String? email;
  String? company;
  String? employeeImage;
  bool? isEmployee;
  MonthlySummary? monthlySummary;

  DashBoard(
      {this.inTime,
      this.outTime,
      this.lastLogType,
      this.lastLogTime,
      this.lastLocation,
      this.salesPerson,
      this.role,
      this.trackingEnabled,
        this.isMeter,
        this.isPhoto,
        this.isLocation,
      this.territorylist,
      this.empName,
      this.email,
      this.company,
      this.employeeImage,
      this.isEmployee,
      this.monthlySummary});

  DashBoard.fromJson(Map<String, dynamic> json) {
    inTime = json['in_time'];
    outTime = json['out_time'];
    lastLogType = json['last_log_type'];
    lastLogTime = json['last_log_time'];
    lastLocation = json['last_location'] != null
        ? new LastLocation.fromJson(json['last_location'])
        : null;
    if (json['sales_person'] != null) {
      salesPerson = <SalesPerson>[];
      json['sales_person'].forEach((v) {
        salesPerson!.add(new SalesPerson.fromJson(v));
      });
    }
    role = json['role'];
    trackingEnabled = json['tracking_enabled'];
    isMeter = json['is_meter'];
    isPhoto = json['is_photo'];
    isLocation = json['is_location'];
    territorylist = json['territorylist'].cast<String>();
    empName = json['emp_name'];
    email = json['email'];
    company = json['company'];
    employeeImage = json['employee_image'];
    isEmployee = json['is_employee'];
    monthlySummary = json['monthly_summary'] != null
        ? new MonthlySummary.fromJson(json['monthly_summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['in_time'] = this.inTime;
    data['out_time'] = this.outTime;
    data['last_log_type'] = this.lastLogType;
    data['last_log_time'] = this.lastLogTime;
    if (this.lastLocation != null) {
      data['last_location'] = this.lastLocation!.toJson();
    }
    if (this.salesPerson != null) {
      data['sales_person'] = this.salesPerson!.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
    data['tracking_enabled'] = this.trackingEnabled;
    data['is_meter'] = isMeter;
    data['is_photo'] = isPhoto;
    data['is_location'] = isLocation;
    data['territorylist'] = this.territorylist;
    data['emp_name'] = this.empName;
    data['email'] = this.email;
    data['company'] = this.company;
    data['employee_image'] = this.employeeImage;
    data['is_employee'] = this.isEmployee;
    if (this.monthlySummary != null) {
      data['monthly_summary'] = this.monthlySummary!.toJson();
    }
    return data;
  }
}

class LastLocation {
  String? latitude;
  String? longitude;
  String? datetime;

  LastLocation({this.latitude, this.longitude, this.datetime});

  LastLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['datetime'] = this.datetime;
    return data;
  }
}

class SalesPerson {
  String? employee;
  String? employeeName;
  String? date;
  int? visitCount;
  int? tourCount;
  int? day;

  SalesPerson(
      {this.employee,
      this.employeeName,
      this.date,
      this.visitCount,
      this.tourCount,
      this.day});

  SalesPerson.fromJson(Map<String, dynamic> json) {
    employee = json['employee'];
    employeeName = json['employee_name'];
    date = json['date'];
    visitCount = json['visit_count'];
    tourCount = json['tour_count'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee'] = this.employee;
    data['employee_name'] = this.employeeName;
    data['date'] = this.date;
    data['visit_count'] = this.visitCount;
    data['tour_count'] = this.tourCount;
    data['day'] = this.day;
    return data;
  }
}

class MonthlySummary {
  String? month;
  String? year;
  Visit? visit;
  Visit? attendance;
  Visit? leave;
  Visit? orders;
  Visit? leads;
  Visit? tours;

  MonthlySummary(
      {this.month,
      this.year,
      this.visit,
      this.attendance,
      this.leave,
      this.orders,
      this.tours,
      this.leads});

  MonthlySummary.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    year = json['year'];
    visit = json['visit'] != null ? new Visit.fromJson(json['visit']) : null;
    attendance = json['attendance'] != null
        ? new Visit.fromJson(json['attendance'])
        : null;
    leave = json['leave'] != null ? new Visit.fromJson(json['leave']) : null;
    orders = json['orders'] != null ? new Visit.fromJson(json['orders']) : null;
    tours = json['tours'] != null ? new Visit.fromJson(json['tours']) : null;
    leads = json['leads'] != null ? new Visit.fromJson(json['leads']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['year'] = this.year;
    if (this.visit != null) {
      data['visit'] = this.visit!.toJson();
    }
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    if (this.leave != null) {
      data['leave'] = this.leave!.toJson();
    }
    if (this.orders != null) {
      data['orders'] = this.orders!.toJson();
    }
    if (this.tours != null) {
      data['tours'] = this.tours!.toJson();
    }

    if (this.leads != null) {
      data['leads'] = this.leads!.toJson();
    }
    return data;
  }
}

class Visit {
  int? total;

  Visit({this.total});

  Visit.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}
