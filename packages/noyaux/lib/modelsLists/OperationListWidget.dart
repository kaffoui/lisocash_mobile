import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import '../models/Operation.dart';
import '../modelsVues/OperationVue.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DisplayTextWidget.dart';
import '../widgets/N_DropDownWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class OperationListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double? maxCrossAxisExtent;
  final double? mainAxisExtent;
  final Function? onItemPressed;
  final Function(Operation)? buildCustomItemView;
  final Function(List<Operation>)? onListLoaded;
  final void Function(String value)? getSuggestedValue;
  final bool? showItemAsCard,
      showAsDropDown,
      showAppBar,
      showAsGrid,
      canRefresh,
      mayScrollHorizontal,
      canEditItem,
      showOnlyForToday,
      canDeleteItem,
      showForAdmin,
      showValidation,
      showAsSuggestedTextInputWidget,
      canAddItem,
      showSearchBar,
      canSearchInDropdown,
      canMultiselected,
      skipLocalData;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backColor;
  final Operation? initialOperation, firstOperationInList;
  final String? title, user_id, message_error;
  final List<Operation>? list;

  const OperationListWidget({
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
    this.showValidation = false,
    this.mayScrollHorizontal = false,
    this.canRefresh = true,
    this.showForAdmin = false,
    this.canEditItem = false,
    this.canDeleteItem = false,
    this.showOnlyForToday = false,
    this.canAddItem = false,
    this.showSearchBar = false,
    this.buildCustomItemView,
    this.onListLoaded,
    this.onItemPressed,
    this.canSearchInDropdown = false,
    this.canMultiselected = false,
    this.skipLocalData = true,
    this.initialOperation,
    this.firstOperationInList,
    this.title,
    this.getSuggestedValue,
    this.showAsSuggestedTextInputWidget = false,
    this.list,
    this.user_id,
    this.message_error,
  });

  @override
  State<OperationListWidget> createState() => _OperationListWidgetState();
}

class _OperationListWidgetState extends State<OperationListWidget> {
  List<Operation> list = [];
  List<Operation> listSource = [];
  Operation selectedOperation = Operation();
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

