class Appointment {
  final String id;
  final String announcement_id;
  final String service;
  final String date_time;
  final String client_id;
  final String client_name;
  final String contractor_name;
  final String contractor_contact;
  final String contractor_id;
  final String details;
  Appointment(
      this.id,
      this.announcement_id,
      this.service,
      this.date_time,
      this.client_id,
      this.client_name,
      this.contractor_name,
      this.contractor_contact,
      this.contractor_id,
      [this.details = '']);
}
