class VideoModel {
  final String id;
  final String videoUrl;
  final String title;
  List<String> likedBy;
  List<String> savedBy;

  VideoModel({
    required this.id,
    required this.videoUrl,
    required this.title,
    required this.likedBy,
    required this.savedBy,
  });

  factory VideoModel.fromMap(String id, Map<String, dynamic> data) {
    return VideoModel(
      id: id,
      videoUrl: data['videoUrl'],
      title: data['title'],
      likedBy: List<String>.from(data['likedBy'] ?? []),
      savedBy: List<String>.from(data['savedBy'] ?? []),
    );
  }
}
