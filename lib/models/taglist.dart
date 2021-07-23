class VideosTags {
  final List<String> tags;

  VideosTags({this.tags});

  factory VideosTags.fromJson(Map<String, dynamic> parsedJson) {
    var tagsFromJson = parsedJson['tags'];
    List<String> tagsList = tagsFromJson.cast<String>();

    return new VideosTags(
      tags: tagsList,
    );
  }
}
