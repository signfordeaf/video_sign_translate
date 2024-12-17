// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_sign_translate/data/sign_video_data.dart';
import 'package:video_sign_translate/enum/sign_language_dimension.dart';
import 'package:video_sign_translate/enum/sign_language_position.dart';
import 'package:video_sign_translate/service/api.dart';
import 'package:video_sign_translate/view/videosigntranslate_video.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sign_translate/video_sign_translate.dart';

class VideoSignPlayer extends StatefulWidget {
  final VideoSignController controller;
  final bool initializeSign;
  final SignLanguageDimension signLanguageDimension;
  final SignLanguagePosition signLanguagePosition;
  final VideoPlayerController? videoPlayerController;
  final Widget child;

  const VideoSignPlayer({
    super.key,
    required this.controller,
    this.initializeSign = true,
    required this.videoPlayerController,
    this.signLanguageDimension = SignLanguageDimension.small,
    this.signLanguagePosition = SignLanguagePosition.bottomLeft,
    required this.child,
  });

  @override
  State<VideoSignPlayer> createState() => _VideoSignPlayerState();
}

class _VideoSignPlayerState extends State<VideoSignPlayer> {
  ImageProvider? image; // image null yapıldı
  int currentGifIndex = -1;
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    widget.controller.initializeSign = widget.initializeSign;
    _apiServices.getWeSign(
      videoBundleId: 'example.weaccess_example_project',
      videoPath: '/home/akilliceviribilisim/WeAccessApp/media/uploads/a87e5a5ba0e041c6a05248d14d82f113.mp4',
    );
    widget.videoPlayerController?.addListener(_videoPlayerListener); // Dinleyici ekleyelim
  }

  void init() {
    widget.controller.selectedDimension = widget.signLanguageDimension;
  }

  void initWeSign() {
    switch (widget.videoPlayerController?.dataSourceType) {
      case DataSourceType.asset:
        _apiServices.uploadVideo();
        break;
      case DataSourceType.file:
        _apiServices.uploadVideo(
          file: File(widget.videoPlayerController?.dataSource ?? ''),
        );
        break;
      case DataSourceType.network:
        widget.controller.initializeSign = true;
        break;
      case DataSourceType.contentUri:
        break;
      default:
        widget.controller.initializeSign = false;
    }
  }

  void _getGifImage(List<SignContentData>? scd) {
    final currentPosition = widget.videoPlayerController?.value.position;
    if (scd != null) {
      // Gecikmeleri engellemek için bir önceki q'yu kontrol et
      for (var item in scd) {
        final startTimeMs = ((item.startTime ?? 0) * 1000).toInt();
        final endTimeMs = ((item.endTime ?? 0) * 1000).toInt();

        if (item.q != null &&
            item.q! > currentGifIndex &&
            currentPosition!.inMilliseconds >= startTimeMs &&
            currentPosition.inMilliseconds <= endTimeMs) {
          // Yeni gif gösterme, mevcut q'yu güncelle
          currentGifIndex = item.q!;

          if (item.fileGifPath != null && item.fileGifPath!.isNotEmpty) {
            // Eğer yerel gif dosyası varsa
            image = FileImage(File(item.fileGifPath!));
          } else if (item.videoUrl != null && item.videoUrl!.isNotEmpty) {
            // Eğer video URL'si varsa
            image = NetworkImage(item.videoUrl!);
          }

          setState(() {}); // Yeni görseli ekranda göster
          break; // Döngüden çık
        }
      }
    }
  }

  // Video player zamanını dinleyen fonksiyon
  void _videoPlayerListener() {
    final currentPosition = widget.videoPlayerController?.value.position;
    final duration = widget.videoPlayerController?.value.duration;

    if (currentPosition != null && duration != null) {
      // Eğer video sonuna gelindiyse
      if (currentPosition == duration) {
        image = null; // Son q'da, görüntüyü null yapıyoruz
        setState(() {}); // Değişiklikleri uygula
      }
    }
  }

  // Video başında zamanlayıcıyı kontrol et
  void _checkVideoStatus(List<SignContentData>? scd) {
    final currentPosition = widget.videoPlayerController?.value.position;

    if (scd != null && currentPosition != null) {
      bool imageSet = false;

      // Gecikmeleri engellemek için son kontrol
      for (var item in scd) {
        // print(item.q);
        final startTimeMs = ((item.startTime ?? 0) * 1000).toInt();
        final endTimeMs = ((item.endTime ?? 0) * 1000).toInt();

        if (currentPosition.inMilliseconds >= startTimeMs && currentPosition.inMilliseconds <= endTimeMs) {
          if (item.q != null) {
            if (item.videoUrl != null && item.videoUrl!.isNotEmpty) {
              image = NetworkImage(item.videoUrl!);
            } else if (item.fileGifPath != null && item.fileGifPath!.isNotEmpty) {
              image = FileImage(File(item.fileGifPath!));
            }
            setState(() {});
            imageSet = true;
            break;
          }
        }
      }

      if (!imageSet) {
        image = null;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: kSignBoxListenable,
      builder: (context, box, child) {
        return Stack(
          children: [
            widget.child,
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: () => setState(() {
                  widget.controller.isVisible = !widget.controller.isVisible;
                  widget.videoPlayerController?.addListener(() {
                    _getGifImage(box.values.first.contentData ?? List<SignContentData>.empty());
                  });
                }),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/engelsizceviri.png',
                      package: 'video_sign_translate',
                    ),
                    const SizedBox(height: 2),
                    Visibility(
                      visible: widget.controller.isVisible,
                      child: Container(
                        width: 25,
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.initializeSign && widget.controller.isVisible)
              widget.controller.signLanguagePositionUpdate(
                _buildSignVideoBody(context),
                widget.signLanguagePosition,
              ),
          ],
        );
      },
    );
  }

  GestureDetector _buildSignVideoBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.controller.updateDimension();
        });
      },
      onPanUpdate: (details) {
        widget.controller.updateVideoPosition(context: context, details: details, setState: setState);
      },
      child: Visibility(
        visible: widget.controller.isVisible,
        child: VideoSign(
          imageProvider: image, // Eğer image null ise WeSignVideo widget'ı görünmez olur
          signLanguageDimension: widget.controller.getDimension(),
        ),
      ),
    );
  }
}
