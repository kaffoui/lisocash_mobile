import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/fonctions.dart';
import '../models/Users.dart';
import '../modelsVues/UsersVue.dart';
import '../services/Preferences.dart';
import '../widgets/N_ButtonWidget.dart';
import '../widgets/N_DropDownWidget.dart';
import '../widgets/N_ErrorWidget.dart';
import '../widgets/N_LoadingWidget.dart';
import '../widgets/N_TextInputWidget.dart';

class UsersListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final double? maxCrossAxisExtent;
  final double? mainAxisExtent;
  final Function? onItemPressed;
  final Function(Users)? buildCustomItemView;
  final Function(List<Users>)? onListLoaded;
  final void Function(String value)? getSuggestedValue;
  final bool? showItemAsCard,
      showAsDropDown,
      showAppBar,
      showAsGrid,
      canRefresh,
      mayScrollHorizontal,
      canEditItem,
      canDeleteItem,
      removeMe,
      press,
      showAsSuggestedTextInputWidget,
      canAddItem,
      showSearchBar,
      canSearchInDropdown,
      canMultiselected,
      showOnlyValidated,
      skipLocalData;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backColor;
  final Users? initialUsers, firstUsersInList;
  final String? title;
  final List<Users>? list;

  const UsersListWidget({
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
    this.showOnlyValidated = false,
    this.press = false,
    this.buildCustomItemView,
    this.onListLoaded,
    this.onItemPressed,
    this.canSearchInDropdown = false,
    this.canMultiselected = false,
    this.skipLocalData = true,
    this.initialUsers,
    this.firstUsersInList,
    this.title,
    this.getSuggestedValue,
    this.showAsSuggestedTextInputWidget = false,
    this.list,
    this.removeMe = false,
  });

  @override
  State<UsersListWidget> createState() => _UsersListWidgetState();
}

class _UsersListWidgetState extends State<UsersListWidget> {
  List<Users> list = [];
  List<Users> listSource = [];
  Users selectedUsers = Users();
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

    await Preferences().getIdUsers().then((id) async {
      await Preferences(skipLocal: true)
          .getUsersListFromLocal()
          .then((value) => {
                setState(() async {
                  searchController.text = "";
                  listSource.clear();
                  listSource.addAll(value);
                  if (widget.onListLoaded != null) {
                    widget.onListLoaded!(listSource);
                  }
                  listSource.removeWhere((element) => element.isAdmin);

                  if (widget.removeMe == true) {
                    listSource.removeWhere((element) => element.id == int.parse(id));
                  }

                  if (listSource.isNotEmpty) {
                    if (widget.firstUsersInList != null) {
                      listSource.insert(0, widget.firstUsersInList!);
                    }
                    // print("Initial data ${widget.initialUsers}");
                    selectedUsers = widget.initialUsers != null && !widget.showAsSuggestedTextInputWidget!
                        ? listSource.contains(widget.initialUsers)
                            ? listSource.firstWhere((element) => element.id == widget.initialUsers!.id)
                            : listSource[0]
                        : listSource[0];
                  }
                  if ((widget.onItemPressed != null && widget.showAsDropDown == true) || widget.press == true) widget.onItemPressed!(selectedUsers);

                  isLoading = false;
                })
              })
          .onError((error, stackTrace) => {
                setState(() {
                  isLoading = false;
                })
              });
    });
  }

  void ajouter() {
    /*Fonctions().showWidgetAsDialog(
      context: context,
      title: "Ajout de Users",
      widget: Formulaire(
          contextFormulaire: context,
          successCallBack: () {
            reloadPage();
          }).saveUsersForm(),
    );*/
  }

  void modifier({required Users users}) {
    /* Fonctions().showWidgetAsDialog(
        context: context,
        title: "Modification",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).saveUsersForm(objectUsers: users));*/
  }

  void supprimer({required Users users}) {
    /*Fonctions().showWidgetAsDialog(
        context: context,
        title: "Supression",
        widget: Formulaire(
            contextFormulaire: context,
            successCallBack: () {
              reloadPage();
            }).dialogForDeleteObject(objectToDelete: users, url: Url.usersDeleteUrl));*/
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
            Fonctions().removeAccents(element.pays_id!.toString()).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.nom!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.prenom!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.genre!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.adresse!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.quartier!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.ville!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.mail!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.code_whatsapp!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.code_telephone!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.whatsapp!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.telephone!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.solde!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.code_secret!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.ip_adresse!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.statut!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.type_user!).toLowerCase().contains(themeRecherche) ||
            Fonctions().removeAccents(element.date_enregistrement!).toLowerCase().contains(themeRecherche)))
        .toList();

    if (widget.showOnlyValidated == true) {
      list.removeWhere((element) => element.isNonVerifier);
    }

    return Scaffold(
      backgroundColor: widget.backColor ?? (widget.showAsDropDown == true ? Colors.transparent : Colors.white),
      appBar: widget.showAppBar == true ? Fonctions().defaultAppBar(context: context, titre: "${widget.title != null ? widget.title : ""}") : null,
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
                              children: [const Expanded(child: Text("Aucune donnée trouvée")), dropDownAction(users: selectedUsers)],
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
            initialTagSelectedList: widget.initialUsers != null ? widget.initialUsers!.id!.toString().split("~|~").toList() : null,
            suggestionsList: list.map((e) => e.id!.toString()).toList(),
            onChanged: (value) {
              if (widget.getSuggestedValue != null) {
                widget.getSuggestedValue!(value);
              }
            },
          ),
        ),
        dropDownAction(users: selectedUsers)
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
          children: list.map((users) {
            return widget.buildCustomItemView != null
                ? widget.buildCustomItemView!(users) as Widget
                : VueUsers(
                    users: users,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedUsers) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedUsers);
                            setState(() {
                              selectedIndex = list.indexOf(selectedUsers);
                            });
                          }
                        : null,
                    isSelected: selectedIndex == list.indexOf(users),
                    optionWidget: dropDownAction(users: users),
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
                : VueUsers(
                    users: actualite,
                    reloadPage: reloadPage,
                    onPressed: widget.onItemPressed != null
                        ? (selectedActualite) {
                            if (widget.onItemPressed != null) widget.onItemPressed!(selectedActualite);
                          }
                        : null,
                    optionWidget: dropDownAction(users: actualite),
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
            initialObject: selectedUsers,
            listObjet: list,
            title: widget.title,
            canSearch: widget.canSearchInDropdown!,
            canMultiSelected: widget.canMultiselected!,
            onChangedDropDownValue: (value) {
              setState(() {
                selectedUsers = value;
              });
              if (widget.onItemPressed != null) widget.onItemPressed!(selectedUsers);
            },
            buildItem: (users) {
              users = users as Users;
              return widget.buildCustomItemView != null
                  ? widget.buildCustomItemView!(users) as Widget
                  : NDropDownModelWidget(
                      title: "${users.id}",
                    );
            },
          ),
        ),
        dropDownAction(users: selectedUsers)
      ],
    );
  }

  Widget dropDownAction({required Users users, bool onError = false}) {
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
                  modifier(users: users);
                } else if (value == 3) {
                  supprimer(users: users);
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
