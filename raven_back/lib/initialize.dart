import 'package:bip39/bip39.dart' as bip39;
import 'package:raven_electrum_client/raven_electrum_client.dart';
import 'models/account.dart';
import 'package:raven/records/net.dart';
import 'env.dart' as env;
import 'boxes.dart';
import 'listener.dart';
import 'accounts.dart';

Future setup() async {
  await Truth.instance.open();
  await Truth.instance.clear();
  await Accounts.instance.load();
}

void listenTo(RavenElectrumClient client) {
  var listen = ElectrumListener(client);
  listen.toAccounts();
  listen.toNodes();
  listen.toUnspents();
}

Future<RavenElectrumClient> init([List<String>? phrases]) async {
  await setup();
  var client = await RavenElectrumClient.connect('testnet.rvn.rocks');
  listenTo(client);
  phrases = phrases ?? [await env.getMnemonic()];
  for (var phrase in phrases) {
    var account = Account(bip39.mnemonicToSeed(phrase),
        cipher: Accounts.instance.cipher, net: Net.Test);
    await Truth.instance.saveAccount(account);
    await Truth.instance.unspents
        .watch()
        .skipWhile((element) =>
            element.key !=
                '0d78acdf5fe186432cbc073921f83bb146d72c4a81c6bde21c3003f48c15eb38' &&
            element.key !=
                'c22b0d7d99e5b41546518d38447b011bb3a4b9a75724558794c07db640b57ed4')
        .take(1)
        .toList();
  }
  return client;
}
