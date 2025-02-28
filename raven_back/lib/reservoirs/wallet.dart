import 'package:collection/collection.dart';
import 'package:raven_back/services/wallet/constants.dart';
import 'package:raven_back/extensions/object.dart';
import 'package:reservoir/reservoir.dart';

import 'package:raven_back/records/records.dart';

part 'wallet.keys.dart';

class WalletReservoir extends Reservoir<_IdKey, Wallet> {
  // final CipherRegistry cipherRegistry;
  late IndexMultiple<_AccountKey, Wallet> byAccount;
  late IndexMultiple<_WalletTypeKey, Wallet> byWalletType;

  WalletReservoir() : super(_IdKey()) {
    byAccount = addIndexMultiple('account', _AccountKey());
    byWalletType = addIndexMultiple('walletType', _WalletTypeKey());
  }

  List<LeaderWallet> get leaders => byWalletType
      .getAll(WalletType.leader)
      .map((wallet) => wallet as LeaderWallet)
      .toList();
  List<SingleWallet> get singles => byWalletType
      .getAll(WalletType.single)
      .map((wallet) => wallet as SingleWallet)
      .toList();
}
