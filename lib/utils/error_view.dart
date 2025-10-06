
import 'package:flutter/Material.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;
  const ErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Error: $errorMessage"));
  }
}
