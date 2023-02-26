class AppointmentListParser {
  String appointmentID;
  String userId;
  String appointmentType;
  String myEmail;
  String title;
  String meetingLink;
  String meetingPlace;
  String mapLink;
  String description;
  String confirmAppointmentDate;
  String confirmAppointmentEnddate;
  String confirmSlotStartTime;
  String confirmSlotEndTime;
  String createdAt;
  String status;
  String hostOffset;
  String appointmentDuration;

  AppointmentListParser(
      {this.appointmentID,
        this.userId,
        this.appointmentType,
        this.myEmail,
        this.title,
        this.meetingLink,
        this.meetingPlace,
        this.mapLink,
        this.description,
        this.confirmAppointmentDate,
        this.confirmAppointmentEnddate,
        this.confirmSlotStartTime,
        this.confirmSlotEndTime,
        this.createdAt,
        this.status,
        this.hostOffset,
        this.appointmentDuration});

  AppointmentListParser.fromJson(Map<String, dynamic> json) {
    appointmentID = json['appointmentID'];
    userId = json['user_id'];
    appointmentType = json['appointmentType'];
    myEmail = json['my_email'];
    title = json['title'];
    meetingLink = json['meeting_link'];
    meetingPlace = json['meeting_place'];
    mapLink = json['map_link'];
    description = json['description'];
    confirmAppointmentDate = json['confirm_appointment_date'];
    confirmAppointmentEnddate = json['confirm_appointment_enddate'];
    confirmSlotStartTime = json['confirm_slot_start_time'];
    confirmSlotEndTime = json['confirm_slot_end_time'];
    createdAt = json['created_at'];
    status = json['status'];
    hostOffset = json['host_offset'];
    appointmentDuration = json['appointment_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentID'] = this.appointmentID;
    data['user_id'] = this.userId;
    data['appointmentType'] = this.appointmentType;
    data['my_email'] = this.myEmail;
    data['title'] = this.title;
    data['meeting_link'] = this.meetingLink;
    data['meeting_place'] = this.meetingPlace;
    data['map_link'] = this.mapLink;
    data['description'] = this.description;
    data['confirm_appointment_date'] = this.confirmAppointmentDate;
    data['confirm_appointment_enddate'] = this.confirmAppointmentEnddate;
    data['confirm_slot_start_time'] = this.confirmSlotStartTime;
    data['confirm_slot_end_time'] = this.confirmSlotEndTime;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    data['host_offset'] = this.hostOffset;
    data['appointment_duration'] = this.appointmentDuration;
    return data;
  }
}
