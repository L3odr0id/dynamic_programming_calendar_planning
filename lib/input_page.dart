import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputState();
}

class _InputState extends State<InputPage> {
  final overtimePayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              title: 'overtimePay'.tr(),
              controller: overtimePayController,
            ),
          ],
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const InputField({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  String? validation(String? text) {
    if (text != null) {
      if (int.tryParse(text) == null) {
        return '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const SizedBox(width: 16),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 40),
          child: TextFormField(
            controller: controller,
            validator: validation,
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(5),
            ),
          ),
        ),
      ],
    );
  }
}
