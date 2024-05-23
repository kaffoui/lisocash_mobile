// ignore_for_file: must_be_immutable

import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import '../constants/fonctions.dart';
import '../constants/styles.dart';
import 'N_DisplayTextWidget.dart';

class NTextInputWidget extends StatefulWidget {
  TextEditingController? textController;
  GlobalKey<FormFieldState>? validationKey;
  BASE_TEXT_THEME textTheme;
  Color? textColor;
  String? hint,
      hintLabel,
      title,
      valueType,
      value,
      codeTelephonique,
      codePays,
      suffixText,
      tooltip,
      selectedPays,
      subtitle;
  Widget? leftWidget, rightWidget;
  IconData? leftIcon, rightIcon;
  int? maxLength, minLength, minLines, maxLines;
  BuildContext? context;

  FocusNode? focusNode;
  List<String>? suggestionsList, initialTagSelectedList;
  void Function(dynamic value)? onSuggestionSelcted;
  ScrollController? scrollController;

  TextStyle? titleStyle, hintStyle, labelStyle;

  bool? isTelephone,
      isPassword,
      isEmail,
      isMultiline,
      isPrice,
      isLastInForm,
      isNumeric,
      isNumberSelector,
      isDateHeure,
      readOnly,
      isDate,
      isHeure,
      mayObscureText,
      mayCountTextSize,
      isRequired,
      isSmsCode,
      textIsInRight,
      isRounded,
      isHintAndLabel,
      isCountry,
      showCountryFlag,
      showUnderline;
  int minNumberSelector, maxNumberSelector;

  Color? backColor, hintLabelColor, hintColor, borderColor, titleColor;
  DateTime? initialDate;
  DateTime? firstDate;
  DateTime? lastDate;

  EdgeInsetsGeometry? margin, padding;
  double? radius;
  EdgeInsets? scrollingPadding;
  BoxBorder? border;
  final void Function(String value)? onChanged,
      getCodeTelephone,
      getCodePays,
      getSelectedPays,
      onFieldSubmitted,
      onSaved,
      onGetFocus,
      onLostFocus;
  void Function()? onTap;
  String? Function(String value)? onValidated;
  FontWeight? titleWeight;

  TextInputAction? textInputAction;

  NTextInputWidget({
    Key? key,
    this.textColor,
    this.textTheme = BASE_TEXT_THEME.BODY,
    this.onSuggestionSelcted,
    this.hint = '',
    this.hintLabel = '',
    this.title,
    this.valueType = '',
    this.value,
    this.leftIcon,
    this.rightIcon,
    this.leftWidget,
    this.rightWidget,
    this.subtitle,
    this.codePays = 'BJ',
    this.titleWeight,
    this.titleColor,
    this.initialTagSelectedList,
    this.codeTelephonique = '+229',
    this.minLength = 0,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.focusNode,
    this.textController,
    this.validationKey,
    this.border,
    this.showUnderline = false,
    this.mayCountTextSize = false,
    this.mayObscureText = false,
    this.margin,
    this.isRequired = false,
    this.isMultiline = false,
    this.isPassword = false,
    this.isTelephone = false,
    this.isNumeric = false,
    this.isNumberSelector = false,
    this.minNumberSelector = 0,
    this.maxNumberSelector = 10000,
    this.readOnly = false,
    this.isHintAndLabel = false,
    this.isEmail = false,
    this.isDateHeure = false,
    this.backColor,
    this.isPrice = false,
    this.isRounded = true,
    this.isLastInForm = false,
    this.isSmsCode = false,
    this.showCountryFlag = true,
    this.textIsInRight = false,
    this.isDate = false,
    this.isHeure = false,
    this.radius = 10,
    this.onChanged,
    this.hintColor,
    this.hintLabelColor,
    this.titleStyle,
    this.hintStyle,
    this.labelStyle,
    this.onFieldSubmitted,
    this.onTap,
    this.getCodeTelephone,
    this.getCodePays,
    this.suffixText,
    this.scrollingPadding,
    this.scrollController,
    this.tooltip,
    this.context,
    this.isCountry,
    this.selectedPays,
    this.borderColor,
    this.getSelectedPays,
    this.textInputAction,
    this.padding = const EdgeInsets.symmetric(vertical: 0),
    this.suggestionsList,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.onSaved,
    this.onValidated,
    this.onGetFocus,
    this.onLostFocus,
  })  : initialDate = initialDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime.now().add(Duration(days: -365)),
        lastDate = lastDate ?? DateTime.now();

