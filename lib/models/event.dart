class EventData {
  String? id;
  final String title;
  final String description;
  final String description1;
  final String time;
  final DateTime date;
  final String venue;
  final DateTime from;
  final DateTime to;
  final String username;
  String? location;
  String? createdBy;

  EventData(
      {this.id,
      required this.title,
      required this.description,
      required this.description1,
      required this.time,
      required this.date,
      required this.venue,
      required this.from,
      required this.to,
      required this.username,
      this.location,
      this.createdBy});
  factory EventData.fromMap(map) {
    return EventData(
        id: map['id'],
        createdBy: map['createdBy'],
        title: map['title'],
        description: map['description'],
        description1: map['description1'],
        time: map['time'],
        date: map['date'].toDate(),
        venue: map['venue'],
        from: map['from'].toDate(),
        to: map['to'].toDate(),
        location: map['location'],
        username: map['username']);
  }

  Map<String, dynamic> toMap() {
    return {
      'createdBy': createdBy,
      'title': title,
      'description': description,
      'description1': description1,
      'time': time,
      'date': date,
      'venue': venue,
      'from': from,
      'to': to,
      'username': username,
      'location': location
    };
  }
}
