import 'package:civgen/shared/chip.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:civgen/globals.dart';

class BansPage extends StatefulWidget {
  const BansPage({super.key});

  @override
  State<BansPage> createState() => _BansPageState();
}

class _BansPageState extends State<BansPage> {
  @override
  Widget build(BuildContext context) {
    return BansText();
  }
}

class BansText extends StatefulWidget {
  const BansText({super.key});

  @override
  State<BansText> createState() => _BansTextState();
}

class _BansTextState extends State<BansText> {
  @override
  Widget build(BuildContext context) {
    Padding test = nationChip('the wife, susan', 'Icon_civilization_america.webp');

    return MaterialApp(
      title: 'bans',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ban me'),
        ),
        body: Center(
          child: test,
        ),
      ),
    );
  }
}
