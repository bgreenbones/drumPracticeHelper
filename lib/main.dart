import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rhythm_practice_helper/ad_helper.dart';
import 'package:rhythm_practice_helper/styles.dart';
import 'possible_stickings.dart';
import 'groupings.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BannerAd? _bannerAd;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() => {Wakelock.enable()});
    return MaterialApp(
        title: 'Drum Helper',
        home: Scaffold(
            appBar: AppBar(
              title: const Text("stickings"),
              backgroundColor: trimColor,
            ),
            body: FutureBuilder<void>(
                future: _initGoogleMobileAds(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  return DefaultTextStyle(
                      style: defaultText,
                      child: Container(
                          padding: elementPadding,
                          color: backgroundColor,
                          child: _bannerAd != null
                              ? Column(children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      width: _bannerAd!.size.width.toDouble(),
                                      height: _bannerAd!.size.height.toDouble(),
                                      child: AdWidget(ad: _bannerAd!),
                                    ),
                                  ),
                                  const PossibleStickings()
                                ])
                              : const PossibleStickings()));
                })));
  }
}
