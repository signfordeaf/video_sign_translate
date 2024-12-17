import 'package:hive/hive.dart';

part 'sign_video_data.g.dart';

@HiveType(typeId: 108)
class SignVideoData {
  @HiveField(0)
  String? videoUrl;
  @HiveField(1)
  String videoPath;
  @HiveField(2)
  bool? status;
  @HiveField(3)
  List<SignContentData>? contentData;

  SignVideoData({
    this.videoUrl,
    required this.videoPath,
    this.status,
    this.contentData,
  });

  copyWith({
    String? videoUrl,
    String? videoPath,
    bool? status,
    List<SignContentData>? contentData,
  }) {
    return SignVideoData(
      videoPath: videoPath ?? this.videoPath,
      videoUrl: videoUrl ?? this.videoUrl,
      status: status ?? this.status,
      contentData: contentData ?? this.contentData,
    );
  }
}

@HiveType(typeId: 109)
class SignContentData {
  @HiveField(0)
  double? startTime;
  @HiveField(1)
  double? endTime;
  @HiveField(2)
  String? videoUrl;
  @HiveField(3)
  double? videoDuration;
  @HiveField(4)
  String? content;
  @HiveField(5)
  int? q;
  @HiveField(6)
  String? fileGifPath;

  SignContentData({
    this.content,
    this.startTime,
    this.endTime,
    this.videoUrl,
    this.videoDuration,
    this.q,
    this.fileGifPath,
  });

  copyWith({
    double? startTime,
    double? endTime,
    String? videoUrl,
    double? videoDuration,
    String? content,
    int? q,
    String? fileGifPath,
  }) {
    return SignContentData(
      content: content ?? this.content,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      videoUrl: videoUrl ?? this.videoUrl,
      videoDuration: videoDuration ?? this.videoDuration,
      q: q ?? this.q,
      fileGifPath: fileGifPath ?? this.fileGifPath,
    );
  }
}
