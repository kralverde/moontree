import 'package:raven_back/raven_back.dart';

import 'constants.dart';

class ExportWalletService {
  /// entire file is encrypted
  /// export format:
  /// {
  ///   'accounts': {accounts.id: values},
  ///   'wallets': {wallets.id: values}
  /// }
  /// simply a json map with accounts and wallets as keys.
  /// values in our system is another map with id as key,
  /// other systems could use list or whatever.
  Map<String, Map<String, dynamic>> structureForExport(Account? account) => {
        'accounts': accountsForExport(account),
        'wallets': walletsForExport(account),
      };

  Map<String, dynamic> accountsForExport(Account? account) => {
        for (var account
            in account != null ? [account] : res.accounts.data) ...{
          account.accountId: {
            'name': account.name,
            'net': account.net.toString()
          }
        }
      };

  Map<String, dynamic> walletsForExport(Account? account) => {
        for (var wallet
            in account != null ? account.wallets : res.wallets.data) ...{
          if (wallet.cipher != null)
            wallet.walletId: {
              'accountId': wallet.accountId,
              'secret': wallet.secret(wallet.cipher!), // if
              'type': typeForExport(wallet),
              'cipherUpdate': wallet.cipherUpdate.toMap,
            }
        }
      };

  String typeForExport(Wallet wallet) => wallet is LeaderWallet
      ? exportedLeaderType
      : wallet is SingleWallet
          ? exportedSingleType
          : throw ArgumentError('Wallet must be leader or single');
}
