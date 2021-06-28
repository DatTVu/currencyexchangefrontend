import 'package:currencyexchangeservice/data/providers/api/api_provider.dart';
import 'package:currencyexchangeservice/data/values/apis.dart';

abstract class ICurrencyExchangeProvider {
  Future<dynamic> getlatestexchangerate();
  Future<dynamic> gethistoricalexchangerate(String date);
}

class CurrencyExchangeProvider implements ICurrencyExchangeProvider {
  final apiProvider = new ApiProvider();

  @override
  Future<dynamic> getlatestexchangerate() async {
    return await apiProvider.get(GET_LATEST_RATE);
  }

  @override
  Future<dynamic> gethistoricalexchangerate(String date) async {
    final currencyResponse = await apiProvider.get(GET_HISTORICAL_RATE);
    return currencyResponse;
  }
}
