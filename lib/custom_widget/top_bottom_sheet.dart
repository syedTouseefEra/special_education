import 'package:flutter/material.dart';

class CustomTopView extends StatelessWidget {
  const CustomTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                'Top Sheet',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: Text(
                  'This is a custom view shown from the top with animation.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomTopSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation1, animation2) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: CustomTopView(),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1), // start above screen
          end: Offset.zero,           // slide down to position
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );
}
