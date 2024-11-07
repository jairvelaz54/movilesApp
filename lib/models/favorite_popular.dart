class FavoritePopular {
  final int mediaId;

  FavoritePopular({required this.mediaId});

  Map<String, dynamic> toJson() => {
        "media_id": mediaId,
      };
}
