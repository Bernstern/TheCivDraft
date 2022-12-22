// Component that takes in a duration and a callback for when it expires and returns a widget that displays the time remaining
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class TimerWidget extends StatelessWidget {
  final int durationSeconds;
  final Function onTimerExpired;
  final int startTime = DateTime.now().millisecondsSinceEpoch;

  TimerWidget({super.key, required this.durationSeconds, required this.onTimerExpired});

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      endTime: startTime + durationSeconds * 1000,
      onEnd: () => onTimerExpired(),
      widgetBuilder: (_, time) {
        if (time == null) {
          // Hack to get around updating the state of the parent
          return const Text(
            "0:00",
            style: TextStyle(fontSize: 24),
          );
        }
        return Text(
          "${time.min ?? 0}:${time.sec.toString().padLeft(2, "0")}",
          style: const TextStyle(fontSize: 24),
        );
      },
    );
  }
}
