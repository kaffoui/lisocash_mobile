// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';

import 'N_DisplayTextWidget.dart';

class MyThemeExtension extends ThemeExtension<MyThemeExtension> {
  final Color? dropDownBackColor;
  final Color? textInputBackColor;
  final String? defaultImageAssetPath;
  final String? defaultUserProfileImageAssetPath;
  final String? noDataImageAssetPath;
  final String? errorImageAssetPath;

  MyThemeExtension(
      {this.textInputBackColor = Colors.transparent,
      this.dropDownBackColor = Colors.transparent,
      this.defaultImageAssetPath = "Image",
      this.defaultUserProfileImageAssetPath = "Profil",
      this.noDataImageAssetPath,
      this.errorImageAssetPath});

  @override
  MyThemeExtension copyWith({
    Color? dropDownBackColor,
  }) {
    return MyThemeExtension(
      dropDownBackColor: dropDownBackColor ?? this.dropDownBackColor,
    );
  }

  @override
  ThemeExtension<MyThemeExtension> lerp(covariant ThemeExtension<MyThemeExtension>? other, double t) {
    if (other is! MyThemeExtension) {
      return this;
    }
    return MyThemeExtension(
      dropDownBackColor: Color.lerp(dropDownBackColor, other.dropDownBackColor, t) ?? Colors.white,
    );
  }
}

class NDropDownWidget extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  dynamic initialObject;
  final List<dynamic> listObjet;
  final Color? backColor, titleColor;
  final Border? border;
  final bool isObject, isDense, canSearch, canMultiSelected, isRequired;
  final Widget Function(dynamic value)? buildItem;
  final void Function(dynamic value)? onChangedDropDownValue;
  final String? title;
  final double? radius;

  NDropDownWidget({
    super.key,
    this.title,
    required this.initialObject,
    required this.listObjet,
    this.buildItem,
    this.onChangedDropDownValue,
    this.backColor,
    this.titleColor,
    this.isObject = false,
    this.isDense = true,
    this.isRequired = false,
    this.canSearch = false,
    this.canMultiSelected = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    this.padding,
    this.border,
    this.radius,
  });

  @override
  State<NDropDownWidget> createState() => _NDropDownWidgetState();
}

class _NDropDownWidgetState extends State<NDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    widget.initialObject = widget.listObjet.contains(widget.initialObject) ? widget.initialObject : widget.listObjet[0];
    final MyThemeExtension theme = Theme.of(context).extension<MyThemeExtension>() ?? MyThemeExtension();
    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          if (widget.title != null)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 16, top: 12),
                    child: widget.isRequired
                        ? RichText(
                            text: TextSpan(
                              text:
                                  "${widget.title!.substring(0, 1).toUpperCase()}${widget.title!.replaceFirst(widget.title!.substring(0, 1), "").replaceAll("_", " ").toLowerCase()}",
                              style: renderTextStyle(context: context, theme: BASE_TEXT_THEME.LABEL_MEDIUM),
                              children: const <TextSpan>[
                                TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red)),
                              ],
                            ),
                          )
                        : NDisplayTextWidget(
                            text:
                                "${widget.title!.substring(0, 1).toUpperCase()}${widget.title!.replaceFirst(widget.title!.substring(0, 1), "").replaceAll("_", " ").toLowerCase()}",
                            theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                            textColor: widget.titleColor,
                          ),
                  ),
                ),
              ],
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.backColor ?? theme.dropDownBackColor,
              border: widget.border ?? Border.all(color: Colors.black, width: 0.2),
              borderRadius: BorderRadius.circular(widget.radius ?? 10),
            ),
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: widget.initialObject,
                  isExpanded: true,
                  itemHeight: null,
                  focusColor: Colors.transparent,
                  onChanged: widget.onChangedDropDownValue,
                  isDense: true,
                  items: widget.listObjet
                      .map(
                        (itemObject) => DropdownMenuItem(
                          value: itemObject,
                          child: widget.buildItem != null
                              ? IgnorePointer(child: widget.buildItem!(itemObject))
                              : widget.isObject
                                  ? NDisplayTextWidget(
                                      text: "${itemObject.nom}", maxLines: 1, overflow: TextOverflow.ellipsis)
                                  : NDisplayTextWidget(
                                      text: " $itemObject", maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NDropDownModelWidget extends StatelessWidget {
  final bool isUserProfile;
  final String? imgLink, title;
  final IconData? iconData;

  const NDropDownModelWidget({
    super.key,
    this.imgLink,
    this.title,
    this.iconData,
    this.isUserProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (iconData != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                iconData,
                size: 18,
              ),
            ),
          if (imgLink != null)
            NDisplayImageWidget(
              width: 18,
              height: 18,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              imageLink: "$imgLink",
              fit: BoxFit.cover,
              isUserProfile: isUserProfile,
              isRounded: true,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            ),
          Expanded(
            child: NDisplayTextWidget(text: "$title", maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
