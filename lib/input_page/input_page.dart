import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_calc/calc_page.dart';
import 'package:ultimate_calc/core/calculation.dart';

class InputPage extends StatelessWidget {
  final overtimePayController = TextEditingController();
  final downtimePayController = TextEditingController();
  final hireCostController = TextEditingController();
  final fireCostController = TextEditingController();

  final requirementsLenController = TextEditingController();
  final requirementsControllersList = <TextEditingController>[];

  InputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputField(
                  title: 'overtimePay'.tr(),
                  controller: overtimePayController,
                ),
                InputField(
                  title: 'downtimePay'.tr(),
                  controller: downtimePayController,
                ),
                InputField(
                  title: 'hireCost'.tr(),
                  controller: hireCostController,
                ),
                InputField(
                  title: 'fireCost'.tr(),
                  controller: fireCostController,
                ),
                SizedBox(height: 24),
                Flexible(
                  child: StatefulBuilder(
                    builder: (localContext, localSetState) {
                      requirementsLenController.addListener(
                        () {
                          int? a = int.tryParse(requirementsLenController.text);
                          if (a != null) {
                            localSetState(() {
                              int diff =
                                  (requirementsControllersList.length - a)
                                      .abs();

                              if (a > requirementsControllersList.length) {
                                for (var i = 0; i < diff; ++i) {
                                  requirementsControllersList
                                      .add(TextEditingController());
                                }
                              } else if (a <
                                  requirementsControllersList.length) {
                                for (var i = 0; i < diff; ++i) {
                                  requirementsControllersList.removeLast();
                                }
                              }
                            });
                          }
                        },
                      );
                      // localSetState();
                      return Column(
                        children: [
                          InputField(
                            title: 'requirementsLen'.tr(),
                            controller: requirementsLenController,
                          ),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: requirementsControllersList.length,
                              itemBuilder: (context, index) => InputField(
                                title:
                                    'requirement'.tr() + ' ' + index.toString(),
                                controller: requirementsControllersList[index],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    final tables = validateTables();
                    tables != null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CalcPage(tables: tables),
                            ),
                          )
                        : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('error_parsing'.tr()),
                            ),
                          );
                  },
                  child: Text(
                    'buildTables'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Tables? validateTables() {
    final requirements = <int>[];
    for (var req in requirementsControllersList) {
      final value = int.tryParse(req.text);
      if (value == null) {
        return null;
      }
      requirements.add(value);
    }

    final overtimePay = int.tryParse(overtimePayController.text);
    if (overtimePay == null) return null;

    final downtimePay = int.tryParse(downtimePayController.text);
    if (downtimePay == null) return null;

    final fireCost = int.tryParse(fireCostController.text);
    if (fireCost == null) return null;

    final hireCost = int.tryParse(hireCostController.text);
    if (hireCost == null) return null;

    return Tables(
      requirements: requirements,
      overtimePay: overtimePay,
      downtimePay: downtimePay,
      fireCost: fireCost,
      hireCost: hireCost,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 40),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.all(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
