class Conversation {
  final String title;
  final String preview;
  final String imagePath;
  final DateTime date;
  final String? sharedBy;

  Conversation({
    required this.title,
    required this.preview,
    required this.imagePath,
    required this.date,
    this.sharedBy,
  });
}
