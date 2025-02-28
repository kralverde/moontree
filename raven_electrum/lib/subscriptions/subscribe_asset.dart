import '../client/subscribing_client.dart';
import '../raven_electrum.dart';

extension SubscribeAssetMethod on RavenElectrumClient {
  Stream<String?> subscribeAsset(String assetName) {
    var methodPrefix = 'blockchain.asset';

    // If this is the first time, register
    registerSubscribable(methodPrefix, 1);

    return subscribe(methodPrefix, [assetName]).asyncMap((item) => item);
  }
}
