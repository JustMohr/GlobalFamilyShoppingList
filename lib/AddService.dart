import 'dart:io';

class AdService{

  static String get bannerAdUnitId =>
    (Platform.isAndroid) ?
    'ca-app-pub-3940256099942544/6300978111' : //Android
    'ca-app-pub-3940256099942544/2934735716'; //ios

  /*static String get interstitialAdUnitId => --> test IDs
      (Platform.isAndroid) ?
      'ca-app-pub-3940256099942544/1033173712' : //Android
      'ca-app-pub-3940256099942544/4411468910'; //ios*/
}