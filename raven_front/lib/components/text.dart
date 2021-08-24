import 'package:raven/init/reservoirs.dart' as res;

String rvnUSDBalance(int balance) =>
    '${(balance * res.rates.rvnToUSD).toStringAsFixed(2)}';

class RavenText {
  RavenText();

  static String rvnUSD(balance) => rvnUSDBalance(balance);
}
