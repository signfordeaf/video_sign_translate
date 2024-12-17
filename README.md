# WeAccess Video Sign Translate

## 🛠️ Install
```dart
flutter pub add video_sign_translate
```
###  📄main.dart
```dart
void main() async {
  await VideoSignTranslate.init(apiKey: 'YOUR-API-KEY');
  runApp(const MyApp());
}
```


## 🧑🏻💻 Usage

### 🚀 Widget and Controller

```dart 
VideoSignController _signController;

VideoSignPlayer(
   controller: _signController,
   videoPlayerController: _controller,
   child: AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
      ),
),
```
###  📄example.dart
   Wrap the video player with VideoSignPlayer
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  late VideoSignController _signController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    _signController = VideoSignController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            VideoSignPlayer(
              controller: _signController,
              videoPlayerController: _controller,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
