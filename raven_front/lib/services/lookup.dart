import 'package:raven/reservoirs.dart';
import 'package:raven/init/reservoirs.dart' as res;
import 'package:raven/init/services.dart' as services;
import 'package:raven/records.dart';

String currentAccountId() =>
    res.settings.primaryIndex.getOne(SettingName.Current_Account)!.value;

Account currentAccount() =>
    res.accounts.primaryIndex.getOne(currentAccountId())!;

BalanceUSD currentBalanceUSD() =>
    services.ratesService.accountBalanceUSD(currentAccountId());

Balance currentBalanceRVN() => res.balances.getRVN(currentAccountId());

/// our concept of history isn't the same as transactions - must fill out negative values for sent amounts
List<History> currentTransactions() =>
    res.histories.byAccount.getAll(currentAccountId()).toList();

/// our concept of unspents isn't the same as holdings - the aggregate per asset is a holding...
List<Balance> currentHoldings() {
  var accountBalances = res.balances.byAccount.getAll(currentAccountId());
  // ignore: omit_local_variable_types
  Map<Security, Balance> holdings = {};
  for (var balance in accountBalances) {
    if (holdings.keys.contains(balance.security)) {
      holdings[balance.security] = holdings[balance.security]! + balance;
    } else {
      holdings[balance.security] = balance;
    }
  }
  return holdings.values.toList();
}

class Current {
  static Account get account => currentAccount();
  static Balance get balanceRVN => currentBalanceRVN();
  static BalanceUSD get balanceUSD => currentBalanceUSD();
  static List<History> get transactions => currentTransactions();
  static List<Balance> get holdings => currentHoldings();
}
