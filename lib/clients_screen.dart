import 'dart:math';

import 'package:cadastro/crud.dart';
import 'package:cadastro/main.dart';
import 'package:cadastro/register_screen.dart';
import 'package:cadastro/windows_toolbar.dart';
import 'package:flutter/material.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen>
    with SingleTickerProviderStateMixin {
  List<Client> clients = [];
  final ScrollController controller = ScrollController();
  late Animation<double> curve =
      CurvedAnimation(parent: anim, curve: Curves.linear);
  late Animation<Offset> animation =
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0))
          .animate(curve);
  late AnimationController anim;
  int page = 0;
  int? selectedClient;

  void loadMore() {
    clientRepository.getClients(page).then((value) {
      setState(() {
        clients.addAll(value);
      });
      page++;
    });
  }

  void closeDetails() {
    anim
        .animateTo(0,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: (1000.0 * anim.value).toInt()))
        .whenComplete(() => setState(() {
              selectedClient = null;
            }));
  }

  void openDetails(int index) async {
    var res = await clientRepository.getClientBill(clients[index].id);
    clients[index].sales = res;
    setState(() {
      selectedClient = index;
    });
    anim.animateTo(1,
        curve: Curves.easeInOutCubicEmphasized,
        duration: Duration(milliseconds: (500 * (1 - anim.value)).toInt()));
  }

  @override
  void initState() {
    super.initState();
    loadMore();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        loadMore();
      }
    });

    anim = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color.fromARGB(255, 26, 137, 211).withOpacity(1),
          const Color.fromARGB(255, 54, 168, 244).withOpacity(1),
        ], begin: Alignment.topLeft, end: Alignment.centerRight)),
        child: Column(
          children: [
            WindowToolbar(
              callback: () => setState(() {}),
            ),
            AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8, top: 20),
                child: RoundedSquareButton(
                  onPress: () => {
                    Navigator.pop(context),
                  },
                  useBorder: true,
                  useBoxShadow: true,
                  useIconShadow: false,
                  backgroundColor: Colors.transparent,
                  height: 60,
                  width: 60,
                  icon: Icons.arrow_back,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              primary: false,
              toolbarHeight: 80,
              leadingWidth: 80,
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        return ListItem(
                            name: clients[index].name,
                            surname: clients[index].surname,
                            onPress: () async {
                              openDetails(index);
                            });
                      },
                      itemCount: clients.length),
                  if (selectedClient != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SlideTransition(
                        position: animation,
                        child: ClientDetails(
                            client: clients[selectedClient!],
                            close: closeDetails),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientDetails extends StatefulWidget {
  const ClientDetails({
    super.key,
    required this.client,
    required this.close,
  });

  final void Function() close;
  final Client client;

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails>
    with SingleTickerProviderStateMixin {
  late Animation<double> curve = CurvedAnimation(
    parent: anim,
    curve: Curves.elasticOut,
  );
  late AnimationController anim;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    curve.addListener(() => setState(() {}));
    anim.repeat();
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(1.0),
            // border: Border.all(color: Colors.black.withOpacity(1)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 7,
                  blurStyle: BlurStyle.outer),
            ],
          ),
          padding: const EdgeInsets.all(20),
          constraints:
              BoxConstraints.expand(height: constraints.maxHeight * 0.8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: RoundedSquareButton(
                  onPress: widget.close,
                  useBorder: true,
                  useBoxShadow: true,
                  useIconShadow: false,
                  backgroundColor: Colors.transparent,
                  height: 40,
                  width: 40,
                  iconColor: const Color.fromARGB(255, 51, 51, 51),
                  icon: Icons.close_rounded,
                  iconSize: 24,
                  border:
                      Border.all(color: const Color.fromARGB(255, 56, 56, 56)),
                ),
              ),
              if (widget.client.sales.isNotEmpty)
                Text(widget.client.sales[0].items[0].price.toString()),
              Expanded(
                child: Align(
                  // direction: Axis.horizontal,
                  alignment: Alignment.topLeft,
                  child:
                      // Container(
                      //   height: 20,
                      //   width: 5,
                      //   decoration: BoxDecoration(
                      //       color: Colors.red,
                      //       borderRadius:
                      //           BorderRadius.horizontal(left: Radius.circular(10))),
                      // ),
                      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinePaint(
                      curve: curve,
                      width: 100,
                      height: 10,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class LinePaint extends StatelessWidget {
  const LinePaint(
      {super.key, required this.curve, this.height = 10, this.width = 200});

  final double width;
  final double height;
  final Animation<double> curve;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      willChange: true,
      isComplex: true,
      painter: LinePainter(
          animationValue: curve.value,
          value: 0.2,
          height: height,
          width: width),
    );
  }
}

class LinePainter extends CustomPainter {
  LinePainter({
    this.value = 1,
    this.animationValue = 1,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;
  double value;
  double animationValue;

  double tanh(double angle) {
    if (angle > 19.1) {
      return 1.0;
    }

    if (angle < -19.1) {
      return -1.0;
    }

    var e1 = exp(angle);
    var e2 = exp(-angle);
    return (e1 - e2) / (e1 + e2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawPaint(Paint()..blendMode = BlendMode.clear);
    var paint = Paint()..color = Colors.green;
    var paint1 = Paint()..color = Colors.red;
    value *= animationValue;

    if (value > 1) value = 1;

    if (value < 0) value = 0;

    double gap = 2;
    double v = 0;
    double b = 0;

    if (value >= 0.9) {
      b = 1 - (1 - value) / 0.1;
    }
    if (value <= 0.1) {
      v = 1 - value / 0.1;
    }

    double a = value >= 0.99 ? 1 : tanh(b * 7 - 5) / 2.0 + 0.5;
    b = value >= 0.99 ? 1 : exp(b * 5) / exp(5);
    double c = value <= 0.01 ? 1 : tanh(v * 7 - 5) / 2.0 + 0.5;
    v = value <= 0.01 ? 1 : exp(v * 5) / exp(5);

    canvas.drawPath(
        Path()
          ..addRRect(RRect.fromRectAndCorners(
              Rect.fromPoints(
                  Offset(0, v * (height / 2)),
                  Offset(
                      (width * value) - (gap / 2), height - v * (height / 2))),
              topLeft: const Radius.circular(5),
              bottomLeft: const Radius.circular(5),
              topRight: Radius.circular(5 * a),
              bottomRight: Radius.circular(5 * a))),
        paint);

    canvas.drawPath(
        Path()
          ..addRRect(
            RRect.fromRectAndCorners(
                Rect.fromPoints(
                    Offset(width - width * (1 - value) + (gap / 2),
                        b * (height / 2)),
                    Offset(width, height - b * (height / 2))),
                topRight: const Radius.circular(5),
                bottomRight: const Radius.circular(5),
                topLeft: Radius.circular(5 * c),
                bottomLeft: Radius.circular(5 * c)),
          ),
        paint1);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ListItem extends StatelessWidget {
  const ListItem(
      {super.key,
      required this.name,
      required this.surname,
      required this.onPress});

  final String name;
  final String surname;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 7,
                  blurStyle: BlurStyle.outer),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              Text(surname, style: const TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
