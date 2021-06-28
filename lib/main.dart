import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';
import 'package:currencyexchangeservice/pages/currencyExchangeService/currencyExchangeService_controller.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:currencyexchangeservice/data/providers/currencyexchange/currencyexchange_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(GetMaterialApp(home: Home()));

String EUROPE_CURRENCY_CODE = 'EUR';
String US_CURRENCY_CODE = 'USD';
String US_COUNTRY_CODE = 'US';

final CurrencyExchangeProvider currencyExchangeApiProvider =
    new CurrencyExchangeProvider();

class Home extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final CurrencyExchangeController currencyController =
        Get.put(CurrencyExchangeController());

    Locale myLocale = Localizations.localeOf(context);
    final String myCountryCode = myLocale.countryCode;
    final String myCurrentCurrrencyCode = myCountryCode == US_COUNTRY_CODE
        ? US_CURRENCY_CODE
        : EUROPE_CURRENCY_CODE;
    final String defaultConvertCurrencyCode = myCountryCode == US_COUNTRY_CODE
        ? EUROPE_CURRENCY_CODE
        : US_CURRENCY_CODE;
    currencyController.changeBaseCurrency(RxString(myCurrentCurrrencyCode));
    currencyController
        .changeConvertCurrency(RxString(defaultConvertCurrencyCode));
    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Text("Currency Exchange Service")),

      // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(currencyController.baseAmount,
                    style: TextStyle(color: Colors.red)),
                SizedBox(
                  width: 20,
                ),
                _buildCurrencyPickerDropDown(
                    myCurrentCurrrencyCode, currencyController, true)
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => Text(
                    currencyController.convertAmount.value.toString(),
                    style: TextStyle(color: Colors.red))),
                SizedBox(
                  width: 20,
                ),
                _buildCurrencyPickerDropDown(
                    defaultConvertCurrencyCode, currencyController, false)
              ],
            ),
            SizedBox(
              height: 50,
            ),
            _buildDatePickerButton(context),
            SizedBox(
              height: 50,
            ),
            TextButton(
                child: Text("Get Latest Rate"),
                onPressed: () {
                  var test = _getLatestExchangerate(
                      currencyController,
                      currencyController.baseCurrency.string,
                      currencyController.convertCurrency.string);
                }),
            TextButton(child: Text("Get Historical Rate"), onPressed: () {})
          ]),
    );
  }
}

Future<dynamic> _getLatestExchangerate(CurrencyExchangeController controller,
    String baseCurrency, String convertCurrency) async {
  try {
    final response = await currencyExchangeApiProvider.getlatestexchangerate();
    if (response["base"] == EUROPE_CURRENCY_CODE) {
      String rate = response["rates"][convertCurrency].toString();
      controller.updateConvertAmount(rate);
    }
    return response;
  } catch (error) {
    print(error);
  }
}

CurrencyPickerDropdown _buildCurrencyPickerDropDown(
        //TO DO: Bug here, the flag doesn't match the initial country
        String countryCode,
        CurrencyExchangeController currencyController,
        bool isBase) =>
    CurrencyPickerDropdown(
      initialValue: countryCode,
      itemBuilder: _buildCurrencyDropdownItem,
      onValuePicked: (Country country) {
        if (isBase) {
          currencyController.changeBaseCurrency(RxString(country.currencyCode));
        } else {
          currencyController
              .changeConvertCurrency(RxString(country.currencyCode));
        }
      },
    );

Widget _buildCurrencyDropdownItem(Country country) => Container(
      child: Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(
            width: 8.0,
          ),
          Text("${country.currencyCode}"),
        ],
      ),
    );

Widget _buildDatePickerButton(context) => Container(
    color: Colors.lightBlueAccent,
    child: TextButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2018, 3, 5),
              maxTime: DateTime(2021, 12, 31), onChanged: (date) {
            print('change $date');
          }, onConfirm: (date) {
            print('confirm $date');
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Text(
          'Click here to choose a Date',
          style: TextStyle(color: Colors.white),
        )));
