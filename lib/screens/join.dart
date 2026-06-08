import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
    const JoinScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Join'),
            ),
            body: const Center(
                child: Text('Join page'),
            ),
        );
    }
}