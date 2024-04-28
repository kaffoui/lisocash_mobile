import 'package:flutter/material.dart';

class NRadioButtonWidget<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final String? leading;
  final IconData? leadingIcon;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const NRadioButtonWidget({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.leading,
    this.title,
    this.leadingIcon,
  });

  @override
  State<NRadioButtonWidget<T>> createState() => _NRadioButtonWidgetState<T>();
}

class _NRadioButtonWidgetState<T> extends State<NRadioButtonWidget<T>> {
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final title = this.widget.title;
    theme = Theme.of(context);
    return InkWell(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(width: 12),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = widget.value == widget.groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColor : null,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? theme.primaryColor : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: widget.leading != null
          ? Text(
              "${widget.leading}",
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600]!,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          : widget.leadingIcon != null
              ? Icon(
                  widget.leadingIcon,
                  color: isSelected ? Colors.white : Colors.grey[600]!,
                  size: 18,
                )
              : Container(),
    );
  }
}
