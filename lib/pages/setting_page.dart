import 'package:flutter/material.dart';
import 'package:flutter_crawl/components/scaffold.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SettingDetail(),
    );
  }
}

class SettingDetail extends StatelessWidget {
  const SettingDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Setting"),
      ],
    );
  }
}
