import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';

/// ProfileHeader - Hiển thị avatar, tên, email
class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          // === AVATAR ===
          _buildAvatar(),

          const SizedBox(height: 16),

          // === TÊN ===
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // === EMAIL ===
          Text(
            user.email,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 4),

          // === PHONE ===
          if (user.phone != null && user.phone!.isNotEmpty)
            Text(
              user.phone!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

          const SizedBox(height: 12),

        ],
      ),
    );
  }

  /// Widget avatar
  Widget _buildAvatar() {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      // Có avatar URL
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(user.avatarUrl!),
        onBackgroundImageError: (_, __) {},
        child: user.avatarUrl == null
            ? Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        )
            : null,
      );
    }

    // Không có avatar - hiển thị initials
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blue,
      child: Icon(Icons.person, size: 50, color: Colors.white,)
    );
  }

}