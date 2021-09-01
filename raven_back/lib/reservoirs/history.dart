import 'package:collection/collection.dart';
import 'package:raven/records/records.dart';
import 'package:raven/records/security.dart';
import 'package:reservoir/reservoir.dart';

part 'history.keys.dart';

class HistoryReservoir extends Reservoir<_TxHashKey, History> {
  late IndexMultiple<_AccountKey, History> byAccount;
  late IndexMultiple<_WalletKey, History> byWallet;
  late IndexMultiple<_ScripthashKey, History> byScripthash;
  late IndexMultiple<_SecurityKey, History> bySecurity;

  HistoryReservoir([source])
      : super(source ?? HiveSource('histories'), _TxHashKey()) {
    byAccount = addIndexMultiple('account', _AccountKey());
    byWallet = addIndexMultiple('wallet', _WalletKey());
    byScripthash = addIndexMultiple('scripthash', _ScripthashKey());
    bySecurity = addIndexMultiple('security', _SecurityKey());
  }

  /// remove logic ////////////////////////////////////////////////////////////

  void removeHistories(String scripthash) {
    return byScripthash
        .getAll(scripthash)
        .forEach((history) => remove(history));
  }
}