    await Preferences(skipLocal: skipLocal)
        .getOperationListFromLocal()
        .then((value) => {
              setState(() {
                searchController.text = "";

                listSource.clear();
                if (value.isNotEmpty && widget.showForAdmin == false) {
                  listSource.addAll(value
                      .where((element) => (element.user_id_from == int.tryParse(widget.user_id!) ||
                          element.user_id_to == int.tryParse(widget.user_id!)))
                      .toList());
                } else {
                  listSource.addAll(value);
                }

                if (widget.onListLoaded != null) {
                  widget.onListLoaded!(listSource);
                }

                listSource.sort((a, b) => b.date_enregistrement!.compareTo(a.date_enregistrement!));

                if (listSource.isNotEmpty) {
                  if (widget.firstOperationInList != null) {
                    listSource.insert(0, widget.firstOperationInList!);
                  }
                  // print("Initial data ${widget.initialOperation}");
                  selectedOperation = widget.initialOperation != null &&
                          !widget.showAsSuggestedTextInputWidget!
                      ? listSource.contains(widget.initialOperation)
                          ? listSource
                              .firstWhere((element) => element.id == widget.initialOperation!.id)
                          : listSource[0]
                      : listSource[0];
                }
                if (widget.onItemPressed != null) widget.onItemPressed!(selectedOperation);

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
      title: "Ajout de Operation",
      widget: Formulaire(
          contextFormulaire: context,
          successCallBack: () {
            reloadPage();
          }).saveOperationForm(),
    );*/
  }

  void modifier({required Operation operation}) {
    /* Fonctions().showWidgetAsDialog(
        context: context,
        title: "Modification",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).saveOperationForm(objectOperation: operation));*/
  }

  void supprimer({required Operation operation}) {
    /*Fonctions().showWidgetAsDialog(
        context: context,
        title: "Supression",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).dialogForDeleteObject(objectToDelete: operation, url: Url.operationDeleteUrl));*/
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
        .where((element) => (Fonctions()
                .removeAccents(element.id!.toString())
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.type_operation!)
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.frais_id!.toString())
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.taux_id!.toString())
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.user_id_from!.toString())
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.user_id_to!.toString())
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions().removeAccents(element.montant!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.motif!).toLowerCase().contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.etat_operation!)
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.date_envoie!)
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.date_reception!)
                .toLowerCase()
                .contains(themeRecherche) ||
            Fonctions()
                .removeAccents(element.date_enregistrement!)
                .toLowerCase()
                .contains(themeRecherche)))
        .toList();

    if (widget.showOnlyForToday == true) {
      list = list
          .where(
              (element) => DateTime.parse(element.date_enregistrement!).day == DateTime.now().day)
          .toList();
    }

    if (widget.showValidation == true) {
      list = list.where((element) => element.isRetrait).toList();
    }

    return Scaffold(
      backgroundColor:
          widget.backColor ?? (widget.showAsDropDown == true ? Colors.transparent : Colors.white),
      appBar: widget.showAppBar == true
          ? Fonctions()
              .defaultAppBar(context: context, titre: "${widget.title != null ? widget.title : ""}")
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
                                dropDownAction(operation: selectedOperation)
                              ],
                            ),
                          if (widget.showAsDropDown != true)
                            Expanded(
                              child: NErrorWidget(
                                message: widget.message_error ?? "Aucune donnée trouvée",
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
            initialTagSelectedList: widget.initialOperation != null
                ? widget.initialOperation!.id!.toString().split("~|~").toList()
                : null,
            suggestionsList: list.map((e) => e.id!.toString()).toList(),
            onChanged: (value) {
              if (widget.getSuggestedValue != null) {
                widget.getSuggestedValue!(value);
              }
            },
          ),
        ),
        dropDownAction(operation: selectedOperation)
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
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Expanded(
                                child: NDisplayTextWidget(
                                  text: "",
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: NDisplayTextWidget(
                                    text: "Opération type".toCapitalizedCase(),
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: NDisplayTextWidget(
                              text: "Acteurs",
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: NDisplayTextWidget(
                              text: "Montant envoyer".toCapitalizedCase(),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: NDisplayTextWidget(
                              text: "Montant recu".toCapitalizedCase(),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 96),
                children: list.map((operation) {
                  return widget.buildCustomItemView != null
                      ? widget.buildCustomItemView!(operation) as Widget
                      : VueOperation(
                          operation: operation,
                          reloadPage: reloadPage,
                          onPressed: widget.onItemPressed != null
                              ? (selectedOperation) {
                                  if (widget.onItemPressed != null)
                                    widget.onItemPressed!(selectedOperation);
                                  setState(() {
                                    selectedIndex = list.indexOf(selectedOperation);
                                  });
                                }
                              : null,
                          isSelected: selectedIndex == list.indexOf(operation),
                          optionWidget: dropDownAction(operation: operation),
                          showAsCard: widget.showItemAsCard,
                        );
                }).toList(),
              ),
            ),
          ],
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
                : VueOperation(
                    operation: actualite,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedActualite) {
                            if (widget.onItemPressed != null)
                              widget.onItemPressed!(selectedActualite);
                          }
                        : null,
                    optionWidget: dropDownAction(operation: actualite),
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
            initialObject: selectedOperation,
            listObjet: list,
            title: widget.title,
            canSearch: widget.canSearchInDropdown!,
            canMultiSelected: widget.canMultiselected!,
            onChangedDropDownValue: (value) {
              setState(() {
                selectedOperation = value;
              });
              if (widget.onItemPressed != null) widget.onItemPressed!(selectedOperation);
            },
            buildItem: (operation) {
              operation = operation as Operation;
              return widget.buildCustomItemView != null
                  ? widget.buildCustomItemView!(operation) as Widget
                  : NDropDownModelWidget(
                      title: "${operation.id}",
                    );
            },
          ),
        ),
        dropDownAction(operation: selectedOperation)
      ],
    );
  }

  Widget dropDownAction({required Operation operation, bool onError = false}) {
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
                  modifier(operation: operation);
                } else if (value == 3) {
                  supprimer(operation: operation);
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
