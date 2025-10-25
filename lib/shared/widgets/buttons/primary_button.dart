import 'package:flutter/material.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, this.text, this.onPressed, this.isLoading = false, this.isFullWidth = true, this.icon, this.color});
  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? color;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: widget.isLoading == true ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: widget.color),
        child: widget.isLoading == true
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[Icon(widget.icon, size: 20), const SizedBox(width: 8)],
                  Text(widget.text ?? 'Button'),
                ],
              ),
      ),
    );
  }
}
