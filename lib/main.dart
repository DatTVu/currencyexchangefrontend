import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_pickers.dart';
import 'package:country_currency_pickers/currency_picker_dropdown.dart';
import 'package:currencyexchangeservice/pages/currencyExchangeService/currencyExchangeService_controller.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:currencyexchangeservice/data/providers/currencyexchange/currencyexchange_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:currencyexchangeservice/globalwidgets/primary_button.dart';
import 'package:intl/intl.dart';

void main() => runApp(GetMaterialApp(home: Home()));

const String EUROPE_CURRENCY_CODE = 'EUR';
const String US_CURRENCY_CODE = 'USD';
const String US_COUNTRY_CODE = 'US';

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
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 4 * Get.width / 5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  height: 20,
                ),
                Obx(() => Text(currencyController.date.value.toString(),
                    style: TextStyle(color: Colors.red))),
                SizedBox(
                  height: 20,
                ),
                _buildDatePickerButton(context, currencyController),
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryButton(
                          width: Get.width / 4,
                          height: Get.height / 12,
                          textContent: "Get Latest Rate",
                          onPressed: () {
                            _getLatestExchangerate(
                                currencyController,
                                currencyController.baseCurrency.string,
                                currencyController.convertCurrency.string);
                          }),
                      PrimaryButton(
                          width: Get.width / 4,
                          height: Get.height / 12,
                          textContent: "Get Historical Rate",
                          onPressed: () {
                            _getHistoricalExchangeRate(
                                currencyController,
                                currencyController.baseCurrency.string,
                                currencyController.convertCurrency.string,
                                currencyController.date.string);
                          }),
                    ]),
              ]),
        ),
      ),
    );
  }
}

//TO-DO: Refactor this part. Duplicated Code here and below
void _getLatestExchangerate(CurrencyExchangeController controller,
    String baseCurrency, String convertCurrency) async {
  try {
    final response = await currencyExchangeApiProvider.getlatestexchangerate();
    if (baseCurrency == convertCurrency) {
      controller.updateConvertAmount("1.0");
    } else if (baseCurrency == EUROPE_CURRENCY_CODE) {
      String rate = response["rates"][convertCurrency].toString();
      controller.updateConvertAmount(rate);
    } else if (convertCurrency == EUROPE_CURRENCY_CODE) {
      double tempBaseRate = response["rates"][baseCurrency];
      controller.updateConvertAmount((1.0 / tempBaseRate).toString());
    } else {
      double tempBaseRate = response["rates"][baseCurrency];
      double tempConvertRate = response["rates"][convertCurrency];
      controller
          .updateConvertAmount((tempConvertRate / tempBaseRate).toString());
    }
    return;
  } catch (error) {
    print(error);
  }
}

//TO-DO: Refactor this part. Duplicated Code here and above
void _getHistoricalExchangeRate(CurrencyExchangeController controller,
    String baseCurrency, String convertCurrency, String date) async {
  if (date == "" || date == null) {
    return;
  }
  try {
    final response =
        await currencyExchangeApiProvider.gethistoricalexchangerate(date);
    if (baseCurrency == convertCurrency) {
      controller.updateConvertAmount("1.0");
    } else if (baseCurrency == EUROPE_CURRENCY_CODE) {
      String rate = response["rates"][convertCurrency].toString();
      controller.updateConvertAmount(rate);
    } else if (convertCurrency == EUROPE_CURRENCY_CODE) {
      double tempBaseRate = response["rates"][baseCurrency];
      controller.updateConvertAmount((1.0 / tempBaseRate).toString());
    } else {
      double tempBaseRate = response["rates"][baseCurrency];
      double tempConvertRate = response["rates"][convertCurrency];
      controller
          .updateConvertAmount((tempConvertRate / tempBaseRate).toString());
    }
    return;
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

Widget _buildDatePickerButton(context, CurrencyExchangeController controller) =>
    PrimaryButton(
      onPressed: () {
        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: DateTime(2018, 3, 5),
            maxTime: DateTime.now(),
            onChanged: (date) {}, onConfirm: (date) {
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          final String formatted = formatter.format(date);
          controller.updateDate(formatted);
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      textContent: 'Click here to choose a Date',
    );
