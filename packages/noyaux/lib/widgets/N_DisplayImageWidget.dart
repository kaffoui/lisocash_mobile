// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../services/url.dart';
import 'N_FadeTransitionWidget.dart';
import 'N_LoadingWidget.dart';

class NDisplayImageWidget extends StatefulWidget {
  final String? imageLink;
  final String? defaultUrlImage;
  final Widget? defaultWidget;
  EdgeInsetsGeometry? margin, padding;
  final double? size, height, width, radius;
  final Color? color, backgroundColor;
  final BoxFit? fit;
  final bool isUserProfile, isRounded, isFile, isOtherImage, showDefaultImage, showLoader;

  NDisplayImageWidget({
    super.key,
    this.imageLink = "",
    this.defaultUrlImage,
    this.defaultWidget,
    this.size,
    this.margin,
    this.height,
    this.width,
    this.radius = 0,
    this.padding,
    this.color,
    this.backgroundColor,
    this.showLoader = true,
    this.isOtherImage = false,
    this.isUserProfile = false,
    this.isRounded = false,
    this.isFile = false,
    this.fit,
    this.showDefaultImage = true,
  });

  @override
  State<NDisplayImageWidget> createState() => _NDisplayImageWidgetState();
}

class _NDisplayImageWidgetState extends State<NDisplayImageWidget> {
  @override
  void initState() {
    print("img display image: ${widget.imageLink}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        shape: widget.isRounded == true ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.isRounded == false ? BorderRadius.circular(widget.radius!) : null,
      ),
      child: widget.isFile
          ? Image(
              image: FileImage(File(widget.imageLink!)),
              height: widget.height ?? widget.size,
              width: widget.width ?? widget.size,
              fit: widget.fit,
              filterQuality: FilterQuality.high,
            )
          : widget.imageLink!.contains("assets/images/")
              ? Image.asset(
                  widget.imageLink!,
                  height: widget.height ?? widget.size,
                  width: widget.width ?? widget.size,
                  fit: widget.fit,
                  filterQuality: FilterQuality.high,
                )
              : CachedNetworkImage(
                  imageUrl: widget.imageLink!.startsWith("img/") //url venant de base de donnees
                      ? "https://${Url.urlServer}${Url.urlBase}${widget.imageLink!}"
                      : "${widget.imageLink}",
                  height: widget.height ?? widget.size,
                  width: widget.width ?? widget.size,
                  color: widget.color ?? null,
                  placeholder: (context, url) => Center(
                    child: !widget.showLoader
                        ? NFadeTransitionWidget(
                            repeat: true,
                            inReverse: true,
                            delay: 2000,
                            child: widget.defaultWidget ??
                                Image(
                                  image: AssetImage(widget.defaultUrlImage!),
                                  height: widget.height ?? widget.size,
                                  width: widget.width ?? widget.size,
                                  fit: widget.fit,
                                  filterQuality: FilterQuality.high,
                                ),
                          )
                        : NLoadingWidget(
                            background: Colors.transparent,
                            color: theme.primaryColor,
                            height: 25.0,
                            width: 25.0,
                          ),
                  ),
                  filterQuality: FilterQuality.high,
                  fit: widget.fit,
                  alignment: Alignment.topCenter,
                  errorWidget: (context, url, error) {
                    return widget.defaultWidget ??
                        (widget.showDefaultImage
                            ? Image.asset(
                                widget.isUserProfile == true
                                    ? "assets/images/user_g.png"
                                    : widget.defaultUrlImage ?? "assets/images/default_image.png",
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              )
                            : SizedBox.shrink());
                  },
                ),
    );
  }
}
