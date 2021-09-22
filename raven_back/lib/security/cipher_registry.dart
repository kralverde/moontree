import 'dart:typed_data';

import 'package:quiver/iterables.dart';
import 'package:raven/records/cipher_type.dart';
import 'package:raven/records/cipher_update.dart';
import 'package:raven/security/cipher.dart';
import 'package:raven/security/cipher_none.dart';
import 'package:raven/security/cipher_aes.dart';
import 'package:raven/utils/exceptions.dart';
import 'package:raven/raven.dart';
import 'cipher.dart';

class CipherRegistry {
  final Map<CipherUpdate, Cipher> ciphers = {};
  static const latestCipherType = CipherType.AES;
  final Map<CipherType, Function> cipherInitializers = {
    CipherType.None: (Uint8List password) => CipherNone(),
    CipherType.AES: (Uint8List password) => CipherAES(password),
  };

  CipherRegistry();

  Cipher get currentCipher => ciphers[currentCipherUpdate]!;

  CipherUpdate get currentCipherUpdate =>
      CipherUpdate(latestCipherType, maxGlobalPasswordVersion());

  void initCiphers(
    Set<CipherUpdate> currentCipherUpdates, {
    Uint8List? password,
    String? altPassword,
  }) {
    password ??
        altPassword ??
        (() => throw OneOfMultipleMissing(
            'password or altPassword required to initialize ciphers.'))();
    password = password ?? Uint8List.fromList(altPassword!.codeUnits);
    for (var currentCipherUpdate in currentCipherUpdates) {
      registerCipher(currentCipherUpdate, password);
    }
  }

  int maxGlobalPasswordVersion() =>
      max([for (var cu in ciphers.keys) cu.passwordVersion]) ?? 0;

  //int maxPasswordVersion({CipherType latest = latestCipherType}) =>
  //    max([
  //      for (var cu in ciphers.keys
  //          .where((cipherUpdate) => cipherUpdate.cipherType == latest)
  //          .toList())
  //        cu.passwordVersion
  //    ]) ??
  //    0;

  CipherUpdate updatePassword(Uint8List password,
      {CipherType latest = latestCipherType}) {
    var update =
        CipherUpdate(latest, maxGlobalPasswordVersion(/*latest: latest*/) + 1);
    registerCipher(update, password);
    return update;
  }

  Cipher registerCipher(
    CipherUpdate cipherUpdate,
    Uint8List password,
  ) {
    ciphers[cipherUpdate] =
        cipherInitializers[cipherUpdate.cipherType]!(password);
    return ciphers[cipherUpdate]!;
  }

  /// make sure all wallets are on the latest ciphertype and password
  Future updateWallets() async {
    for (var wallet in wallets.data) {
      if (wallet.cipherUpdate != currentCipherUpdate) {
        if (wallet is LeaderWallet) {
          var reencrypt = EncryptedEntropy.fromEntropy(
            EncryptedEntropy(wallet.encrypted, wallet.cipher).entropy,
            ciphers[currentCipherUpdate]!,
          );
          assert(wallet.walletId == reencrypt.walletId);
          await wallets.save(LeaderWallet(
            walletId: reencrypt.walletId,
            accountId: wallet.accountId,
            encryptedEntropy: reencrypt.encryptedSecret,
            cipherUpdate: currentCipherUpdate,
          ));
        } else if (wallet is SingleWallet) {
          var reencrypt = EncryptedWIF.fromWIF(
            EncryptedWIF(wallet.encrypted, wallet.cipher).wif,
            ciphers[currentCipherUpdate]!,
          );
          assert(wallet.walletId == reencrypt.walletId);
          await wallets.save(SingleWallet(
            walletId: reencrypt.walletId,
            accountId: wallet.accountId,
            encryptedWIF: reencrypt.encryptedSecret,
            cipherUpdate: currentCipherUpdate,
          ));
        }
      }
    }

    /// completed successfully
    //assert(services.wallets.getPreviousCipherUpdates.isEmpty);
  }

  /// after wallets are updated or verified to be up to date
  /// remove all ciphers that no wallet uses
  void cleanupCiphers() {
    var walletCipherUpdates = services.wallets.getAllCipherUpdates;
    ciphers.removeWhere((key, value) => !walletCipherUpdates.contains(key));
    if (ciphers.length > 1) {
      // in theory a wallet is not updated ... error?
    }
  }
}
