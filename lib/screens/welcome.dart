import 'package:flutter/material.dart';
import 'join.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
    const WelcomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Stack(
                children: [
                    Positioned.fill(
                        child: Image.asset(
                            'assets/images/login_background_2.jpg',
                            fit: BoxFit.cover,
                        ),
                    ),

                    Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Image.asset(
                                    'assets/images/nike_logo.png',
                                    height: 250,
                                    color: Colors.white,
                                ),
                            ],
                        )
                    ),

                    SafeArea(
                        child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                                children: [
                                    const Spacer(),

                                    Row(
                                        children: [
                                            Expanded(
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white,
                                                        foregroundColor: Colors.black,
                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                        shape: const StadiumBorder(),
                                                        elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                fullscreenDialog: true,
                                                                builder: (context) => const JoinScreen()
                                                            ),
                                                        );
                                                    },
                                                    child: const Text(
                                                        'Join',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                        )
                                                    ),
                                                ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: OutlinedButton(
                                                    style: OutlinedButton.styleFrom(
                                                        foregroundColor: Colors.white,
                                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                                        side: const BorderSide(color: Colors.white, width: 1.5),
                                                        shape: const StadiumBorder(),
                                                    ),
                                                    onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                fullscreenDialog: true,
                                                                builder: (context) => const LoginScreen()
                                                            ),
                                                        );
                                                    },
                                                    child: const Text(
                                                        'Log In',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                        )
                                                    ),
                                                ),
                                            ),
                                        ],
                                    )
                                ],
                            )
                        ),
                    )
                ],
            )
        );
    }
}