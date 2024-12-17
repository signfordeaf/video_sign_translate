import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_sign_translate/enum/sign_language_dimension.dart';
import 'package:video_sign_translate/enum/sign_language_position.dart';
import 'package:video_sign_translate/view/videosigntranslate_video.dart';

/// Enum for the position of the sign language

class VideoSignController {
  SignLanguagePosition signLanguagePosition = SignLanguagePosition.bottomLeft;

  SignLanguageDimension selectedDimension = SignLanguageDimension.small;

  Offset _signVideoPosition = Offset.zero;

  Offset get signVideoPosition => _signVideoPosition;

  bool initializeSign = true;

  bool isVisible = true;

  AnimatedBuilder routePageBuilder(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, VideoSignController controller,
      {required ImageProvider image}) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return StatefulBuilder(builder: (context, fullScreenSetter) {
          return Stack(
            children: [
              if (initializeSign)
                signLanguagePositionUpdate(
                  _buildFullScreenSignVideoBody(fullScreenSetter, controller, context, image: image),
                  controller.signLanguagePosition,
                ),
            ],
          );
        });
      },
    );
  }

  GestureDetector _buildFullScreenSignVideoBody(
      StateSetter fullScreenSetter, VideoSignController controller, BuildContext context,
      {required ImageProvider image}) {
    return GestureDetector(
      onTap: () {
        fullScreenSetter(() {
          controller.updateDimension();
        });
      },
      onPanUpdate: (details) {
        controller.updateVideoPosition(
            context: context, details: details, setState: fullScreenSetter, fullScreen: true);
      },
      child: VideoSign(
        imageProvider: image,
        signLanguageDimension: controller.getDimension(),
      ),
    );
  }

  Widget signLanguagePositionUpdate(Widget child, SignLanguagePosition position) {
    switch (position) {
      case SignLanguagePosition.topLeft:
        return Positioned(top: signVideoPosition.dy, left: signVideoPosition.dx, child: child);
      case SignLanguagePosition.topRight:
        return Positioned(top: signVideoPosition.dy, right: signVideoPosition.dx, child: child);
      case SignLanguagePosition.bottomLeft:
        return Positioned(bottom: signVideoPosition.dy, left: signVideoPosition.dx, child: child);
      case SignLanguagePosition.bottomRight:
        return Positioned(bottom: signVideoPosition.dy, right: signVideoPosition.dx, child: child);
    }
  }

  void updateDimension() {
    if (selectedDimension == SignLanguageDimension.small) {
      selectedDimension = SignLanguageDimension.large;
    } else {
      selectedDimension = SignLanguageDimension.small;
    }
  }

  void updateVideoPosition({
    required BuildContext context,
    required DragUpdateDetails details,
    required StateSetter setState,
    bool fullScreen = false,
  }) {
    double newX = _signVideoPosition.dx + details.delta.dx;
    double newY = _signVideoPosition.dy - details.delta.dy;

    setState(() {
      if (newX >= 0 && newX <= MediaQuery.of(context).size.width - (getDimension() - 50)) {
        _signVideoPosition = Offset(newX, _signVideoPosition.dy);
        if (kDebugMode) {
          print(MediaQuery.of(context).size.width);
        }
      }
      if (fullScreen) {
        if (newY >= 0 && newY <= MediaQuery.of(context).size.height - (getDimension() - 50)) {
          _signVideoPosition = Offset(_signVideoPosition.dx, newY);
        }
      } else {
        if (newY >= 0 && newY <= 300 - (getDimension() - 50)) {
          _signVideoPosition = Offset(_signVideoPosition.dx, newY);
        }
      }
    });
  }

  double getDimension() {
    switch (selectedDimension) {
      case SignLanguageDimension.small:
        return 150;
      case SignLanguageDimension.medium:
        return 200;
      case SignLanguageDimension.large:
        return 250;
    }
  }
}
