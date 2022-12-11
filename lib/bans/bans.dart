import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BansPage extends StatefulWidget {
  const BansPage({super.key});

  @override
  State<BansPage> createState() => _BansPageState();
}

class _BansPageState extends State<BansPage> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class BansText extends StatelessWidget {
  const BansText({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bans',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ban me'),
        ),
        body: const Center(
          child: Text('ban me papi'),
        ),
      ),
    );
  }
}
