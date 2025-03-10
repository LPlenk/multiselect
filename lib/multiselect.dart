library multiselect;

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class _TheState {}

var _theState = RM.inject(() => _TheState());

class _SelectRow extends StatelessWidget {
  final Function(bool) onChange;
  final bool selected;
  final String text;

  const _SelectRow(
      {Key? key,
      required this.onChange,
      required this.selected,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChange(!selected);
        _theState.notify();
      },
      child: Container(
        height: kMinInteractiveDimension,
        child: Row(
          children: [
            Checkbox(
                value: selected,
                onChanged: (x) {
                  onChange(x!);
                  _theState.notify();
                }),
            Text(text, overflow: TextOverflow.ellipsis)
          ],
        ),
      ),
    );
  }
}

///
/// A Dropdown multiselect menu
///
///
class DropDownMultiSelect extends StatefulWidget {
  /// The options form which a user can select
  final List<String> options;

  /// Selected Values
  final List<String> selectedValues;

  /// This function is called whenever a value changes
  final Function(List<String>) onChanged;

  /// defines whether the field is dense
  final bool isDense;

  /// defines whether the widget is enabled;
  final bool enabled;

  /// Input decoration
  final InputDecoration? decoration;

  /// this text is shown when there is no selection
  final String? whenEmpty;

  /// a function to build custom childern
  final Widget Function(List<String> selectedValues)? childBuilder;

  /// a function to build custom menu items
  final Widget Function(String option)? menuItembuilder;

  /// a function to validate
  final String Function(String? selectedOptions)? validator;

  /// defines whether the widget is read-only
  final bool readOnly;

  /// defines whether the dropdown is expandable
  final bool isExpanded;

  /// icon shown on the right side of the field
  final Widget? icon;

  /// Textstyle for the hint
  final TextStyle? hintStyle;

  /// hint to be shown when there's nothing else to be shown
  final Widget? hint;

  const DropDownMultiSelect({
    Key? key,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.whenEmpty,
    this.icon,
    this.hint,
    this.hintStyle,
    this.childBuilder,
    this.menuItembuilder,
    this.isDense = true,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.readOnly = false,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  _DropDownMultiSelectState createState() => _DropDownMultiSelectState();
}

class _DropDownMultiSelectState extends State<DropDownMultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: DropdownButtonFormField<String>(
          decoration: widget.decoration != null
              ? widget.decoration!.copyWith(
                  hintText: widget.selectedValues.length > 0
                      ? widget.selectedValues.reduce((a, b) => a + ', ' + b)
                      : widget.whenEmpty ?? '')
              : InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: false,
                ),
          isDense: widget.isDense,
          isExpanded: widget.isExpanded,
          onChanged: widget.enabled ? (x) {} : null,
          value: null,
          items: widget.options
              .map((x) => DropdownMenuItem(
                    child: _theState.rebuild(() {
                      return widget.menuItembuilder != null
                          ? widget.menuItembuilder!(x)
                          : _SelectRow(
                              selected: widget.selectedValues.contains(x),
                              text: x,
                              onChange: (isSelected) {
                                if (isSelected) {
                                  var ns = widget.selectedValues;
                                  ns.add(x);
                                  widget.onChanged(ns);
                                } else {
                                  var ns = widget.selectedValues;
                                  ns.remove(x);
                                  widget.onChanged(ns);
                                }
                              },
                            );
                    }),
                    value: x,
                    onTap: () {
                      if (widget.selectedValues.contains(x)) {
                        var ns = widget.selectedValues;
                        ns.remove(x);
                        widget.onChanged(ns);
                      } else {
                        var ns = widget.selectedValues;
                        ns.add(x);
                        widget.onChanged(ns);
                      }
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
