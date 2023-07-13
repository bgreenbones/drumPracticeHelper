import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rhythm_practice_helper/ad_helper.dart';
import 'package:rhythm_practice_helper/reference_points.dart';
import 'package:rhythm_practice_helper/styles.dart';
import 'stickings_display.dart';
import 'stickings_display2.dart';
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
  String _currentConceptName = "stickings";
  Widget _currentConcept = StickingsDisplay2();
  final Map<String, Widget> _concepts = {
    "groupings tabber": const Groupings(),
    "stickings": const StickingsDisplay2(),
    "reference points": const ReferencePoints()
  };

  BannerAd? _bannerAd;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
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
      title: 'Stickings',
      home: _currentConcept,
      // home: Scaffold(
      //     appBar: AppBar(
      //         title: Text(_currentConceptName),
      //         backgroundColor: trimColor,
      //         actions: <Widget>[
      //           Padding(
      //             padding: const EdgeInsets.only(right: 10.0),
      //             child: IconButton(
      //               icon: const Icon(Icons.settings),
      //               onPressed: () {
      //                 _currentConcept.editSettings();
      //               },
      //             ),
      //           )
      //         ]),
      // drawer: Drawer(
      //     backgroundColor: backgroundColor,
      //     child: Builder(
      //         builder: (context) => ListView(
      //               // Important: Remove any padding from the ListView.
      //               padding: EdgeInsets.zero,
      //               children: <Widget>[
      //                     const DrawerHeader(
      //                       decoration: BoxDecoration(
      //                         color: trimColor,
      //                       ),
      //                       child: Text('rhythmic concepts:',
      //                           style: defaultText),
      //                     )
      //                   ] +
      //                   _concepts.keys
      //                       .map(
      //                         (conceptName) => ListTile(
      //                           title:
      //                               Text(conceptName, style: defaultText),
      //                           tileColor: backgroundColor,
      //                           onTap: () {
      //                             setState(() => {
      //                                   _currentConceptName = conceptName,
      //                                   _currentConcept =
      //                                       _concepts[conceptName]!
      //                                 });
      //                             Navigator.pop(context);
      //                           },
      //                         ),
      //                       )
      //                       .toList(),
      //             ))),
      // body: FutureBuilder<void>(
      //     future: _initGoogleMobileAds(),
      //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
      //       return DefaultTextStyle(
      //           style: defaultText,
      //           child: Container(
      //               padding: elementPadding,
      //               color: backgroundColor,
      //               child: _bannerAd != null
      //                   ? Column(children: [
      //                       Align(
      //                         alignment: Alignment.topCenter,
      //                         child: SizedBox(
      //                           width: _bannerAd!.size.width.toDouble(),
      //                           height: _bannerAd!.size.height.toDouble(),
      //                           child: AdWidget(ad: _bannerAd!),
      //                         ),
      //                       ),
      //                       _currentConcept
      //                     ])
      //                   : _currentConcept));
    ); //)));
  }
}
