import 'dart:developer';

import 'package:civgen/shared/chip.dart';
import 'package:civgen/shared/helpers.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

enum CivStatus { available, selected, banned, picked }

// Component for showing a grid of civs that requires a list of NationChip objects
class CivGrid extends StatelessWidget {
  final Map<String, CivStatus> civStatuses;
  final Function onChipPressed;

  const CivGrid({super.key, required this.civStatuses, required this.onChipPressed});

  List<NationChip> generateNationChips(Map<String, CivStatus> civStatuses, Function onChipPressed) {
    List<NationChip> chips = [];

    // TODO: This is super innefficient, we should be able to just update the civStatuses
    civStatuses.forEach((leaderName, status) {
      chips.add(NationChip(
        leaderName: leaderName,
        nationIcon: leaderName,
        onChipPressed: () => onChipPressed(leaderName),
        chipIsHighlighted: status == CivStatus.selected,
        chipIsBanned: status == CivStatus.banned,
        chipIsPicked: status == CivStatus.picked,
      ));
    });
    log("Generated ${chips.length} chips...");
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ResponsiveGridList(
        shrinkWrap: true,
        minItemWidth: 256,
        horizontalGridSpacing: 16,
        verticalGridSpacing: 16,
        children: generateNationChips(civStatuses, onChipPressed),
      ),
    );
  }
}
