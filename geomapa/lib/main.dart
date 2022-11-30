// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl_example/fullmapbox.dart';
import 'full_map.dart';
import 'map_ui.dart';
import 'page.dart';

final List<MainPage> _allPages = <MainPage>[
  MapUiPage(),
  FullMapPage(),
  FullMapPage2(),
];

class MapsFlutter extends StatefulWidget {
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  @override
  State<MapsFlutter> createState() => _MapsFlutterState();
}

class _MapsFlutterState extends State<MapsFlutter> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> initHybridComposition() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion != null && sdkVersion >= 29) {
        MapboxMap.useHybridComposition = true;
      } else {
        MapboxMap.useHybridComposition = false;
      }
    }
  }

  void _pushPage(BuildContext context, MainPage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapbox Mapas')),
      body: MapsFlutter.ACCESS_TOKEN.isEmpty ||
              MapsFlutter.ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (_, int index) => ListTile(
                leading: _allPages[index].leading,
                title: Text(_allPages[index].title),
                onTap: () => _pushPage(context, _allPages[index]),
              ),
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsFlutter()));
}
