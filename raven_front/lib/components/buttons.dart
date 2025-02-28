import 'package:flutter/material.dart';
import 'package:raven_front/components/components.dart';
import 'package:raven_front/theme/extensions.dart';

class ButtonComponents {
  IconButton back(BuildContext context) => IconButton(
      icon: components.icons.back, onPressed: () => Navigator.pop(context));

  GestureDetector settings(BuildContext context /*, Function setStateFn*/) =>
      GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/settings'),
          child: Icon(Icons.more_vert));

  BottomAppBar bottomNav(BuildContext context) => BottomAppBar(
          child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            IconButton(
                onPressed: () {/*to wallet*/},
                icon: Icon(Icons.account_balance_wallet_rounded,
                    color: Theme.of(context).primaryColor)),
            IconButton(
                onPressed: () {/*to trading*/}, icon: Icon(Icons.swap_horiz))
          ]));

  ElevatedButton receive(BuildContext context, {String symbol = 'RVN'}) =>
      ElevatedButton.icon(
          icon: Icon(Icons.south_east),
          label: Text('Receive'),
          onPressed: () => Navigator.pushNamed(context, '/transaction/receive',
              arguments: {'symbol': symbol}),
          style: components.styles.buttons.leftSideCurved);

  ElevatedButton send(
    BuildContext context, {
    String symbol = 'RVN',
    bool disabled = false,
    String? walletId,
  }) =>
      ElevatedButton.icon(
          icon: Icon(Icons.north_east),
          label: Text('Send'),
          onPressed: disabled
              ? () {}
              : () => Navigator.pushNamed(context, '/transaction/send',
                  arguments: {'symbol': symbol}),
          style: components.styles.buttons
              .rightSideCurved(context, disabled: disabled));

  ElevatedButton getRVN(BuildContext context) => ElevatedButton(
        onPressed: () {/* link to coinbase */},
        child: Text('get RVN', style: Theme.of(context).textTheme.headline2),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).good)),
      );
}
