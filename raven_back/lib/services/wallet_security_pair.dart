import 'package:equatable/equatable.dart';

import 'package:raven_back/raven_back.dart';

class WalletSecurityPair with EquatableMixin {
  final Wallet wallet;
  final Security security;

  WalletSecurityPair({required this.wallet, required this.security});

  @override
  List<Object?> get props => [wallet, security];
}

Set<WalletSecurityPair> securityPairsFromVoutChanges(List<Change> changes) {
  return changes.fold({}, (set, change) {
    Vout vout = change.data;
    if (vout.wallet != null) {
      return set
        ..add(WalletSecurityPair(
            wallet: vout.wallet!,
            security: vout.security ?? res.securities.RVN));
    }
    return set;
  });
}

Set<WalletSecurityPair> securityPairsFromVouts(List<Vout> vouts) {
  return {
    for (var vout in vouts)
      if (vout.wallet != null)
        WalletSecurityPair(
            wallet: vout.wallet!, security: vout.security ?? res.securities.RVN)
  };
}
