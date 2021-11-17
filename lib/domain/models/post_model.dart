import 'package:yea_nay/domain/models/vote_model.dart';

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
  List<VoteModel?>? votes;

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        owner: json["owner"],
        content: json["content"] != null ? PostContent.fromJson(json["content"]) : null,
        background: json["background"] != null ? PostBackground.fromJson(json["background"]) : null,
        topics: json["topics"] != null ? List<String>.from(json["topics"].map((x) => x)) : null,
        options: json["options"] != null ? List<String>.from(json["options"].map((x) => x)) : null,
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
    required this.data,
    required this.align,
    required this.color,
    required this.size,
  });

  String? data;
  String? align;
  String? color;
  int? size;

  factory PostContent.fromJson(Map<String, dynamic> json) => PostContent(
        data: json["data"],
        align: json["align"],
        color: json["color"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
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
