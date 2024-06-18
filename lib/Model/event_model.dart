class Event {
  final String id;
  final String title;
  final String description;
  final DateTime start;
  final DateTime end;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.start,
    required this.end,
  });

  @override
  String toString() =>
      'Event(id: $id, title: $title, start: $start, end: $end)';
}
