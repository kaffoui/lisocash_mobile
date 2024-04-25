import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import '../models/Frais.dart';
import '../modelsVues/FraisVue.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DropDownWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class FraisListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double? maxCrossAxisExtent;
  final double? mainAxisExtent;
  final Function? onItemPressed;
  final Function(Frais)? buildCustomItemView;
  final Function(List<Frais>)? onListLoaded;
  final void Function(String value)? getSuggestedValue;
  final bool? showItemAsCard,
      showAsDropDown,
      showAppBar,
      showAsGrid,
      canRefresh,
      mayScrollHorizontal,
      canEditItem,
      canDeleteItem,
      showAsSuggestedTextInputWidget,
      canAddItem,
      showSearchBar,
      canSearchInDropdown,
      canMultiselected,
      skipLocalData;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backColor;
  final Frais? initialFrais, firstFraisInList;
  final String? title;
  final List<Frais>? list;

  const FraisListWidget({
    super.key,
    this.scrollController,
    this.maxCrossAxisExtent,
    this.mainAxisExtent,
    this.margin,
    this.padding,
    this.backColor,
    this.showItemAsCard = true,
    this.showAsDropDown = false,
    this.showAppBar = false,
    this.showAsGrid = false,
    this.mayScrollHorizontal = false,
    this.canRefresh = true,
    this.canEditItem = false,
    this.canDeleteItem = false,
    this.canAddItem = false,
    this.showSearchBar = false,
    this.buildCustomItemView,
    this.onListLoaded,
    this.onItemPressed,
    this.canSearchInDropdown = false,
    this.canMultiselected = false,
    this.skipLocalData = true,
    this.initialFrais,
    this.firstFraisInList,
    this.title,
    this.getSuggestedValue,
    this.showAsSuggestedTextInputWidget = false,
    this.list,
  });

  @override
  State<FraisListWidget> createState() => _FraisListWidgetState();
}

class _FraisListWidgetState extends State<FraisListWidget> {
  List<Frais> list = [];
  List<Frais> listSource = [];
  Frais selectedFrais = Frais();
  int selectedIndex = 0;

  TextEditingController searchController = TextEditingController();
  String themeRecherche = "";
  bool isLoading = false, isDelete = false, skipLocal = true;

  void getList({bool skipLocal = false}) async {
    if (widget.list != null) {
      listSource.addAll(widget.list!);
      return;
    }
    setState(() {
      isLoading = true;
    });

    Preferences(skipLocal: skipLocal)
        .getFraisListFromLocal()
        .then((value) => {
              setState(() async {
                searchController.text = "";
                listSource.clear();
                listSource.addAll(value);
                if (widget.onListLoaded != null) {
                  widget.onListLoaded!(listSource);
                }
                if (listSource.isNotEmpty) {
                  if (widget.firstFraisInList != null) {
                    listSource.insert(0, widget.firstFraisInList!);
                  }
                  // print("Initial data ${widget.initialFrais}");
                  selectedFrais = widget.initialFrais != null && !widget.showAsSuggestedTextInputWidget!
                      ? listSource.contains(widget.initialFrais)
                          ? listSource.firstWhere((element) => element.id == widget.initialFrais!.id)
                          : listSource[0]
                      : listSource[0];
                }
                if (widget.onItemPressed != null) widget.onItemPressed!(selectedFrais);

                isLoading = false;
              })
            })
        .onError((error, stackTrace) => {
              setState(() {
                isLoading = false;
              })
            });
  }

  void ajouter() {
    /*Fonctions().showWidgetAsDialog(
      context: context,
      title: "Ajout de Frais",
      widget: Formulaire(
          contextFormulaire: context,
          successCallBack: () {
            reloadPage();
          }).saveFraisForm(),
    );*/
  }

  void modifier({required Frais frais}) {
    /* Fonctions().showWidgetAsDialog(
        context: context,
        title: "Modification",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).saveFraisForm(objectFrais: frais));*/
  }

