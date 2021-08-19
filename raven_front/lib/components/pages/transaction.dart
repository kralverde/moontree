import 'package:flutter/material.dart';
import 'package:raven_mobile/components/buttons.dart';
import 'package:raven_mobile/styles.dart';

PreferredSize header(context) => PreferredSize(
    preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.34),
    child: AppBar(
        elevation: 2,
        centerTitle: false,
        leading: RavenButton().back(context),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: RavenButton().settings(context))
        ],
        title: RavenText('Transaction Details').h2,
        flexibleSpace: Container(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            RavenIcon().getAssetAvatar('Magic Musk'),
            RavenText('Magic Musk').h1,
            RavenText('Received').h3,
          ]),
        )));

// perhaps this should be two tabs, one for tx details, one for metadata
ListView body() =>
    ListView(shrinkWrap: true, padding: EdgeInsets.all(20.0), children: <
        Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        RavenText('Date: June 26 2021').whisper,
        RavenText('Confirmaitons: 60+').whisper,
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        SizedBox(height: 15.0),
        TextField(
          readOnly: true,
          controller:
              TextEditingController(text: 'rtahoe5eu4e4ea451ea21e445euaeu454'),
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'To',
              hintText: 'Address'),
        ),
        SizedBox(height: 15.0),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: '500'),
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Amount',
              hintText: 'Quantity'),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          RavenText('fee').whisper,
          RavenText('0.01397191 RVN').whisper
        ]),
        SizedBox(height: 15.0),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: ':)'),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Note',
              hintText: 'Note to Self'),
        ),
        SizedBox(height: 15.0),
        RavenText('id: 1354s31e35s13f54se3851f3s51ef35s1ef35').whisper,
        SizedBox(height: 15.0),
        ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.description),
            label: RavenText('Metadata').h3)
      ])
    ]);
