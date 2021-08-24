// dart --no-sound-null-safety test test/raven_tx_test.dart
import 'dart:io';

import 'package:bip39/bip39.dart' as bip39;
import 'package:hive/hive.dart';
import 'package:reservoir/reservoir.dart';
import 'package:raven_electrum_client/raven_electrum_client.dart';

import 'package:raven/init/hive_helper.dart';
import 'package:raven/services/service.dart';
import 'package:raven/utils/env.dart' as env;
import 'package:raven/records/wallets/leader.dart';
import 'package:raven/records/net.dart';
import 'package:raven/init/reservoirs.dart';
import 'package:raven/init/waiters.dart';

class Generated {
  late String phrase;
  late LeaderWallet wallet;
  late RavenElectrumClient client;
  late Map<String, Reservoir> reservoirs;
  late Map<String, Service> services;
  Generated(
      this.phrase, this.wallet, this.client, this.reservoirs, this.services);
  Generated.asEmpty(); // workaround to: tests complain it's uninitialized...?
}

Future hiveSetup() async {
  await deleteDatabase();
  Hive.init('database');
  await HiveHelper.init();
}

Future closeHive() async {
  await HiveHelper.close();
  await deleteDatabase();
}

Future deleteDatabase() async {
  try {
    await Directory('database').delete(recursive: true);
  } catch (e) {
    print('database folder not found');
  }
}

//Future waitForSave() async {
//  await Truth.instance.unspents
//      .watch()
//      .skipWhile((element) =>
//          element.key !=
//          '0d78acdf5fe186432cbc073921f83bb146d72c4a81c6bde21c3003f48c15eb38')
//      .take(1)
//      .toList();
//}

Future<Generated> generate() async {
  await hiveSetup();
  makeReservoirs();
  var reservoirs = {
    'accounts': accounts,
    'wallets': wallets,
    'addresses': addresses,
    'histories': histories
  } as Map<String, Reservoir>;
  var client =
      await RavenElectrumClient.connect('testnet.rvn.rocks', port: 50002);
  initServices(client);
  var services = {
    'addressDerivationService': addressDerivationService as Service,
    'addressSubscriptionService': addressSubscriptionService as Service,
    'addressesService': addressesService as Service,
    'accountBalanceService': accountBalanceService as Service,
    'exchangeRateService': exchangeRateService as Service,
  };
  var phrase = await env.getMnemonic();
  var wallet = LeaderWallet(seed: bip39.mnemonicToSeed(phrase));
  reservoirs['wallets']!.save(wallet);
  //waitForSave();
  return Generated(phrase, wallet, client, reservoirs, services);
}

//Future<Generated> generateFromMemory() async {
//  var truth = memory.Truth.instance;
//  var account = Account(ravencoinTestnet, seed: truth.boxes['accounts']['seed']);
//  var client = await ElectrumClient.connect('testnet.rvn.rocks');
//  await truth.saveAccount(account);
//  await account.deriveNodes(client);
//  await truth.saveAccountBalance(account);
//  return Generated(phrase, account, client);
//}
