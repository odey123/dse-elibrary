typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

class LoadingScreenController {
  final CloseLoadingScreen close;
  LoadingScreenController({
    required this.close,
  });
}
