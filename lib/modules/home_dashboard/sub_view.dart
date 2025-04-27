import 'package:flutter/material.dart';

class SubView extends StatelessWidget {
  const SubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        title: const Text('SubView'),
      ),
      body: const Center(
        child: Text('This is a SubView'),
      ),
    );
  }
}
