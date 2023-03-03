import 'dart:io';
import 'dart:ui';

import 'package:cadastro/clients_screen.dart';
import 'package:cadastro/crud.dart';
import 'package:cadastro/infograph.dart';
import 'package:cadastro/windows_toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:window_manager/window_manager.dart';

import 'background_paint.dart';

void main() async {
  await dotenv.load(fileName: "dotenv");
  if (!kIsWeb) {
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      WidgetsFlutterBinding.ensureInitialized();
      await windowManager.ensureInitialized();
      WindowOptions options = const WindowOptions(
        titleBarStyle: TitleBarStyle.hidden,
        size: Size(495, 700),
        center: true,
      );
      windowManager.waitUntilReadyToShow(options);
    }
  }
  await clientRepository.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
    ));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(height: 260),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  constraints: const BoxConstraints.expand(height: 220),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color.fromARGB(255, 26, 137, 211)
                              .withOpacity(1),
                          const Color.fromARGB(255, 54, 168, 244)
                              .withOpacity(1),
                        ],
                      ),
                      backgroundBlendMode: BlendMode.multiply),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bem vindo",
                          style: TextStyle(
                              color: Color.fromARGB(255, 236, 245, 255),
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "John Doe",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(height: 80),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      clipBehavior: Clip.none,
                      children: [
                        RoundedSquareButton(
                          icon: Icons.add_business_outlined,
                          onPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ClientsScreen()));
                          },
                        ),
                        RoundedSquareButton(
                          icon: Icons.post_add_outlined,
                          onPress: () {},
                        ),
                        RoundedSquareButton(
                          icon: Icons.group_add_outlined,
                          onPress: () {},
                        ),
                        RoundedSquareButton(
                          onPress: () {},
                        ),
                        RoundedSquareButton(
                          onPress: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                WindowToolbar(
                  callback: () => {setState(() {})},
                )
              ],
            ),
          ),
          Expanded(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 200),
              painter: BackgroundPaint(),
              child: const Padding(
                  padding: EdgeInsets.all(20), child: Infograph()),
            ),
          )
        ],
      ),
    );
  }
}

class RoundedSquareButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPress;
  final bool useBoxShadow;
  final bool useIconShadow;
  final Color backgroundColor;
  final bool useBorder;
  final Border border;
  final double height;
  final double width;
  final Color iconColor;
  final double iconSize;

  const RoundedSquareButton(
      {Key? key,
      this.icon = Icons.add,
      required this.onPress,
      this.useBoxShadow = true,
      this.useIconShadow = true,
      this.backgroundColor = const Color.fromRGBO(255, 255, 255, 0.2),
      this.iconColor = Colors.white,
      this.iconSize = 34,
      this.useBorder = false,
      this.border = const Border.fromBorderSide(
          BorderSide(color: Colors.white, width: 1)),
      this.height = 80,
      this.width = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: onPress,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (useBoxShadow)
                BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: const Offset(0, 0),
                    blurStyle: BlurStyle.outer),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: height,
                width: width,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: (useBorder)
                      ? border
                      : const Border.fromBorderSide(BorderSide.none),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    shadows: [
                      if (useIconShadow)
                        Shadow(
                            color: const Color.fromARGB(255, 0, 59, 148)
                                .withOpacity(0.9),
                            offset: const Offset(0, 0),
                            blurRadius: 10)
                    ],
                    size: iconSize,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
