import 'package:raven/steward/reservoirs.dart';
import 'package:raven/utils/rate.dart';
import 'package:raven/waiters/waiter.dart';
import 'package:raven/records.dart';
import 'package:raven/reservoirs.dart';

class RatesWaiter extends Waiter {
  late final BalanceReservoir balances;
  late final ExchangeRateReservoir rates;

  RatesWaiter() : super() {
    balances = ReservoirsSteward().balances;
    rates = ReservoirsSteward().rates;
  }

  Future saveRate() async {
    rates.save(Rate(base: RVN, quote: USD, rate: await RVNtoFiat().get()));
  }

  double get rvnToUSD => rates.rvnToUSD;

  BalanceUSD accountBalanceUSD(String accountId) {
    var totalRVNBalance = getTotalRVN(accountId);
    var usd;
    if (totalRVNBalance.value > 0) {
      var rate = rates.rvnToUSD;
      usd = BalanceUSD(
          confirmed: (totalRVNBalance.confirmed * rate).toDouble(),
          unconfirmed: (totalRVNBalance.confirmed * rate).toDouble());
    }
    return usd;
  }

  Balance getTotalRVN(String accountId) {
    var accountBalances = balances.byAccount.getAll(accountId);
    var accountBalancesAsRVN = accountBalances.map((balance) => Balance(
        accountId: accountId,
        security: RVN,
        confirmed: balance.security == RVN
            ? balance.confirmed
            : (balance.confirmed * rates.assetToRVN(balance.security)).round(),
        unconfirmed: balance.security == RVN
            ? balance.unconfirmed
            : (balance.unconfirmed * rates.assetToRVN(balance.security))
                .round()));
    return accountBalancesAsRVN.fold(
        Balance(
          accountId: accountId,
          security: RVN,
          confirmed: 0,
          unconfirmed: 0,
        ),
        (summing, balance) => summing + balance);
  }
}
