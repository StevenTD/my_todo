import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_todo/home.dart';
import 'package:my_todo/todo_bloc/todo_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) => MaterialApp(
          title: 'Flutter Demo',
          darkTheme: ThemeData(
            colorScheme: dark,
            useMaterial3: true,
          ),
          theme: ThemeData(
            colorScheme: light,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          home: BlocProvider(
            create: (context) => TodoBloc()..add(TodoStarted()),
            child: MyHomePage(),
          )

          // const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}
