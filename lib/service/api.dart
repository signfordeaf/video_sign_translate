import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_sign_translate/data/sign_video_data.dart';
import 'package:video_sign_translate/model/sign_content_model.dart';
import 'package:video_sign_translate/video_sign_translate.dart';

class ApiServices {
  CancelToken _cancelToken = CancelToken();

  var dio = Dio(
    BaseOptions(
      baseUrl: 'https://pl.weaccess.ai',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> uploadVideo({String? videoBundleId, File? file}) async {
    var data = FormData.fromMap({
      'api_key': VideoSignTranslate().apiKey,
      'video_bundle_id': videoBundleId,
    });
    if (file != null) {
      data.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      ));
    }
    try {
      var response = await dio.post(
        '/mobile/api/video_sign_translate-upload/',
        data: data,
        cancelToken: _cancelToken,
      );
      if (response.statusCode == 200) {
        final item = response.data;
        if (item != null) {
          kSignBox.put(
            item['file_path'],
            SignVideoData(
              videoPath: item['file_path'],
              videoUrl: item['file_url'],
              status: false,
            ),
          );
          createWeSign(
            videoBundleId: videoBundleId,
            videoPath: item['file_path'],
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Response> createWeSign({String? videoBundleId, String? videoPath}) async {
    var data = FormData.fromMap({
      'api_key': VideoSignTranslate().apiKey,
      'video_bundle_id': videoBundleId,
      'video_path': videoPath,
    });

    try {
      var repsonse = await dio.post(
        '/mobile/api/video_sign_translate-create/',
        data: data,
        cancelToken: _cancelToken,
      );
      return repsonse;
    } catch (e) {
      return Response(requestOptions: RequestOptions(path: ''));
    }
  }

  Future<void> getWeSign({String? videoBundleId, String? videoPath}) async {
    var parameters = {
      'api_key': VideoSignTranslate().apiKey,
      'video_bundle_id': videoBundleId,
      'video_path': videoPath,
    };
    try {
      // print('girdi parameters: $parameters');
      var response = await dio.get(
        '/mobile/api/video_sign_translate-get/',
        queryParameters: parameters,
        cancelToken: _cancelToken,
      );
      if (response.statusCode == 200) {
        SignContentModel scm = SignContentModel.fromJson(response.data);
        kSignBox.put(videoPath, SignVideoData(videoPath: videoPath ?? ''));
        final videoData = kSignBox.get(videoPath);
        if (scm.data != null && videoData != null) {
          kSignBox.put(
            videoPath,
            videoData.copyWith(
              contentData: (scm.data ?? [])
                  .map((item) => SignContentData(
                        content: item.s,
                        endTime: item.et,
                        q: item.q,
                        startTime: item.st,
                        videoDuration: item.vd,
                        videoUrl: item.vu,
                      ))
                  .toList(),
            ),
          );
          downloadGifImage(sc: scm.data!, videoPath: videoPath ?? '');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception response');
        print('error: $e');
      }
    }
  }

  Future<void> downloadGifImage({required List<SignContent> sc, required String videoPath}) async {
    final directory = await getTemporaryDirectory();
    var videoData = kSignBox.get(videoPath);
    for (var i = 0; i < sc.length; i++) {
      final item = sc[i];
      final filePath = '${directory.path}/$kGifFolderDirectory/${sc[i].vu}';
      try {
        final res = await dio.download(
          item.vu ?? '',
          filePath,
          onReceiveProgress: (count, total) {
            //  print('videoUrlQuery[${i + 1}] filepath urll:: count: $count, total: $total');
          },
          cancelToken: _cancelToken,
        );
        if (res.statusCode == 200) {
          if (videoData != null) {
            videoData = videoData.copyWith(
                contentData: videoData.contentData
                    ?.map((e) {
                      if (e.videoUrl == item.vu) {
                        return e.copyWith(fileGifPath: filePath);
                      }
                      return e;
                    })
                    .whereType<SignContentData>()
                    .toList());
            kSignBox.put(videoPath, videoData!);
          }
          if (kDebugMode) {
            print('filepath urll::: ${videoData?.contentData?.firstWhere(
              (element) {
                return element.videoUrl == item.vu;
              },
            ).fileGifPath}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  void cancelRequest() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
  }
}