  void supprimer({required Frais frais}) {
    /*Fonctions().showWidgetAsDialog(
        context: context,
        title: "Supression",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).dialogForDeleteObject(objectToDelete: frais, url: Url.fraisDeleteUrl));*/
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void reloadPage() {
    // print("ReloadList");
    setState(() {
      list.clear();
      getList(skipLocal: true);
    });
  }

  @override
  void initState() {
    getList(skipLocal: widget.skipLocalData!);
    searchController.addListener(() {
      setState(() {
        themeRecherche = searchController.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    themeRecherche = Fonctions().removeAccents(themeRecherche).trim();
    list = listSource
        .where((element) => (Fonctions().removeAccents(element.id!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.operation_type!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.moyen_paiement!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.continent!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.from!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.to!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.frais_pourcentage!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.frais_fixe!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.created_at!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.updated_at!).toLowerCase().contains(themeRecherche)))
        .toList();
    return Scaffold(
      backgroundColor: widget.backColor ?? (widget.showAsDropDown == true ? Colors.transparent : Colors.white),
      appBar: widget.showAppBar == true
          ? Fonctions().defaultAppBar(context: context, titre: "${widget.title != null ? widget.title : ""}")
          : null,
      body: Container(
        margin: widget.margin,
        padding: widget.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  if (widget.showSearchBar == true)
                    NTextInputWidget(
                      textController: searchController,
                      hint: "Rechercher...",
                      radius: 90,
                      leftWidget: Icon(
                        Icons.search,
                        color: theme.primaryColor,
                      ),
                    ),
                  if (isLoading) Expanded(child: Center(child: NLoadingWidget())),
                  if (!isLoading && list.isEmpty)
                    Expanded(
                      child: Column(
                        children: [
                          if (widget.showAsDropDown == true)
                            Row(
                              children: [
                                const Expanded(child: Text("Aucune donnée trouvée")),
                                dropDownAction(frais: selectedFrais)
                              ],
                            ),
                          if (widget.showAsDropDown != true)
                            Expanded(
                              child: NErrorWidget(
                                message: "Aucune donnée trouvée",
                                buttonText: "Recharger",
                                onPressed: reloadPage,
                                isOutline: true,
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (!isLoading && list.isNotEmpty)
                    widget.showAsSuggestedTextInputWidget == true
                        ? buildSuggestedTextInputWidget()
                        : widget.showAsDropDown == true
                            ? widget.showAsGrid == true
                                ? buildGridView()
                                : buildDropDownView()
                            : buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.canAddItem == true && widget.showAsDropDown == false
          ? FloatingActionButton(
              onPressed: () async {
                ajouter();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget buildSuggestedTextInputWidget() {
    return Row(
      children: [
        Expanded(
          child: NTextInputWidget(
            title: widget.title,
            initialTagSelectedList:
                widget.initialFrais != null ? widget.initialFrais!.id!.toString().split("~|~").toList() : null,
            suggestionsList: list.map((e) => e.id!.toString()).toList(),
            onChanged: (value) {
              if (widget.getSuggestedValue != null) {
                widget.getSuggestedValue!(value);
              }
            },
          ),
        ),
        dropDownAction(frais: selectedFrais)
      ],
    );
  }

  Widget buildListView() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              getList(skipLocal: true);
              setState(() {});
            },
          );
        },
        child: ListView(
          padding: EdgeInsets.only(bottom: 96),
          children: list.map((frais) {
            return widget.buildCustomItemView != null
                ? widget.buildCustomItemView!(frais) as Widget
                : VueFrais(
                    frais: frais,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedFrais) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedFrais);
                            setState(() {
                              selectedIndex = list.indexOf(selectedFrais);
                            });
                          }
                        : null,
                    isSelected: selectedIndex == list.indexOf(frais),
                    optionWidget: dropDownAction(frais: frais),
                    showAsCard: widget.showItemAsCard,
                  );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              getList(skipLocal: true);
              setState(() {});
            },
          );
        },
        child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: widget.maxCrossAxisExtent ?? 350,
            mainAxisExtent: widget.mainAxisExtent ?? 350,
          ),
          controller: widget.scrollController,
          scrollDirection: widget.mayScrollHorizontal == true ? Axis.horizontal : Axis.vertical,
          //padding: EdgeInsets.only(bottom: 12),
          children: list.map((actualite) {
            return widget.buildCustomItemView != null
                ? widget.buildCustomItemView!(actualite) as Widget
                : VueFrais(
                    frais: actualite,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedActualite) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedActualite);
                          }
                        : null,
                    optionWidget: dropDownAction(frais: actualite),
                    showAsCard: widget.showItemAsCard,
                  );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildDropDownView() {
    return Row(
      children: [
        Expanded(
          child: NDropDownWidget(
            backColor: widget.backColor,
            initialObject: selectedFrais,
            listObjet: list,
            title: widget.title,
            canSearch: widget.canSearchInDropdown!,
            canMultiSelected: widget.canMultiselected!,
            onChangedDropDownValue: (value) {
              setState(() {
                selectedFrais = value;
              });
              if (widget.onItemPressed != null) widget.onItemPressed!(selectedFrais);
            },
            buildItem: (frais) {
              frais = frais as Frais;
              return widget.buildCustomItemView != null
                  ? widget.buildCustomItemView!(frais) as Widget
                  : NDropDownModelWidget(
                      title: "${frais.id}",
                    );
            },
          ),
        ),
        dropDownAction(frais: selectedFrais)
      ],
    );
  }

  Widget dropDownAction({required Frais frais, bool onError = false}) {
    return Row(
      children: [
        if (onError || (widget.canRefresh == true && widget.showAsDropDown == true))
          NButtonWidget(
            margin: const EdgeInsets.all(8),
            iconData: Icons.refresh,
            action: () {
              getList();
              setState(() {});
            },
          ),
        if (widget.canAddItem == true || widget.canEditItem == true || widget.canDeleteItem == true)
          PopupMenuButton(
              onSelected: (value) {
                if (value == 1) {
                  ajouter();
                } else if (value == 2) {
                  modifier(frais: frais);
                } else if (value == 3) {
                  supprimer(frais: frais);
                }
              },
              child: const Icon(
                Icons.more_vert,
                color: Constants.kAccentColor,
              ),
              itemBuilder: (cxt) {
                return [
                  if (onError || (widget.canAddItem == true && widget.showAsDropDown == true))
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Ajouter"),
                    ),
                  if (widget.canEditItem == true)
                    const PopupMenuItem(
                      value: 2,
                      child: Text("Modifier"),
                    ),
                  if (widget.canDeleteItem == true)
                    const PopupMenuItem(
                      value: 3,
                      child: Text("Supprimer"),
                    )
                ];
              }),
      ],
    );
  }
}
