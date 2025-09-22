class Issue {
  String id;
  String title;
  String description;
  String imageUrl;
  double latitude;
  double longitude;
  String status; // e.g., "Pending", "Resolved"

  Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.status = "Pending",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'] ?? "Pending",
    );
  }
}
