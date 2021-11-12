class PostModel {
  PostModel({
    required this.id,
    required this.owner,
    required this.content,
    required this.background,
    required this.topics,
    required this.options,
  });

  String? id;
  String? owner;
  PostContent? content;
  PostBackground? background;
  List<String?>? topics;
  List<String?>? options;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        owner: json["owner"],
        content: PostContent.fromJson(json["content"]),
        background: PostBackground.fromJson(json["background"]),
        topics: List<String>.from(json["topics"].map((x) => x)),
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner": owner,
        "content": content?.toJson(),
        "background": background?.toJson(),
        "topics": topics != null ? List<String>.from((topics!).map((x) => x)) : null,
        "options": options != null ? List<String>.from(options!.map((x) => x)) : null,
      };
}

class PostContent {
  PostContent({
    required this.value,
    required this.align,
    required this.color,
    required this.size,
  });

  String? value;
  String? align;
  String? color;
  int? size;

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        value: json["value"],
        align: json["align"],
        color: json["color"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "align": align,
        "color": color,
        "size": size,
      };
}

class PostBackground {
  PostBackground({
    required this.image,
    required this.color,
  });

  String? image;
  String? color;

  factory PostBackground.fromJson(Map<String, dynamic> json) => PostBackground(
        image: json["image"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "color": color,
      };
}
