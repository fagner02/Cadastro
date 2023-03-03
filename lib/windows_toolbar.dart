import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

List<Function()> _callbacks = [];

class WindowToolbar extends StatefulWidget {
  const WindowToolbar(
      {super.key, this.color = Colors.white, required this.callback});

  final Color color;
  final void Function() callback;

  @override
  State<WindowToolbar> createState() => WindowToolbarState();
}

class WindowToolbarState extends State<WindowToolbar> {
  static bool maximized = false;
  static IconData maximizeIcon = Icons.fullscreen;
  late int index;

  @override
  void initState() {
    super.initState();
    index = _callbacks.length;
    _callbacks.add(widget.callback);
  }

  @override
  void dispose() {
    _callbacks.removeAt(index);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onPanDown: (details) => {
                  windowManager.startDragging(),
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: const BoxConstraints.expand(height: 40),
                  padding: const EdgeInsets.only(left: 8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.color,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        "Flutter",
                        style: TextStyle(
                          color: widget.color,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => windowManager.minimize(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform(
                      transform: Matrix4.translationValues(0.0, -7, 0.0),
                      child: Icon(
                        Icons.minimize,
                        color: widget.color,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (maximized) {
                      maximizeIcon = Icons.fullscreen;
                      windowManager.unmaximize();
                    } else {
                      maximizeIcon = Icons.fullscreen_exit;
                      windowManager.maximize();
                    }
                    maximized = !maximized;
                    for (var element in _callbacks) {
                      element();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(maximizeIcon, color: widget.color),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => windowManager.close(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    }
    return Container();
  }
}
