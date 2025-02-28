import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart' show hex;
import 'package:ravencoin_wallet/ravencoin_wallet.dart' show WalletBase, ECPair;
import 'package:ravencoin_wallet/ravencoin_wallet.dart' as rc;

extension ExtendedWalletBase on WalletBase {
  Uint8List get outputScript {
    return rc.Address.addressToOutputScript(address!, network)!;
  }

  String get scripthash {
    var digest = sha256.convert(outputScript);
    var hash = digest.bytes.reversed.toList();
    return hex.encode(hash);
  }

  ECPair get keyPair {
    return ECPair.fromWIF(wif!, networks: rc.networks);
  }
}
