// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:noyaux/widgets/N_DisplayImageWidget.dart';
import 'package:noyaux/widgets/N_DisplayTextWidget.dart';
import 'package:noyaux/widgets/N_TextInputWidget.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import 'N_ButtonWidget.dart';

class NMediaWidget extends StatefulWidget {
  final GlobalKey<FormFieldState>? globalKey;

  //final TextEditingController? textController;

  final BuildContext? contextDash;
  String? urlImage, urlToSend, title, fileNameToSend, serveurLink;
  List<String>? filtreFile;
  final int? imageQuality, maxSizeFile;
  final EdgeInsetsGeometry? margin, padding;
  final double? height, width, radius, size, backgroundRadius;
  final bool isEditable,
      isRequired,
      isDeletable,
      showButtonToSend,
      showLoader,
      isUserProfile,
      isRounded,
      pickFile,
      isOtherImage,
      showAsField,
      sendFilesWithMultiPart;
  final BoxFit? fit;
  final Color? backgroundColor, borderColor;
  final void Function()? saveDirectlyImage, deleteDirectlyImage, onSuccessImageSend, onErrorImageSend;
  final void Function(String value)? getNameImage, getBase64, getExtension, getPath, getSizeFile;
  final void Function(List<int> value)? getByte;
  final objectToSend;
  final Map<String, dynamic>? dataToSend, additionalArgument;

  NMediaWidget({
    Key? key,
    //this.textController,
    this.globalKey,
    this.maxSizeFile,
    this.contextDash,
    this.urlImage = "",
    this.fileNameToSend = "",
    this.serveurLink = "",
    this.urlToSend,
    this.title,
    this.filtreFile,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.radius = 0,
    this.size = double.infinity,
    this.backgroundRadius,
    this.imageQuality,
    this.isEditable = false,
    this.isRequired = false,
    this.isDeletable = false,
    this.showButtonToSend = false,
    this.sendFilesWithMultiPart = false,
    this.showLoader = true,
    this.isUserProfile = false,
    this.isRounded = false,
    this.fit,
    this.pickFile = false,
    this.isOtherImage = false,
    this.backgroundColor,
    this.saveDirectlyImage,
    this.deleteDirectlyImage,
    this.onSuccessImageSend,
    this.onErrorImageSend,
    this.getNameImage,
    this.getBase64,
    this.getExtension,
    this.getPath,
    this.objectToSend,
    this.dataToSend,
    this.additionalArgument,
    this.showAsField = false,
    this.getSizeFile,
    this.getByte,
    this.borderColor,
  }) : super(key: key);

  @override
  State<NMediaWidget> createState() => _NMediaWidgetState();
}

class _NMediaWidgetState extends State<NMediaWidget> {
  TextEditingController textEditingController = TextEditingController();
  final ImagePicker? picker = ImagePicker();
  XFile? pickedFile;

  String? selectedFilePath, selectedFileName, selectedFileBase64, urlImage = "";
  List<int> selectedFileByte = [];

  bool sendImage = false, sendImageSucced = false, deleteImageSucced = false, error = false;

  int fileSize = 0;

  FilePickerResult? filePickerResult;

