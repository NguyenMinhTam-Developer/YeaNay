class VoteModel {
  VoteModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.value,
  });

  String? id;
  String? postId;
  String? userId;
  String? value;

  factory VoteModel.fromJson(Map<String, dynamic> json) => VoteModel(
        id: json["id"],
        postId: json["post_id"],
        userId: json["user_id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "value": value,
      };
}
