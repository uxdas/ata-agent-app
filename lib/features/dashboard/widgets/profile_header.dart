import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.black),
        ),
        const SizedBox(width: 16),
        Text(
          'Добро пожаловать!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