  @override
  _NTextInputWidgetState createState() => _NTextInputWidgetState();
}

class _NTextInputWidgetState extends State<NTextInputWidget> {
  String errorMessage = "";
  String? codePays;
  List<String> filterdTagList = [];
  List<String> selectedTagList = [];
  List<String> suggestionsList = [];
  bool isEditting = false;

  bool mayObscureText = false;

  FocusNode focusNode = FocusNode();

  pickDateTime() {
    if ((widget.isDateHeure! == true || widget.isDate == true) && widget.readOnly == false) {
      Fonctions().selectedDate(
          contextDate: context,
          dateController: widget.textController!,
          initialDate: widget.initialDate,
          firstDate: widget.firstDate ?? DateTime.now().subtract(const Duration(days: 18250)),
          lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 18250)),
          onChangedDateController: (controller) {
            if (controller.text.isNotEmpty && widget.isDateHeure == true) {
              TextEditingController timeController = TextEditingController();
              Fonctions().selectedTime(
                  context: context,
                  timeController: timeController,
                  onSelectedTime: (timepiked) {
                    controller.text =
                        "${controller.text} ${timepiked.hour.toString().padLeft(2, '0')}:${timepiked.minute.toString().padLeft(2, '0')}:00";
                  });
            }
          });
    }
    if (widget.isHeure! == true && widget.readOnly == false) {
      Fonctions().selectedTime(
        context: context,
        timeController: widget.textController!,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    if (widget.isMultiline!) {
      setState(() {
        widget.maxLength = widget.maxLength ?? 1000;
      });
    }
    if (widget.isNumberSelector! == true) {
      setState(() {
        widget.isNumeric = true;
      });
    }
    setState(() {
      codePays = widget.codePays;
    });
    if (widget.isPassword == true) {
      mayObscureText = widget.mayObscureText!;
      widget.isMultiline = false;
    }
    if (widget.initialTagSelectedList != null) {
      selectedTagList.addAll(widget.initialTagSelectedList!);
    }
    if (widget.isDate == true) {
      setState(() {
        widget.initialDate = widget.initialDate ?? DateTime.now();
        widget.firstDate = widget.firstDate ?? DateTime.now().add(Duration(days: -365));
        widget.lastDate = widget.lastDate ?? DateTime.now();
        widget.textController!.text = widget.textController!.text.isNotEmpty
            ? DateFormat('yyyy-MM-dd').format(widget.initialDate!)
            : widget.textController!.text;
      });
    }
    if (widget.suggestionsList != null) {
      suggestionsList.clear();
      suggestionsList.addAll(widget.suggestionsList!);
    }
    if (widget.textController != null) {
      widget.textController!.addListener(() {
        setState(() {
          if (widget.validationKey != null) {
            widget.validationKey!.currentState!.validate();
            errorMessage = "";
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.initialDate);
    for (var element in selectedTagList) {
      suggestionsList.remove(element);
    }
    final theme = Theme.of(context);
    return Column(
      children: [
        if (widget.title != null)
          Row(
            children: [
              if (widget.title != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 16, top: 12),
                    child: widget.isRequired!
                        ? RichText(
                            text: TextSpan(
                              text:
                                  "${widget.title!.substring(0, 1).toUpperCase()}${widget.title!.replaceFirst(widget.title!.substring(0, 1), "").replaceAll("_", " ").toLowerCase()}",
                              style: renderTextStyle(
                                context: context,
                                theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                                fontWeight: widget.titleWeight,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                    text: '*',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400, color: Colors.red)),
                              ],
                            ),
                          )
                        : NDisplayTextWidget(
                            text:
                                "${widget.title!.substring(0, 1).toUpperCase()}${widget.title!.replaceFirst(widget.title!.substring(0, 1), "").replaceAll("_", " ").toLowerCase()}",
                            theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                            textColor: widget.titleColor,
                            fontWeight: widget.titleWeight,
                          ),
                  ),
                ),
            ],
          ),
        if (widget.subtitle != null)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 16, top: 12),
                  child: NDisplayTextWidget(
                    text:
                        "${widget.subtitle!.substring(0, 1).toUpperCase()}${widget.subtitle!.replaceFirst(widget.subtitle!.substring(0, 1), "").replaceAll("_", " ").toLowerCase()}",
                    theme: BASE_TEXT_THEME.LABEL_MEDIUM,
                    textColor: widget.titleColor,
                  ),
                ),
              ),
            ],
          ),
        Tooltip(
          message: widget.tooltip ?? "",
          textStyle: Style.defaultTextStyle(textColor: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.9)),
          child: Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: widget.margin ??
                (widget.hintLabel != null && widget.hintLabel!.isNotEmpty
                    ? const EdgeInsets.symmetric(vertical: 0)
                    : const EdgeInsets.symmetric(vertical: 4)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.backColor ?? Colors.transparent,
              borderRadius: widget.isMultiline == true
                  ? BorderRadius.circular(widget.radius ?? 12)
                  : BorderRadius.circular(widget.radius ?? 90),
              border: errorMessage.isNotEmpty
                  ? Border.all(
                      color: errorMessage.isNotEmpty
                          ? theme.colorScheme.error
                          : widget.borderColor ?? Colors.transparent,
                      width: 0.2)
                  : widget.border ?? Border.all(color: Colors.black, width: 0.3),
            ),
            child: widget.isCountry == true
                ? Container(
                    padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: CountryCodePicker(
                        padding: EdgeInsets.zero,
                        flagWidth: 20.0,
                        alignLeft: true,
                        showDropDownButton: true,
                        showFlag: true,
                        showCountryOnly: true,
                        textOverflow: TextOverflow.clip,
                        initialSelection: widget.selectedPays,
                        showOnlyCountryWhenClosed: true,
                        favorite: const ['+229'],
                        onChanged: (CountryCode countryCode) {
                          setState(() {
                            if (widget.getSelectedPays != null) {
                              widget.getSelectedPays!(countryCode.name!);
                            } else if (widget.getCodePays != null) {
                              widget.getCodePays!(countryCode.code!);
                            } else if (widget.getCodeTelephone != null) {
                              widget.getCodeTelephone!(countryCode.dialCode!);
                            } else {
                              widget.textController!.text = '${countryCode.name}';
                            }
                          });
                        }),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: widget.suggestionsList == null
                            ? Row(
                                children: [
                                  Container(
                                    margin: widget.margin ??
                                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    padding: widget.padding ??
                                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: widget.isTelephone == true
                                        ? CountryCodePicker(
                                            padding: EdgeInsets.zero,
                                            flagWidth: 16.0,
                                            showFlag: widget.showCountryFlag!,
                                            textOverflow: TextOverflow.clip,
                                            showDropDownButton: true,
                                            hideMainText: false,
                                            initialSelection: widget.selectedPays ?? "+229",
                                            favorite: const ['+229', '+226', '+228', '+33'],
                                            onInit: (CountryCode? countryCode) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((timeStamp) {
                                                if (widget.getSelectedPays != null) {
                                                  widget.getSelectedPays!(countryCode!.name!);
                                                }
                                                if (widget.getCodePays != null) {
                                                  widget.getCodePays!(countryCode!.code!);
                                                }
                                                if (widget.getCodeTelephone != null) {
                                                  widget.getCodeTelephone!(countryCode!.dialCode!);
                                                }
                                              });
                                            },
                                            onChanged: (CountryCode countryCode) {
                                              if (widget.getSelectedPays != null) {
                                                widget.getSelectedPays!(countryCode.name!);
                                              }
                                              if (widget.getCodePays != null) {
                                                widget.getCodePays!(countryCode.code!);
                                              }
                                              if (widget.getCodeTelephone != null) {
                                                widget.getCodeTelephone!(countryCode.dialCode!);
                                              }
                                            })
                                        : widget.leftIcon != null
                                            ? SizedBox(
                                                child: Icon(
                                                  widget.leftIcon,
                                                  size: 12,
                                                  color: theme.colorScheme.primary,
                                                ),
                                              )
                                            : widget.leftWidget,
                                  ),
                                  Expanded(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                          if (widget.onGetFocus != null) {
                                            widget.onGetFocus!(widget.textController!.text);
                                          }
                                        } else {
                                          if (widget.onLostFocus != null) {
                                            widget.onLostFocus!(widget.textController!.text);
                                          }
                                        }
                                      },
                                      child: TextFormField(
                                        autofocus: (widget.focusNode != null &&
                                            widget.focusNode!.hasFocus),
                                        focusNode: focusNode,
                                        controller: widget.textController,
                                        cursorColor: Colors.black,
                                        scrollController: widget.scrollController,
                                        textAlignVertical: TextAlignVertical.center,
                                        scrollPadding: widget.scrollingPadding ?? EdgeInsets.zero,
                                        key: widget.validationKey,
                                        style: renderTextStyle(
                                          context: context,
                                          textColor: widget.textColor,
                                          theme: widget.textTheme,
                                        ),
                                        minLines: widget.minLines ?? (widget.isMultiline! ? 5 : 1),
                                        maxLines: widget.maxLines ??
                                            (widget.isMultiline! ? (widget.maxLines) : 1),
                                        maxLength: widget.maxLength,
                                        textInputAction: widget.textInputAction,
                                        onFieldSubmitted: (value) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          if (widget.onFieldSubmitted != null) {
                                            widget.onFieldSubmitted!(value);
                                          }
                                        },
                                        /* toolbarOptions:
                                          const ToolbarOptions(copy: false, paste: false, cut: false, selectAll: true
                                              //by default all are disabled 'false'
                                              ),*/
                                        textAlign: widget.isMultiline == true
                                            ? TextAlign.start
                                            : widget.textIsInRight!
                                                ? TextAlign.right
                                                : TextAlign.left,
                                        readOnly: widget.isDateHeure! ||
                                            widget.isDate! ||
                                            widget.isHeure! ||
                                            widget.readOnly!,
                                        textCapitalization: TextCapitalization.sentences,
                                        inputFormatters: widget.isTelephone == true
                                            ? <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(RegExp(r'\d')),
                                              ]
                                            : widget.isNumeric == true || widget.isPrice == true
                                                ? <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp(r'(^\d*\.?\d*)')),
                                                  ]
                                                : null,
                                        keyboardType: widget.isEmail!
                                            ? TextInputType.emailAddress
                                            : widget.isTelephone!
                                                ? TextInputType.phone
                                                : widget.isNumeric! || widget.isPrice!
                                                    ? TextInputType.number
                                                    : null,
                                        obscureText: mayObscureText,
                                        buildCounter: (BuildContext context,
                                            {int? currentLength, int? maxLength, bool? isFocused}) {
                                          return widget.mayCountTextSize == true
                                              ? NDisplayTextWidget(
                                                  text: "$currentLength / $maxLength",
                                                  theme: BASE_TEXT_THEME.LABEL_SMALL)
                                              : null;
                                        },
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: widget.showUnderline!
                                                ? BorderSide(width: 1.5)
                                                : BorderSide.none,
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: widget.showUnderline!
                                                ? BorderSide(width: 1.5)
                                                : BorderSide.none,
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: widget.showUnderline!
                                                ? BorderSide(width: 1.5)
                                                : BorderSide.none,
                                          ),
                                          fillColor: Colors.transparent,
                                          contentPadding: widget.showUnderline!
                                              ? EdgeInsets.symmetric(vertical: 2.0)
                                              : null,
                                          isDense: true,
                                          errorStyle: renderTextStyle(
                                            context: context,
                                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                                            textColor: theme.colorScheme.error,
                                          ),
                                          hintText: widget.isHintAndLabel!
                                              ? widget.hint
                                              : widget.hint!.isNotEmpty
                                                  ? widget.hint
                                                  : null,
                                          labelText: widget.isHintAndLabel!
                                              ? widget.hintLabel
                                              : widget.hintLabel!.isNotEmpty
                                                  ? widget.hintLabel
                                                  : null,
                                          labelStyle: renderTextStyle(
                                            context: context,
                                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                                            textColor: widget.hintLabelColor ??
                                                Colors.black.withOpacity(0.3),
                                          ),
                                          hintStyle: renderTextStyle(
                                            context: context,
                                            theme: BASE_TEXT_THEME.LABEL_SMALL,
                                            textColor:
                                                widget.hintColor ?? Colors.black.withOpacity(0.3),
                                          ),
                                          suffixText: widget.isPrice! ? "F CFA" : widget.suffixText,
                                        ),
                                        validator: (value) {
                                          if (widget.onValidated != null) {
                                            return widget.onValidated!(value!);
                                          }
                                          if (widget.validationKey != null) {
                                            widget.validationKey!.currentState!.setState(() {
                                              if (widget.isRequired! &&
                                                  value!.isEmpty &&
                                                  widget.textController!.text.isEmpty) {
                                                setState(() {
                                                  errorMessage =
                                                      "Cette information est requise et ne peut"
                                                      " pas être vide";
                                                });
                                              } else if (widget.isEmail! &&
                                                  !EmailValidator.validate(value!)) {
                                                setState(() {
                                                  errorMessage = "Le mail n'est pas valide";
                                                });
                                              } else if (widget.isPassword! && value!.length < 6) {
                                                setState(() {
                                                  errorMessage =
                                                      "Le mot de passe doit contenir au moins "
                                                      "6 caractères";
                                                });
                                              } else if (widget.isTelephone!) {
                                                try {
                                                  int.parse(widget.textController!.text
                                                      .replaceAll(" ", ""));
                                                  setState(() {
                                                    errorMessage = '';
                                                  });
                                                } catch (e) {
                                                  if (widget.isRequired!) {
                                                    setState(() {
                                                      errorMessage =
                                                          "Le numéro de téléphone n'est pas valide";
                                                    });
                                                  } else {
                                                    setState(() {
                                                      errorMessage = '';
                                                    });
                                                  }
                                                }
                                              } else if (widget.isDateHeure! ||
                                                  widget.isDate! && value!.contains("00-00-0000")) {
                                                setState(() {
                                                  errorMessage = "Veuillez choisir une date valide";
                                                });
                                              } else if (widget.minLength! > 0 &&
                                                  value!.length < widget.maxLength!) {
                                                setState(() {
                                                  errorMessage = "Soyez plus précis";
                                                });
                                              } else {
                                                setState(() {
                                                  errorMessage = '';
                                                });
                                              }
                                            });
                                          }
                                          return errorMessage.isNotEmpty ? errorMessage : null;
                                        },
                                        onChanged: (value) {
                                          if (widget.onChanged != null) {
                                            widget.onChanged!(value);
                                          }
                                          if (widget.validationKey != null) {
                                            widget.validationKey!.currentState!.validate();
                                          }
                                        },
                                        onTap: () {
                                          pickDateTime();

                                          if (widget.onTap != null) {
                                            widget.onTap!();
                                          }
                                        },
                                        onEditingComplete: () {
                                          setState(() {
                                            isEditting = false;
                                          });
                                          if (widget.onFieldSubmitted != null) {
                                            widget.onFieldSubmitted!(widget.textController!.text);
                                          }
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        onSaved: (value) {
                                          if (widget.onSaved != null) {
                                            widget.onSaved!(value!);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pickDateTime();

                                      if (widget.isPassword == true && widget.readOnly == false) {
                                        setState(() {
                                          mayObscureText = !mayObscureText;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      child: widget.isPassword == true
                                          ? Icon(
                                              mayObscureText
                                                  ? Icons.lock_outline_rounded
                                                  : Icons.lock_open_rounded,
                                              color: Colors.black45,
                                            )
                                          : widget.isHeure!
                                              ? const Icon(
                                                  Icons.access_time,
                                                  color: Colors.black45,
                                                )
                                              : widget.isDateHeure! || widget.isDate!
                                                  ? const Icon(
                                                      Icons.date_range_outlined,
                                                      color: Colors.black45,
                                                    )
                                                  : widget.rightIcon != null
                                                      ? Icon(
                                                          widget.rightIcon,
                                                          color: theme.primaryColor,
                                                        )
                                                      : widget.rightWidget,
                                    ),
                                  )
                                ],
                              )
                            : Container(
                                constraints: const BoxConstraints(maxHeight: 45, minHeight: 40),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      if (selectedTagList.isNotEmpty)
                                        Wrap(
                                          direction: Axis.horizontal,
                                          children: selectedTagList
                                              .map((e) => e.isNotEmpty
                                                  ? Container(
                                                      margin: const EdgeInsets.symmetric(
                                                          horizontal: 4, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(Radius.circular(90)),
                                                        color: theme.colorScheme.surface,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(horizontal: 4),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          NDisplayTextWidget(
                                                            text: e,
                                                            theme: BASE_TEXT_THEME.BODY_SMALL,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                suggestionsList.add(e);
                                                                selectedTagList.remove(e);
                                                                if (widget.textController != null) {
                                                                  widget.textController!.text =
                                                                      widget.textController!.text
                                                                          .replaceAll("$e~|~", "");
                                                                }
                                                                if (widget.onChanged != null) {
                                                                  widget.onChanged!(
                                                                      selectedTagList.join("~|~"));
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 8),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: theme.colorScheme.error,
                                                                size: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  : const SizedBox.shrink())
                                              .toList(),
                                        ),
                                      /*Autocomplete(
                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                          return widget.suggestionsList!
                                              .where((String pattern) => Fonctions()
                                                  .removeAccents(pattern.toLowerCase().trim())
                                                  .contains(Fonctions().removeAccents(pattern.toLowerCase().trim())))
                                              .toList();
                                        },
                                        displayStringForOption: (String option) => option,
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController fieldTextEditingController,
                                            FocusNode fieldFocusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextField(
                                            controller: fieldTextEditingController,
                                            focusNode: fieldFocusNode,
                                            scrollPadding: widget.scrollingPadding?? EdgeInsets.zero,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          );
                                        },
                                        onSelected: (String selection) {
                                          setState(() {
                                            widget.textController!.text = "";
                                            setState(() {
                                              selectedTagList.add(selection);
                                              print(selection);
                                              suggestionsList.remove(selection);
                                              print(suggestionsList);
                                            });
                                            setState(() {});
                                            if (widget.textController != null) {
                                              widget.textController!.text += "$selection~|~";
                                            }
                                            if (widget.onChanged != null) {
                                              widget.onChanged!(selectedTagList.join("~|~"));
                                            }
                                          });
                                        },
                                        optionsViewBuilder: (BuildContext context,
                                            AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              child: Container(
                                                color: Colors.cyan,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.all(10.0),
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final String option = options.elementAt(index);

                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                        title:
                                                            NDisplayTextWidget(
        text:option, style: const TextStyle(color: Colors.white)),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),*/
                                      TypeAheadField(
                                        hideKeyboardOnDrag: true,
                                        // hideSuggestionsOnKeyboardHide: false,
                                        hideOnEmpty: true,
                                        /*suggestionsBoxVerticalOffset: 1,
                                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                            color: Colors.white, shadowColor: theme.colorScheme.background),
                                        textFieldConfiguration: TextFieldConfiguration(
                                            autofocus: false,
                                            style: renderTextStyle(context: context, theme: BASE_TEXT_THEME.BODY_SMALL),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            onChanged: widget.onChanged,
                                            controller: widget.textController,
                                            maxLines: 1),*/
                                        suggestionsCallback: (pattern) async {
                                          return suggestionsList.isNotEmpty
                                              ? suggestionsList
                                                  .where((element) => Fonctions()
                                                      .removeAccents(element.toLowerCase().trim())
                                                      .contains(Fonctions().removeAccents(
                                                          pattern.toLowerCase().trim())))
                                                  .toList()
                                              : [];
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: NDisplayTextWidget(
                                              text: "$suggestion",
                                              theme: BASE_TEXT_THEME.BODY_SMALL,
                                            ),
                                          );
                                        },
                                        onSelected: (suggestion) {
                                          if (widget.onSuggestionSelcted != null) {
                                            widget.onSuggestionSelcted!(suggestion);
                                            return;
                                          }
                                          setState(() {
                                            setState(() {
                                              selectedTagList.add(suggestion);
                                              suggestionsList.remove(suggestion);
                                              if (widget.textController != null) {
                                                widget.textController!.text = "";
                                              }
                                            });
                                            setState(() {});
                                            if (widget.textController != null) {
                                              widget.textController!.text += "$suggestion~|~";
                                            }
                                            if (widget.onChanged != null) {
                                              widget.onChanged!(selectedTagList.join("~|~"));
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      if (errorMessage.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              Fonctions().showErrorAsWidget(
                                context: context,
                                message: errorMessage,
                                assetPath: "assets/images/default_image.png",
                                typewidgeterror: TYPEWIDGETERROR.BOTTOMSHEET,
                              );
                            },
                            child: Icon(
                              Icons.info,
                              color: theme.colorScheme.error,
                              size: 16,
                            ),
                          ),
                        )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
