import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'currencyExchangeService_controller.dart';

//TO-DO Build the CurrencyExchangeView here instead of putting it in main
class CurrencyExchangeView extends GetView<CurrencyExchangeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyExchangeController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Stack(
                  children: [
                    _buildPageView(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildPageView() {
    return Obx(
      () {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, //Center
          mainAxisSize: MainAxisSize.max,
        );
      },
    );
  }
}
