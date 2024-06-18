import 'package:flutter/material.dart';

class UserProfileIcon extends StatelessWidget {
  final String? imageUrl;
  final Icon? icon;
  final Color backgroundColor;

  const UserProfileIcon({
    super.key,
    this.imageUrl,
    this.backgroundColor = Colors.blue,
    this.icon = const Icon(
      Icons.person,
      color: Colors.white,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: imageUrl != null
            ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                ),
              )
            : icon,
      ),
    );
  }
}
