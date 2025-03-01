import 'package:flutter/material.dart';

void showOverlay(BuildContext context, Widget Function(VoidCallback) builder) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        ModalBarrier(
          color: Colors.black54,
          dismissible: true,
          onDismiss: () {
            overlayEntry.remove();
          },
        ),
        Center(
          child: builder(() => overlayEntry.remove()),
        ),
      ],
    ),
  );

  overlay.insert(overlayEntry);
}

class CardOverlay extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;

  const CardOverlay({super.key, required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Center(child: child),
      ],
    );
  }
}
