import 'package:raven/records.dart';
import 'package:raven/records/security.dart';
import 'package:raven/reservoir/index.dart';
import 'package:raven/reservoir/reservoir.dart';

class HistoryReservoir extends Reservoir<dynamic, History> {
  late MultipleIndex<dynamic, History> byAccount;
  late MultipleIndex<dynamic, History> byWallet;
  late MultipleIndex<dynamic, History> byScripthash;
  late MultipleIndex<dynamic, History> bySecurity;

  HistoryReservoir([source])
      : super(source ?? HiveSource('histories'), (history) => history.txHash) {
    byAccount = addMultipleIndex('account', (history) => history.accountId);
    byWallet = addMultipleIndex('wallet', (history) => history.walletId);
    byScripthash =
        addMultipleIndex('scripthash', (history) => history.scripthash);
    bySecurity = addMultipleIndex('security', (history) => history.security);
  }

  /// Master overview /////////////////////////////////////////////////////////

  Iterable<History> unspentsByTicker({Security security = RVN}) {
    return bySecurity.getAll(security).where((history) => history.value > 0);
  }

  BalanceRaw balanceByTicker({Security security = RVN}) {
    return unspentsByTicker(security: security).fold(
        BalanceRaw(confirmed: 0, unconfirmed: 0),
        (sum, history) =>
            sum +
            BalanceRaw(
                confirmed: (history.txPos > -1 ? history.value : 0),
                unconfirmed: history.value));
  }

  /// Account overview ////////////////////////////////////////////////////////
  /// could these be turned into an index?
  /// returns a series of spendable transactions for an account and asset

  Iterable<History> transactionsByAccount(String accountId,
      {Security security = RVN}) {
    return byAccount.getAll(accountId).where((history) =>
        history.txPos > -1 && // not in mempool
        history.security == security);
  }

  Iterable<History> unspentsByAccount(String accountId,
      {Security security = RVN}) {
    return byAccount.getAll(accountId).where((history) =>
        history.value > 0 && // unspent
        history.txPos > -1 && // not in mempool
        history.security == security);
  }

  Iterable<History> unconfirmedByAccount(String accountId,
      {Security security = RVN}) {
    return byAccount.getAll(accountId).where((history) =>
        history.value > 0 && // unspent
        history.txPos == -1 && // in mempool
        history.security == security);
  }

  /// Wallet overview /////////////////////////////////////////////////////////

  Iterable<History> transactionsByWallet(String walletId,
      {Security security = RVN}) {
    return byWallet.getAll(walletId).where((history) =>
        history.txPos > -1 && // not in mempool
        history.security == security);
  }

  Iterable<History> unspentsByWallet(String walletId,
      {Security security = RVN}) {
    return byWallet.getAll(walletId).where((history) =>
        history.value > 0 && // unspent
        history.txPos > -1 && // not in mempool
        history.security == security);
  }

  Iterable<History> unconfirmedByWallet(String walletId,
      {Security security = RVN}) {
    return byWallet.getAll(walletId).where((history) =>
        history.value > 0 && // unspent
        history.txPos == -1 && // in mempool
        history.security == security);
  }

  /// remove logic ////////////////////////////////////////////////////////////

  void removeHistories(String scripthash) {
    return byScripthash
        .getAll(scripthash)
        .forEach((history) => remove(history));
  }
}
