import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import '../models/Configuration.dart';
import '../modelsVues/ConfigurationVue.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DropDownWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class ConfigurationListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double? maxCrossAxisExtent;
  final double? mainAxisExtent;
  final Function? onItemPressed;
  final Function(Configuration)? buildCustomItemView;
  final Function(List<Configuration>)? onListLoaded;
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
  final Configuration? initialConfiguration, firstConfigurationInList;
  final String? title;
  final List<Configuration>? list;

  const ConfigurationListWidget({
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
    this.initialConfiguration,
    this.firstConfigurationInList,
    this.title,
    this.getSuggestedValue,
    this.showAsSuggestedTextInputWidget = false,
    this.list,
  });

  @override
  State<ConfigurationListWidget> createState() => _ConfigurationListWidgetState();
}

class _ConfigurationListWidgetState extends State<ConfigurationListWidget> {
  List<Configuration> list = [];
  List<Configuration> listSource = [];
  Configuration selectedConfiguration = Configuration();
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
        .getConfigurationListFromLocal()
        .then((value) => {
              setState(() async {
                searchController.text = "";
                listSource.clear();
                listSource.addAll(value);
                if (widget.onListLoaded != null) {
                  widget.onListLoaded!(listSource);
                }
                if (listSource.isNotEmpty) {
                  if (widget.firstConfigurationInList != null) {
                    listSource.insert(0, widget.firstConfigurationInList!);
                  }
                  // print("Initial data ${widget.initialConfiguration}");
                  selectedConfiguration = widget.initialConfiguration != null && !widget.showAsSuggestedTextInputWidget!
                      ? listSource.contains(widget.initialConfiguration)
                          ? listSource.firstWhere((element) => element.id == widget.initialConfiguration!.id)
                          : listSource[0]
                      : listSource[0];
                }
                if (widget.onItemPressed != null) widget.onItemPressed!(selectedConfiguration);

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
      title: "Ajout de Configuration",
      widget: Formulaire(
          contextFormulaire: context,
          successCallBack: () {
            reloadPage();
          }).saveConfigurationForm(),
    );*/
  }

  void modifier({required Configuration configuration}) {
    /* Fonctions().showWidgetAsDialog(
        context: context,
        title: "Modification",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).saveConfigurationForm(objectConfiguration: configuration));*/
  }

  void supprimer({required Configuration configuration}) {
    /*Fonctions().showWidgetAsDialog(
        context: context,
        title: "Supression",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).dialogForDeleteObject(objectToDelete: configuration, url: Url.configurationDeleteUrl));*/
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
            Fonctions().removeAccents(element.nom!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.type!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.priorite!).toLowerCase().contains(themeRecherche) ||
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
                                dropDownAction(configuration: selectedConfiguration)
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
            initialTagSelectedList: widget.initialConfiguration != null
                ? widget.initialConfiguration!.id!.toString().split("~|~").toList()
                : null,
            suggestionsList: list.map((e) => e.id!.toString()).toList(),
            onChanged: (value) {
              if (widget.getSuggestedValue != null) {
                widget.getSuggestedValue!(value);
              }
            },
          ),
        ),
        dropDownAction(configuration: selectedConfiguration)
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
          children: list.map((configuration) {
            return widget.buildCustomItemView != null
                ? widget.buildCustomItemView!(configuration) as Widget
                : VueConfiguration(
                    configuration: configuration,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedConfiguration) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedConfiguration);
                            setState(() {
                              selectedIndex = list.indexOf(selectedConfiguration);
                            });
                          }
                        : null,
                    isSelected: selectedIndex == list.indexOf(configuration),
                    optionWidget: dropDownAction(configuration: configuration),
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
                : VueConfiguration(
                    configuration: actualite,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedActualite) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedActualite);
                          }
                        : null,
                    optionWidget: dropDownAction(configuration: actualite),
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
            initialObject: selectedConfiguration,
            listObjet: list,
            title: widget.title,
            canSearch: widget.canSearchInDropdown!,
            canMultiSelected: widget.canMultiselected!,
            onChangedDropDownValue: (value) {
              setState(() {
                selectedConfiguration = value;
              });
              if (widget.onItemPressed != null) widget.onItemPressed!(selectedConfiguration);
            },
            buildItem: (configuration) {
              configuration = configuration as Configuration;
              return widget.buildCustomItemView != null
                  ? widget.buildCustomItemView!(configuration) as Widget
                  : NDropDownModelWidget(
                      title: "${configuration.id}",
                    );
            },
          ),
        ),
        dropDownAction(configuration: selectedConfiguration)
      ],
    );
  }

  Widget dropDownAction({required Configuration configuration, bool onError = false}) {
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
                  modifier(configuration: configuration);
                } else if (value == 3) {
                  supprimer(configuration: configuration);
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
