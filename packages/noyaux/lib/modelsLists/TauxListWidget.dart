import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import '../models/Taux.dart';
import '../modelsVues/TauxVue.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DropDownWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class TauxListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double? maxCrossAxisExtent;
  final double? mainAxisExtent;
  final Function? onItemPressed;
  final Function(Taux)? buildCustomItemView;
  final Function(List<Taux>)? onListLoaded;
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
  final Taux? initialTaux, firstTauxInList;
  final String? title;
  final List<Taux>? list;

  const TauxListWidget({
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
    this.initialTaux,
    this.firstTauxInList,
    this.title,
    this.getSuggestedValue,
    this.showAsSuggestedTextInputWidget = false,
    this.list,
  });

  @override
  State<TauxListWidget> createState() => _TauxListWidgetState();
}

class _TauxListWidgetState extends State<TauxListWidget> {
  List<Taux> list = [];
  List<Taux> listSource = [];
  Taux selectedTaux = Taux();
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
        .getTauxListFromLocal()
        .then((value) => {
              setState(() async {
                searchController.text = "";
                listSource.clear();
                listSource.addAll(value);
                if (widget.onListLoaded != null) {
                  widget.onListLoaded!(listSource);
                }
                if (listSource.isNotEmpty) {
                  if (widget.firstTauxInList != null) {
                    listSource.insert(0, widget.firstTauxInList!);
                  }
                  // print("Initial data ${widget.initialTaux}");
                  selectedTaux = widget.initialTaux != null && !widget.showAsSuggestedTextInputWidget!
                      ? listSource.contains(widget.initialTaux)
                          ? listSource.firstWhere((element) => element.id == widget.initialTaux!.id)
                          : listSource[0]
                      : listSource[0];
                }
                if (widget.onItemPressed != null) widget.onItemPressed!(selectedTaux);

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
      title: "Ajout de Taux",
      widget: Formulaire(
          contextFormulaire: context,
          successCallBack: () {
            reloadPage();
          }).saveTauxForm(),
    );*/
  }

  void modifier({required Taux taux}) {
    /* Fonctions().showWidgetAsDialog(
        context: context,
        title: "Modification",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).saveTauxForm(objectTaux: taux));*/
  }

  void supprimer({required Taux taux}) {
    /*Fonctions().showWidgetAsDialog(
        context: context,
        title: "Supression",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).dialogForDeleteObject(objectToDelete: taux, url: Url.tauxDeleteUrl));*/
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
            Fonctions().removeAccents(element.date_taux!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.pays_id_from!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.pays_id_to!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.taux!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.date_enregistrement!).toLowerCase().contains(themeRecherche)))
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
                                dropDownAction(taux: selectedTaux)
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
                widget.initialTaux != null ? widget.initialTaux!.id!.toString().split("~|~").toList() : null,
            suggestionsList: list.map((e) => e.id!.toString()).toList(),
            onChanged: (value) {
              if (widget.getSuggestedValue != null) {
                widget.getSuggestedValue!(value);
              }
            },
          ),
        ),
        dropDownAction(taux: selectedTaux)
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
          children: list.map((taux) {
            return widget.buildCustomItemView != null
                ? widget.buildCustomItemView!(taux) as Widget
                : VueTaux(
                    taux: taux,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedTaux) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedTaux);
                            setState(() {
                              selectedIndex = list.indexOf(selectedTaux);
                            });
                          }
                        : null,
                    isSelected: selectedIndex == list.indexOf(taux),
                    optionWidget: dropDownAction(taux: taux),
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
                : VueTaux(
                    taux: actualite,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedActualite) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedActualite);
                          }
                        : null,
                    optionWidget: dropDownAction(taux: actualite),
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
            initialObject: selectedTaux,
            listObjet: list,
            title: widget.title,
            canSearch: widget.canSearchInDropdown!,
            canMultiSelected: widget.canMultiselected!,
            onChangedDropDownValue: (value) {
              setState(() {
                selectedTaux = value;
              });
              if (widget.onItemPressed != null) widget.onItemPressed!(selectedTaux);
            },
            buildItem: (taux) {
              taux = taux as Taux;
              return widget.buildCustomItemView != null
                  ? widget.buildCustomItemView!(taux) as Widget
                  : NDropDownModelWidget(
                      title: "${taux.id}",
                    );
            },
          ),
        ),
        dropDownAction(taux: selectedTaux)
      ],
    );
  }

  Widget dropDownAction({required Taux taux, bool onError = false}) {
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
                  modifier(taux: taux);
                } else if (value == 3) {
                  supprimer(taux: taux);
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
