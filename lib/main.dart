// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_gitverse/src/model/app_state.dart';
import 'package:flutter_gitverse/src/redux/reducers.dart';
import 'package:flutter_gitverse/src/routes/routes.dart';
import 'package:flutter_gitverse/src/screens/home_page.dart';
import 'package:flutter_gitverse/src/screens/user_details.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState(userName: ''),
    middleware: [thunkMiddleware],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'GitVerse',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.user_details: (context) => UserDetailsScreen(username: '',),
        },
      ),
    );
  }
}
