class SlotsByDateDayNAMEListParser {
  String slotID;
  String appointmentID;
  String dayname;
  String slotStartTime;
  String slotEndTime;
  String status;

  SlotsByDateDayNAMEListParser(
      {this.slotID,
        this.appointmentID,
        this.dayname,
        this.slotStartTime,
        this.slotEndTime,
        this.status});

  SlotsByDateDayNAMEListParser.fromJson(Map<String, dynamic> json) {
    slotID = json['slotID'];
    appointmentID = json['appointmentID'];
    dayname = json['dayname'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slotID'] = this.slotID;
    data['appointmentID'] = this.appointmentID;
    data['dayname'] = this.dayname;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['status'] = this.status;
    return data;
  }
}
