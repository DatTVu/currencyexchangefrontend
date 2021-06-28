import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class CurrencyExchangeController extends GetxController {
  var count = 0.obs;
  String baseAmount = "1.0";
  RxString convertAmount = "0.0".obs;
  var baseCurrency = "0".obs;
  var convertCurrency = "0".obs;
  CurrencyExchangeController();
  changeBaseCurrency(RxString newCurrency) {
    baseCurrency = newCurrency;
  }

  changeConvertCurrency(RxString newCurrency) {
    convertCurrency = newCurrency;
  }

  updateConvertAmount(String newAmount) {
    convertAmount.value = newAmount;
  }

  increment() => count++;
}
