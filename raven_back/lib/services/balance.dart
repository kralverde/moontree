/// balances are by wallet, and aggregated to the account level.
/// if you want the balance of a subwallet (address) then get it from Histories.

import 'package:raven/reservoirs/vout.dart';
import 'package:reservoir/change.dart';

import 'package:raven/services/wallet_security_pair.dart';
import 'package:raven/utils/exceptions.dart';
import 'package:raven/raven.dart';

class BalanceService {
  /// Listener Logic //////////////////////////////////////////////////////////

  /// Get (sum) the balance for an account-security pair
  Balance sumBalance(Wallet wallet, Security security) => Balance(
      walletId: wallet.walletId,
      security: security,
      confirmed:
          VoutReservoir.whereUnspent(given: wallet.vouts, security: security)
              .fold(0, (sum, history) => sum + history.value),
      unconfirmed: VoutReservoir.whereUnconfirmed(
              given: wallet.vouts, security: security)
          .fold(0, (sum, history) => sum + history.value));

  /// If there is a change in its history, recalculate a balance. Return a list
  /// of such balances.
  Iterable<Balance> getChangedBalances(List<Change> changes) =>
      securityPairsFromVoutChanges(changes)
          .map((pair) => sumBalance(pair.wallet, pair.security));

  /// Same as getChangedBalances, but saves them all as well.
  Future<Iterable<Balance>> saveChangedBalances(List<Change> changes) async {
    var changed = getChangedBalances(changes);
    await balances.saveAll(changed.toList());
    return changed;
  }

  /// Transaction Logic ///////////////////////////////////////////////////////

  /// Sort in descending order, from largest amount to smallest amount
  List<Vout> sortedUnspents(Account account) =>
      account.unspents.toList()..sort((a, b) => b.value.compareTo(a.value));

  /// Sort in descending order, from largest amount to smallest amount
  List<Vout> sortedUnspentsWallets(Wallet wallet) =>
      wallet.unspents.toList()..sort((a, b) => b.value.compareTo(a.value));

  /// Asserts that the asset in the account is greater than `amount`
  void assertSufficientFunds(int amount, Account account,
      {Security security = RVN}) {
    if (accountBalance(account, security).confirmed < amount) {
      throw InsufficientFunds();
    }
  }

  /// Asserts that the asset in the account is greater than `amount`
  void assertSufficientFundsWallets(int amount, Wallet wallet,
      {Security security = RVN}) {
    if (walletBalance(wallet, security).confirmed < amount) {
      throw InsufficientFunds();
    }
  }

  /// Returns the smallest number of inputs to satisfy the amount
  ///
  /// NOTE: buildTransaction depends on this function returning a UTXO list
  /// size that either STAYS THE SAME or INCREASES IN SIZE since last calling
  /// it if the 'amount' increases.
  ///
  List<Vout> collectUTXOs(Account account,
      {required int amount, List<Vout> except = const []}) {
    assertSufficientFunds(amount, account);

    var unspents = sortedUnspents(account)
      ..removeWhere((utxo) => except.contains(utxo));

    /// Can we find a single, ideal UTXO by searching from smallest to largest?
    for (var unspent in unspents.reversed) {
      if (unspent.value >= amount) return [unspent];
    }

    /// Otherwise, satisfy the amount by combining UTXOs from largest to smallest
    /// perhaps we could make the utxo variable full of objects that contain
    /// the signing information too, that way we don't have to get it later...?
    var collection = <Vout>[];
    var remaining = amount;
    for (var unspent in unspents) {
      if (remaining > 0) collection.add(unspent);
      if (remaining < unspent.value) break;
      remaining -= unspent.value;
    }

    return collection;
  }

  List<Vout> collectUTXOsWallet(Wallet wallet,
      {required int amount, List<Vout> except = const []}) {
    assertSufficientFundsWallets(amount, wallet);

    var unspents = sortedUnspentsWallets(wallet)
      ..removeWhere((utxo) => except.contains(utxo));

    /// Can we find a single, ideal UTXO by searching from smallest to largest?
    for (var unspent in unspents.reversed) {
      if (unspent.value >= amount) return [unspent];
    }

    /// Otherwise, satisfy the amount by combining UTXOs from largest to smallest
    /// perhaps we could make the utxo variable full of objects that contain
    /// the signing information too, that way we don't have to get it later...?
    var collection = <Vout>[];
    var remaining = amount;
    for (var unspent in unspents) {
      if (remaining > 0) collection.add(unspent);
      if (remaining < unspent.value) break;
      remaining -= unspent.value;
    }

    return collection;
  }

  /// Wallet Aggregation Logic ////////////////////////////////////////////////

  List<Balance> accountBalances(Account account) {
    // ignore: omit_local_variable_types
    Map<Security, Balance> balancesBySecurity = {};
    for (var balance in account.balances) {
      if (!balancesBySecurity.containsKey(balance.security)) {
        balancesBySecurity[balance.security] = balance;
      } else {
        balancesBySecurity[balance.security] =
            balancesBySecurity[balance.security]! + balance;
      }
    }
    return balancesBySecurity.values.toList();
  }

  Balance accountBalance(Account account, Security security) {
    var retBalance =
        Balance(walletId: '', confirmed: 0, unconfirmed: 0, security: security);
    for (var balance in account.balances) {
      if (balance.security == security) {
        retBalance = retBalance + balance;
      }
    }
    return retBalance;
  }

  List<Balance> walletBalances(Wallet wallet) {
    // ignore: omit_local_variable_types
    Map<Security, Balance> balancesBySecurity = {};
    for (var balance in wallet.balances) {
      if (!balancesBySecurity.containsKey(balance.security)) {
        balancesBySecurity[balance.security] = balance;
      } else {
        balancesBySecurity[balance.security] =
            balancesBySecurity[balance.security]! + balance;
      }
    }
    return balancesBySecurity.values.toList();
  }

  Balance walletBalance(Wallet wallet, Security security) {
    var retBalance =
        Balance(walletId: '', confirmed: 0, unconfirmed: 0, security: security);
    for (var balance in wallet.balances) {
      if (balance.security == security) {
        retBalance = retBalance + balance;
      }
    }
    return retBalance;
  }
}
