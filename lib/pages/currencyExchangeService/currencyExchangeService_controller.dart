import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class CurrencyExchangeController extends GetxController {
  String baseAmount = "1.0";
  RxString convertAmount = "0.0".obs;
  RxString date = "2021-6-6".obs;
  RxString baseCurrency = "0".obs;
  RxString convertCurrency = "0".obs;
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

  updateDate(String newDate) {
    date.value = newDate;
  }
}
