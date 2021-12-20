import 'package:intl/intl.dart';
import 'package:raven_back/raven_back.dart';

class TextComponents {
  TextComponents();

  String rvnUSD(
    double amount, {
    double? rate,
    String prefix = '\$ ',
  }) =>
      amount == 0
          ? NumberFormat('$prefix#,##0.00', 'en_US').format(0)
          : NumberFormat('$prefix#,##0.00', 'en_US')
              .format((amount * (rate ?? services.rate.rvnToUSD ?? 0.0)));

  /// returns a string representation of the value as amount or fiat
  String securityAsReadable(
    int sats, {
    Security? security,
    String? symbol,
    bool asUSD = false,
  }) {
    security ??
        symbol ??
        (() => throw OneOfMultipleMissing(
            'security or symbol required to identify record.'))();
    symbol = security?.symbol ?? symbol ?? 'RVN';
    if (symbol == 'RVN') {
      var asAmount = satToAmount(sats);
      return asUSD
          ? rvnUSD(asAmount)
          : NumberFormat('#,##0.########', 'en_US').format(asAmount);
    }
    // asset sats -> asset -> rvn -> usd
    security = security ??
        securities.bySymbolSecurityType
            .getOne(symbol, SecurityType.RavenAsset) ??
        Security(symbol: symbol, securityType: SecurityType.RavenAsset);
    return asUSD
        ? rvnUSD(sats * (services.rate.assetToRVN(security) ?? 0.0))
        : NumberFormat(
                '#,##0${(security.asset?.divisibility ?? 0) > 0 ? '.' + '0' * (security.asset?.divisibility ?? 0) : ''}',
                'en_US')
            .format(sats);
  }
}
