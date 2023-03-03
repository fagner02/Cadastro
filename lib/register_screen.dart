import 'dart:ui';

import 'package:cadastro/crud.dart';
import 'package:cadastro/main.dart';
import 'package:cadastro/windows_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'background_paint.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ClientRepository clientRepository = ClientRepository();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
    ));

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 99, 172, 255),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Column(
          children: [
            WindowToolbar(
              callback: () => setState(() {}),
            ),
            AppBar(
              leading: RoundedSquareButton(
                onPress: () => {},
                icon: Icons.arrow_back_rounded,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //     left: 20.0,
              //     top: 20,
              //   ),
              //   child: GestureDetector(
              //     onTap: () => {
              //       Navigator.pop(context),
              //     },
              //     child: Container(
              //       decoration: BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withOpacity(0.1),
              //             blurRadius: 7,
              //             blurStyle: BlurStyle.outer,
              //           ),
              //         ],
              //         borderRadius: BorderRadius.circular(10),
              //         border: Border.all(
              //           color: Colors.white.withOpacity(0.5),
              //         ),
              //       ),
              //       child: const Icon(
              //         Icons.arrow_back_rounded,
              //         color: Colors.white,
              //         size: 28,
              //       ),
              //     ),
              //   ),
              // ),

              leadingWidth: 70,
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  DecoratedTextInput(
                    label: "Nome",
                    controller: nameController,
                  ),
                  DecoratedTextInput(
                    label: "Sobrenome",
                    controller: surnameController,
                  ),
                  DecoratedTextInput(
                    label: "Email",
                    controller: emailController,
                  ),
                  DecoratedTextInput(
                    label: "Telefone",
                    controller: phoneController,
                  ),
                  DecoratedTextInput(
                    label: "Endereço",
                    controller: addressController,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          if (nameController.text.trim().isEmpty ||
                              surnameController.text.trim().isEmpty) {
                            return;
                          }
                          clientRepository.postClients(
                              name: nameController.text,
                              surname: surnameController.text,
                              phone: phoneController.text,
                              address: addressController.text);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          width: 60,
                          height: 60,
                          child: const Icon(
                            Icons.add_business_outlined,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DecoratedTextInput extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  const DecoratedTextInput({Key? key, this.label = 'Nome', this.controller})
      : super(key: key);

  @override
  State<DecoratedTextInput> createState() => _DecoratedTextInputState();
}

class _DecoratedTextInputState extends State<DecoratedTextInput> {
  Color color = Colors.white;
  Color background = Colors.transparent;
  Color textColor = Colors.white;

  void validate(value) {
    if (value.trim().isEmpty) {
      setState(() {
        color = Color.fromARGB(255, 255, 68, 55);
        background = Color.fromARGB(255, 255, 40, 24).withOpacity(0.1);
        textColor = Color.fromARGB(255, 226, 57, 57);
      });
    } else {
      setState(() {
        color = Colors.white;
        background = Colors.transparent;
        textColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 7,
              blurStyle: BlurStyle.outer,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: color.withOpacity(0.5),
                ),
              ),
              child: TextField(
                controller: widget.controller,
                onSubmitted: validate,
                onChanged: validate,
                onEditingComplete: () => validate(widget.controller!.text),
                style: TextStyle(
                  color: textColor,
                ),
                decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    labelText: widget.label,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(color: textColor),
                    floatingLabelStyle: TextStyle(
                        color: textColor.withOpacity(0.5), fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
