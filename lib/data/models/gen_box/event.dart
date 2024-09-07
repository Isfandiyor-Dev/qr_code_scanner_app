class Event {
  String eventName;
  DateTime? startDateAndTime;
  DateTime? endDateAndTime;
  String? eventLocation;
  String? description;

  Event({
    required this.eventName,
    required this.startDateAndTime,
    required this.endDateAndTime,
    required this.eventLocation,
    required this.description,
  });
}
