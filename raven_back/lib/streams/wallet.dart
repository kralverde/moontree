import 'package:raven_back/raven_back.dart';
import 'package:rxdart/rxdart.dart';

class WalletStreams {
  final leaderChanges = leaderChanges$;
  final singleChanges = singleChanges$;
  final deriveAddress = BehaviorSubject<DeriveLeaderAddress?>.seeded(null);
}

final Stream<Change<Wallet>> leaderChanges$ =
    res.wallets.changes.where((change) => change.data is LeaderWallet);

final Stream<Change<Wallet>> singleChanges$ =
    res.wallets.changes.where((change) => change.data is SingleWallet);

class DeriveLeaderAddress {
  final LeaderWallet leader;
  final NodeExposure? exposure;

  DeriveLeaderAddress({required this.leader, this.exposure});
}
