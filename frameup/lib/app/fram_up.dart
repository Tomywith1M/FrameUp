import 'package:flutter/material.dart';
import 'package:frameup/components/login/login_screen.dart';
import 'package:frameup/state/app_state.dart';
import 'package:provider/provider.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FrameupApp extends StatefulWidget {
  const FrameupApp({
    Key? key,
  }) : super(key: key);

  @override
  State<FrameupApp> createState() => _FrameupAppState();
}

class _FrameupAppState extends State<FrameupApp> {
  final _client = StreamFeedClient('hsxxrdsyjrb7'); //  Add Stream API Token
  late final appState = AppState(client: _client);

  late final feedBloc = FeedBloc(client: _client);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        title: 'Fram-up',
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        builder: (context, child) {
          return FeedProvider(
            bloc: feedBloc,
            child: child!,
          );
        },
        home: const LoginScreen(),
      ),
    );
  }
}
