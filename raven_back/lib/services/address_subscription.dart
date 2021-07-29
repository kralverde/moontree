import 'dart:async';

import 'package:quiver/iterables.dart';
import 'package:raven/models/balance.dart';
import 'package:raven/records/node_exposure.dart';
import 'package:raven_electrum_client/raven_electrum_client.dart';

import '../buffer_count_window.dart';
import '../models.dart';
import '../reservoir/reservoir.dart';

class ScripthashRow {
  final Address address;
  final ScripthashBalance balance;
  final List<ScripthashHistory> history;
  final List<ScripthashUnspent> unspent;

  ScripthashRow(this.address, this.balance, this.history, this.unspent);
}

class ScripthashData {
  final List<Address> addresses;
  final List<ScripthashBalance> balances;
  final List<List<ScripthashHistory>> histories;
  final List<List<ScripthashUnspent>> unspents;

  ScripthashData(this.addresses, this.balances, this.histories, this.unspents);

  Iterable<ScripthashRow> get zipped =>
      zip([addresses, balances, histories, unspents]).map((e) => ScripthashRow(
          e[0] as Address,
          e[1] as ScripthashBalance,
          e[2] as List<ScripthashHistory>,
          e[3] as List<ScripthashUnspent>));
}

class AddressSubscriptionService {
  Reservoir accounts;
  Reservoir addresses;
  Reservoir histories;
  RavenElectrumClient client;

  StreamController<Address> addressesNeedingUpdate = StreamController();

  AddressSubscriptionService(
      this.accounts, this.addresses, this.histories, this.client);

  void init() {
    addressesNeedingUpdate.stream
        .bufferCountTimeout(10, Duration(milliseconds: 50))
        .listen((changedAddresses) async {
      saveScripthashData(await getScripthashData(changedAddresses));
      maybeDeriveNewAddresses(changedAddresses);
    });

    addresses.changes.listen((change) {
      change.when(added: (added) {
        Address address = added.data;
        addressNeedsUpdating(address);
        setupAddressSubscription(address);
      }, updated: (updated) {
        // pass - see initialize.dart
      }, removed: (removed) {
        // pass - see initialize.dart
      });
    });
  }

  void addressNeedsUpdating(Address address) {
    addressesNeedingUpdate.sink.add(address);
  }

  void setupAddressSubscription(Address address) {
    var stream = client.subscribeScripthash(address.scripthash);
    stream.listen((status) {
      addressNeedsUpdating(address);
    });
  }

  Future<ScripthashData> getScripthashData(
      List<Address> changedAddresses) async {
    var scripthashes =
        changedAddresses.map((address) => address.scripthash).toList();
    // ignore: omit_local_variable_types
    List<ScripthashBalance> balances = await client.getBalances(scripthashes);
    // ignore: omit_local_variable_types
    List<List<ScripthashHistory>> histories =
        await client.getHistories(scripthashes);
    // ignore: omit_local_variable_types
    List<List<ScripthashUnspent>> unspents =
        await client.getUnspents(scripthashes);
    return ScripthashData(changedAddresses, balances, histories, unspents);
  }

  void saveScripthashData(ScripthashData data) async {
    data.zipped.forEach((row) {
      var address = row.address;
      address.balance = Balance.fromScripthashBalance(row.balance);
      addresses.save(address.scripthash);
      // TODO:
      // does this overwrite what has already been added automatically?
      // also, we need to combine histories and unspents before adding
      histories.addAll(combineHistoryAndUnspents(row));
    });
  }

  List combineHistoryAndUnspents(ScripthashRow row) {
    var newHistories = [];
    for (var i = 0; i < row.history.length; i++) {
      newHistories.add(History.fromRowAndIndex(row, i));
    }
    return newHistories;
  }

  void maybeDeriveNewAddresses(List<Address> changedAddresses) async {
    for (var address in changedAddresses) {
      Account account = accounts.data[address.accountId];
      maybeDeriveNextAddress(account, NodeExposure.Internal);
      maybeDeriveNextAddress(account, NodeExposure.External);
    }
  }

  void maybeDeriveNextAddress(Account account, NodeExposure exposure) {
    var hdIndex = addresses.indices['account-exposure']!
        .size('${account.accountId}:$exposure');
    var newAddress =
        account.maybeDeriveNextAddress(histories, hdIndex, exposure);
    if (newAddress != null) {
      addresses.add(newAddress);
    }
  }
}