  void getImage(BuildContext myContext) async {
    if (kIsWeb) {
      Fonctions().pickWebImage().then((value) {
        setState(() {
          selectedFileBase64 = value["base64"];
          selectedFileName = value["name"];
          selectedFilePath = value["path"];
          selectedFileByte = value["bytes"];

          if (widget.getBase64 != null) {
            widget.getBase64!(selectedFileBase64!);
          }
          if (widget.getExtension != null) {
            widget.getExtension!("");
          }
          if (widget.getNameImage != null) {
            widget.getNameImage!(selectedFileName!);
          }
          if (widget.getPath != null) {
            widget.getPath!(selectedFilePath!);
          }
          if (widget.getByte != null) {
            widget.getByte!(selectedFileByte);
          }
        });
      });
    } else {
      Fonctions().showWidgetAsDialog(
        context: myContext,
        widget: StatefulBuilder(builder: (context, setState) {
          return Container(
            width: 320,
            constraints: BoxConstraints(maxWidth: 320),
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: NButtonWidget(
                    text: "Caméra",
                    action: () async {
                      try {
                        pickedFile = await picker!.pickImage(
                          source: ImageSource.camera,
                          imageQuality: widget.imageQuality != null ? int.parse("${widget.imageQuality}") : Constants.kImageQuality,
                        );
                        setState(() {
                          final bytes = File(pickedFile!.path).readAsBytesSync();
                          selectedFileBase64 = base64Encode(bytes);
                          selectedFileName = pickedFile!.name;
                          selectedFilePath = pickedFile!.path;
                          if (widget.getBase64 != null) {
                            widget.getBase64!(selectedFileBase64!);
                          }
                          if (widget.getExtension != null) {
                            widget.getExtension!("");
                          }
                          if (widget.getNameImage != null) {
                            widget.getNameImage!(selectedFileName!);
                          }
                          if (widget.getPath != null) {
                            widget.getPath!(selectedFilePath!);
                          }
                          if (widget.getByte != null) {
                            widget.getByte!(bytes);
                          }
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        setState(() {
                          // print("e: $e");
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: NButtonWidget(
                    text: "Galerie",
                    action: () async {
                      try {
                        pickedFile = await picker!.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: widget.imageQuality != null ? int.parse("${widget.imageQuality}") : Constants.kImageQuality,
                        );
                        setState(() {
                          final bytes = File(pickedFile!.path).readAsBytesSync();
                          selectedFileBase64 = base64Encode(bytes);
                          selectedFileName = pickedFile!.name;
                          selectedFilePath = pickedFile!.path;
                          if (widget.getBase64 != null) {
                            widget.getBase64!(selectedFileBase64!);
                          }
                          if (widget.getExtension != null) {
                            widget.getExtension!("");
                          }
                          if (widget.getNameImage != null) {
                            widget.getNameImage!(selectedFileName!);
                          }
                          if (widget.getPath != null) {
                            widget.getPath!(selectedFilePath!);
                          }
                          if (widget.getByte != null) {
                            widget.getByte!(bytes);
                          }
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        setState(() {
                          // print("e: $e");
                        });
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }),
        title: "Selectionner une photo",
      );
    }
  }

  Future<void> sendImageWithMultiPart() async {
    if (filePickerResult != null) {
      setState(() {
        sendImage = true;
        sendImageSucced = false;
        error = false;
      });

      Uri uri = Uri.https(widget.serveurLink!, widget.urlToSend!);

      var request = http.MultipartRequest('POST', uri);

      List<int> bytes = filePickerResult!.files.first.bytes!;
      String name = filePickerResult!.files.first.name;

      request.fields.addAll(
          {"action": "SAVE", "id": widget.objectToSend != null && !(widget.objectToSend is Map<String, dynamic>) ? widget.objectToSend.id : ""});

      request.files.add(http.MultipartFile.fromBytes('${widget.fileNameToSend}', bytes, filename: name));
      try {
        http.StreamedResponse response = await request.send();
        var stream = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          Map<String, dynamic> body = stream.isNotEmpty ? json.decode(stream) : {"codeReponse": "0"};
          if (body["codeReponse"] == "100") {
            setState(() {
              sendImage = false;
              sendImageSucced = true;
              error = false;

              if (widget.onSuccessImageSend != null) {
                widget.onSuccessImageSend!();
              }
            });
            await Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                  sendImage = false;
                  sendImageSucced = true;
                  error = false;
                }));
          } else {
            setState(() {
              sendImage = false;
              sendImageSucced = false;
              error = true;
              if (widget.onErrorImageSend != null) {
                widget.onErrorImageSend!();
              }
            });
            await Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                  sendImage = false;
                  sendImageSucced = false;
                  error = false;
                }));
          }
        } else {
          print(response.reasonPhrase);
          setState(() {
            sendImage = false;
            sendImageSucced = false;
            error = true;
            if (widget.onErrorImageSend != null) {
              widget.onErrorImageSend!();
            }
          });
          await Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
                sendImage = false;
                sendImageSucced = false;
                error = false;
              }));
        }
      } catch (e) {
        //print("error in catch: $e");
        setState(() {
          sendImage = false;
          sendImageSucced = false;
          error = true;
          if (widget.onErrorImageSend != null) {
            widget.onErrorImageSend!();
          }
        });
        await Future.delayed(Duration(seconds: 1)).then((value) => setState(() {
              sendImage = false;
              sendImageSucced = false;
              error = false;
            }));
      }
    }
  }

  void manageTap() {
    if (widget.isEditable == true) {
      getImage(context);
    } else {
      if (urlImage!.isNotEmpty) {
        Fonctions().showMediaLargeDialog(
          context: context,
          imageLinkList: [urlImage!],
          onTap: () {
            getImage(context);
          },
        );
      }
    }
  }

  @override
  void dispose() {
    selectedFileBase64 = null;
    selectedFileName = null;
    selectedFilePath = null;
    pickedFile = null;
    super.dispose();
  }

  @override
  void initState() {
    selectedFileBase64 = null;
    selectedFileName = null;
    selectedFilePath = null;
    pickedFile = null;
    urlImage = widget.urlImage;
    textEditingController.text = filePickerResult == null && widget.urlImage != null && widget.urlImage!.isNotEmpty ? widget.urlImage! : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (urlImage != null) {
      if (!urlImage!.startsWith("https")) {
        urlImage = "$urlImage";
      }
    }

    print("image ndi: ${urlImage}");
    return MouseRegion(
      cursor: widget.isEditable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          manageTap();
        },
        child: widget.pickFile
            ? Row(
                children: <Widget>[
                  if (widget.showAsField)
                    Expanded(
                      child: NTextInputWidget(
                        textController: textEditingController,
                        /*textColor: filePickerResult == null && widget.urlImage != null && widget.urlImage!.isNotEmpty
                            ? Colors.black
                            : filePickerResult == null
                                ? Colors.grey.withOpacity(0.5)
                                : widget.maxSizeFile != null && fileSize < widget.maxSizeFile!
                                    ? Colors.green
                                    : Colors.red,*/
                        validationKey: widget.globalKey,
                        isRequired: widget.isRequired,
                        title: widget.title ?? "Sélectionnez un fichier",
                        hint: filePickerResult == null && widget.urlImage != null && widget.urlImage!.isNotEmpty
                            ? widget.urlImage
                            : filePickerResult != null
                                ? "${filePickerResult!.files.first.name} (${filePickerResult!.files.first.size})"
                                : "Choisir un fichier",
                        hintColor: filePickerResult == null && widget.urlImage != null && widget.urlImage!.isNotEmpty
                            ? Colors.black
                            : filePickerResult == null
                                ? Colors.grey.withOpacity(0.5)
                                : widget.maxSizeFile != null && fileSize < widget.maxSizeFile!
                                    ? Colors.green
                                    : Colors.red,
                        borderColor: filePickerResult == null
                            ? widget.borderColor != null
                                ? widget.borderColor!.withOpacity(.5)
                                : Colors.black.withOpacity(0.5)
                            : Colors.green,
                        readOnly: true,
                        onTap: () {
                          if (widget.urlImage != null && widget.urlImage!.isNotEmpty) {
                            Fonctions().openUrl("$urlImage");
                          }
                        },
                        rightWidget: Row(
                          children: <Widget>[
                            if (!sendImageSucced)
                              IconButton(
                                icon: Icon(
                                    filePickerResult == null && ((widget.urlImage != null && widget.urlImage!.isEmpty) || widget.urlImage == null)
                                        ? Icons.add
                                        : Icons.edit),
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  setState(() {});
                                  if (!sendImage) {
                                    final data = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: widget.filtreFile,
                                      allowCompression: true,
                                    );
                                    if (data != null) {
                                      setState(() {
                                        filePickerResult = data;
                                        selectedFileBase64 = base64Encode(filePickerResult!.files.first.bytes!);
                                        fileSize = filePickerResult!.files.first.size;
                                        if (widget.getNameImage != null) {
                                          widget.getNameImage!(filePickerResult!.files.first.name);
                                        }
                                        if (widget.getSizeFile != null) {
                                          widget.getSizeFile!(filePickerResult!.files.first.size.toString());
                                        }
                                        if (widget.getExtension != null) {
                                          widget.getExtension!(filePickerResult!.files.first.extension!);
                                        }
                                        if (widget.getBase64 != null) {
                                          widget.getBase64!(selectedFileBase64!);
                                        }
                                        if (widget.getByte != null) {
                                          widget.getByte!(filePickerResult!.files.first.bytes!);
                                          //print("ici");
                                        }

                                        textEditingController.text = filePickerResult != null
                                            ? "${filePickerResult!.files.first.name} (${filePickerResult!.files.first.size})"
                                            : "";
                                      });
                                    } else {
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                            Visibility(
                              visible: widget.showButtonToSend &&
                                  selectedFileBase64 != null &&
                                  ((widget.maxSizeFile != null && fileSize < widget.maxSizeFile!) || widget.maxSizeFile == null),
                              child: NButtonWidget(
                                iconData: sendImageSucced
                                    ? Icons.check_circle_outline
                                    : error
                                        ? Icons.warning
                                        : MdiIcons.send,
                                load: sendImage,
                                loaderColor: Theme.of(context).primaryColor,
                                iconColor: sendImageSucced
                                    ? Colors.green
                                    : error
                                        ? Colors.red
                                        : Theme.of(context).primaryColor,
                                backColor: Colors.white,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,
                                showShadow: false,
                                action: () async {
                                  if (!sendImageSucced) {
                                    if (widget.sendFilesWithMultiPart) {
                                      await sendImageWithMultiPart();
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!widget.showAsField)
                    Row(
                      children: <Widget>[
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton.icon(
                            onPressed: () async {
                              setState(() {});
                              final data = await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: widget.filtreFile,
                                allowCompression: true,
                              );
                              if (data != null) {
                                setState(() {
                                  filePickerResult = data;
                                  selectedFileBase64 = base64Encode(filePickerResult!.files.first.bytes!);
                                  if (widget.getNameImage != null) {
                                    widget.getNameImage!(filePickerResult!.files.first.name);
                                  }
                                  if (widget.getSizeFile != null) {
                                    widget.getSizeFile!(filePickerResult!.files.first.size.toString());
                                  }
                                  if (widget.getBase64 != null) {
                                    widget.getBase64!(selectedFileBase64!);
                                  }
                                });
                              } else {
                                setState(() {});
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: filePickerResult == null ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.green,
                              disabledForegroundColor: Colors.grey.withOpacity(0.38),
                            ),
                            icon: Icon(
                              filePickerResult == null ? Icons.add : Icons.edit,
                            ),
                            label: NDisplayTextWidget(
                              text: filePickerResult != null
                                  ? "${filePickerResult!.files.first.name} (${filePickerResult!.files.first.size})"
                                  : "Choisir un fichier",
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.showButtonToSend && selectedFileBase64 != null,
                          child: NButtonWidget(
                            iconData: sendImageSucced
                                ? Icons.check_circle_outline
                                : error
                                    ? Icons.warning
                                    : MdiIcons.send,
                            load: sendImage,
                            iconColor: Colors.white,
                            showShadow: false,
                            backColor: sendImageSucced
                                ? Colors.green
                                : error
                                    ? Colors.red
                                    : Theme.of(context).primaryColor,
                            action: () async {
                              if (!sendImageSucced) {
                                if (widget.sendFilesWithMultiPart) {
                                  await sendImageWithMultiPart();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    )
                ],
              )
            : widget.showAsField
                ? NTextInputWidget(
                    title: widget.title,
                    textController:
                        TextEditingController(text: (selectedFilePath != null && selectedFilePath!.isEmpty) ? "Choisir une image" : selectedFileName),
                    readOnly: true,
                    rightWidget: NButtonWidget(
                      text: "...",
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.all(0),
                      action: () {
                        manageTap();
                      },
                    ),
                  )
                : Container(
                    height: widget.height,
                    width: widget.width,
                    margin: widget.margin,
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.transparent,
                      borderRadius: widget.backgroundRadius != null
                          ? BorderRadius.all(Radius.circular(widget.backgroundRadius!))
                          : BorderRadius.all(Radius.circular(0.0)),
                    ),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: widget.backgroundRadius != null
                                    ? BorderRadius.all(Radius.circular(widget.backgroundRadius!))
                                    : BorderRadius.circular(16)),
                            width: double.infinity,
                            height: widget.height,
                            child: widget.isEditable == true &&
                                    (widget.urlImage == null || (widget.urlImage != null && widget.urlImage!.isEmpty)) &&
                                    pickedFile == null &&
                                    !widget.isUserProfile &&
                                    selectedFileBase64 == null
                                ? Center(
                                    child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 36,
                                  ))
                                : NDisplayImageWidget(
                                    imageLink: selectedFilePath != null ? "$selectedFilePath" : urlImage,
                                    isUserProfile: widget.isUserProfile,
                                    isOtherImage: widget.isOtherImage,
                                    isFile: pickedFile != null,
                                    size: widget.size,
                                    isRounded: widget.isRounded,
                                    radius: widget.radius,
                                    showLoader: widget.showLoader,
                                    backgroundColor: widget.isEditable == false ? Colors.white : Colors.black.withOpacity(0.1),
                                    fit: widget.fit ?? BoxFit.cover,
                                    width: double.infinity,
                                    height: widget.height,
                                    defaultWidget: widget.isEditable == true ? Center(child: Icon(Icons.add_a_photo_outlined)) : null,
                                    defaultUrlImage: widget.isEditable == false ? "assets/images/default_image.png" : null,
                                  ),
                          ),
                          Visibility(
                            visible: widget.showButtonToSend && selectedFileBase64 != null,
                            child: Positioned(
                              bottom: 4.0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NButtonWidget(
                                    iconData: sendImageSucced
                                        ? Icons.check_circle_outline
                                        : error
                                            ? Icons.warning
                                            : MdiIcons.send,
                                    load: sendImage,
                                    iconColor: Colors.white,
                                    showShadow: false,
                                    backColor: sendImageSucced
                                        ? Colors.green
                                        : error
                                            ? Colors.red
                                            : Theme.of(context).primaryColor,
                                    action: () async {
                                      if (!sendImageSucced) {
                                        if (!sendImageSucced) {
                                          if (widget.sendFilesWithMultiPart) {
                                            await sendImageWithMultiPart();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (selectedFileBase64 != null && !sendImageSucced) || (widget.isDeletable == true && widget.urlImage!.isNotEmpty),
                            child: Positioned(
                              top: widget.isRounded ? 0 : 4.0,
                              right: 4.0,
                              child: NButtonWidget(
                                iconData: MdiIcons.delete,
                                load: false,
                                iconColor: Colors.white,
                                backColor: Colors.red,
                                action: () {
                                  if (widget.deleteDirectlyImage != null && widget.urlImage!.isNotEmpty) {
                                    widget.deleteDirectlyImage!();
                                  } else {
                                    setState(() {
                                      pickedFile = null;
                                      selectedFileBase64 = null;
                                      selectedFilePath = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
