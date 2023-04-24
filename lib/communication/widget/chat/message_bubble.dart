import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.userName,
    required this.isLocalUser,
    Key? key,
  }) : super(key: key);
  final String message;
  final String userName;
  final bool isLocalUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isLocalUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isLocalUser
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isLocalUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isLocalUser
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: isLocalUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLocalUser
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                    textAlign: isLocalUser ? TextAlign.end : TextAlign.start,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isLocalUser
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1!.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Positioned(
        //   top: 0,
        //   left: isLocalUser ? null : 120,
        //   right: isLocalUser ? 120 : null,
        //   child: CircleAvatar(
        //     backgroundImage: NetworkImage(userImage),
        //   ),
        // ),
      ], //To remove the overflow boundry of each bubble.
    );
  }
}
