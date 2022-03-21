import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double _kChoiceChipsHeight = 40.0;

class ChipData {
  const ChipData(this.label, [this.iconData]);
  final String label;
  final IconData iconData;
}

class ChipStyle {
  const ChipStyle(
      {this.backgroundColor,
      this.textStyle,
      this.iconColor,
      this.iconSize,
      this.labelPadding,
      this.elevation});
  final Color backgroundColor;
  final TextStyle textStyle;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry labelPadding;
  final double elevation;
}

class FlutterFlowChoiceChips extends StatefulWidget {
  const FlutterFlowChoiceChips({
    this.initiallySelected,
    @required this.options,
    @required this.onChanged,
    this.selectedChipStyle,
    this.unselectedChipStyle,
    this.chipSpacing,
    this.multiselect,
    this.initialized = true,
  });

  final List<String> initiallySelected;
  final List<ChipData> options;
  final void Function(List<String>) onChanged;
  final ChipStyle selectedChipStyle;
  final ChipStyle unselectedChipStyle;
  final double chipSpacing;
  final bool multiselect;
  final bool initialized;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  List<String> choiceChipValues;

  @override
  void initState() {
    super.initState();
    choiceChipValues = widget.initiallySelected ?? [];
    if (!widget.initialized && choiceChipValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => widget.onChanged(choiceChipValues),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        height: _kChoiceChipsHeight,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: widget.options.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final option = widget.options[index];
            final selected = choiceChipValues.contains(option.label);
            final style = selected
                ? widget.selectedChipStyle
                : widget.unselectedChipStyle;
            return ChoiceChip(
              selected: selected,
              onSelected: (isSelected) {
                if (isSelected) {
                  widget.multiselect
                      ? choiceChipValues.add(option.label)
                      : choiceChipValues = [option.label];
                  widget.onChanged(choiceChipValues);
                  setState(() {});
                } else {
                  if (widget.multiselect) {
                    choiceChipValues.remove(option.label);
                    widget.onChanged(choiceChipValues);
                    setState(() {});
                  }
                }
              },
              label: Text(
                option.label,
                style: style.textStyle,
              ),
              labelPadding: style.labelPadding,
              avatar: option.iconData != null
                  ? FaIcon(
                      option.iconData,
                      size: style.iconSize,
                      color: style.iconColor,
                    )
                  : null,
              elevation: style.elevation,
              selectedColor:
                  selected ? widget.selectedChipStyle.backgroundColor : null,
              backgroundColor:
                  selected ? null : widget.unselectedChipStyle.backgroundColor,
            );
          },
          separatorBuilder: (_, __) => SizedBox(width: widget.chipSpacing),
        ),
      );
}
