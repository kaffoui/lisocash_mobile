import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noyaux/constants/fonctions.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:noyaux/models/Operation.dart';
import 'package:noyaux/models/Pays.dart';
import 'package:noyaux/services/Preferences.dart';
import 'package:noyaux/widgets/N_ExpandableWidget.dart';

class AppStatsPage extends StatefulWidget {
  const AppStatsPage({super.key});

  @override
  State<AppStatsPage> createState() => _AppStatsPageState();
}

class _AppStatsPageState extends State<AppStatsPage> {
  String monday = "Monday",
      tuesday = "Tuesday",
      wednesday = "Wednesday",
      thursday = "Thursday",
      friday = "Friday",
      saturday = "Saturday",
      sunday = "Sunday";

  Pays? paysUsers;

  double mn_t = 0, te_t = 0, wd_t = 0, tu_t = 0, fr_t = 0, st_t = 0, sn_t = 0;
  double mn_d = 0, te_d = 0, wd_d = 0, tu_d = 0, fr_d = 0, st_d = 0, sn_d = 0;
  double mn_r = 0, te_r = 0, wd_r = 0, tu_r = 0, fr_r = 0, st_r = 0, sn_r = 0;
  double mn_re = 0, te_re = 0, wd_re = 0, tu_re = 0, fr_re = 0, st_re = 0, sn_re = 0;

  List<Operation> all_operation = [];
  List<Operation> op_t = [];
  List<Operation> op_d = [];
  List<Operation> op_r = [];
  List<Operation> op_re = [];

  late ThemeData theme;

  void getDataSetNbr() async {
    paysUsers = await Fonctions().getPaysFromIp();
    await Preferences().getIdUsers().then((id) async {
      await Preferences().getOperationListFromLocal(user_id_from: id).then((value) async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (value.isNotEmpty) {
            all_operation.clear();
            all_operation.addAll(value);

            formatDataToStats();
          }
        });
      });
    });
  }

  void formatDataToStats() {
    setState(() {
      if (all_operation.isNotEmpty) {
        op_t.clear();
        op_t.addAll(all_operation.where((element) => element.isTransfert).toList());
        op_d.clear();
        op_d.addAll(all_operation.where((element) => element.isDepot).toList());
        op_r.clear();
        op_r.addAll(all_operation.where((element) => element.isRetrait).toList());
        op_re.clear();
        op_re.addAll(all_operation.where((element) => element.isRechargement).toList());
      }

      if (op_t.isNotEmpty) {
        mn_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == monday.toLowerCase()).toList().length}")!;
        te_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == tuesday.toLowerCase()).toList().length}")!;
        wd_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == wednesday.toLowerCase()).toList().length}")!;
        tu_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == thursday.toLowerCase()).toList().length}")!;
        fr_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == friday.toLowerCase()).toList().length}")!;
        st_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == saturday.toLowerCase()).toList().length}")!;
        sn_t = double.tryParse(
            "${op_t.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == sunday.toLowerCase()).toList().length}")!;
      }

      if (op_d.isNotEmpty) {
        mn_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == monday.toLowerCase()).toList().length}")!;
        te_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == tuesday.toLowerCase()).toList().length}")!;
        wd_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == wednesday.toLowerCase()).toList().length}")!;
        tu_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == thursday.toLowerCase()).toList().length}")!;
        fr_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == friday.toLowerCase()).toList().length}")!;
        st_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == saturday.toLowerCase()).toList().length}")!;
        sn_d = double.tryParse(
            "${op_d.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == sunday.toLowerCase()).toList().length}")!;
      }

      if (op_r.isNotEmpty) {
        mn_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == monday.toLowerCase()).toList().length}")!;
        te_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == tuesday.toLowerCase()).toList().length}")!;
        wd_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == wednesday.toLowerCase()).toList().length}")!;
        tu_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == thursday.toLowerCase()).toList().length}")!;
        fr_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == friday.toLowerCase()).toList().length}")!;
        st_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == saturday.toLowerCase()).toList().length}")!;
        sn_r = double.tryParse(
            "${op_r.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == sunday.toLowerCase()).toList().length}")!;
      }

      if (op_re.isNotEmpty) {
        mn_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == monday.toLowerCase()).toList().length}")!;
        te_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == tuesday.toLowerCase()).toList().length}")!;
        wd_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == wednesday.toLowerCase()).toList().length}")!;
        tu_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == thursday.toLowerCase()).toList().length}")!;
        fr_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == friday.toLowerCase()).toList().length}")!;
        st_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == saturday.toLowerCase()).toList().length}")!;
        sn_re = double.tryParse(
            "${op_re.where((e) => DateFormat('EEEE').format(Fonctions().stringToDateTime(e.date_enregistrement!)).toLowerCase() == sunday.toLowerCase()).toList().length}")!;
      }

      print("t: ${op_t.length}");
      print("t1: ${op_d.length}");
      print("t2: ${op_r.length}");
      print("t3: ${op_re.length}");
    });
  }

  @override
  void initState() {
    getDataSetNbr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Légendes",
                          style: Style.defaultTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Mn: Monday, Te: Tuesday, Wd: Wednesday, Tu: Thursday, Fr: Friday, St: Saturday, Su: Sunday",
                          style: Style.defaultTextStyle(
                            textSize: 10.0,
                            textOverflow: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          NExpandableWidget(
            title: "Transfert(s) effectué(s)",
            isExpanded: true,
            child: AspectRatio(
              aspectRatio: 1.6,
              child: _BarChart(mn_t, te_t, wd_t, tu_t, fr_t, st_t, sn_t),
            ),
          ),
          NExpandableWidget(
            title: "Dépôt(s) effectué(s)",
            isExpanded: true,
            child: AspectRatio(
              aspectRatio: 1.6,
              child: _BarChart(mn_d, te_d, wd_d, tu_d, fr_d, st_d, sn_d),
            ),
          ),
          NExpandableWidget(
            title: "Retrait(s) effectué(s)",
            isExpanded: true,
            child: AspectRatio(
              aspectRatio: 1.6,
              child: _BarChart(mn_r, te_r, wd_r, tu_r, fr_r, st_r, sn_r),
            ),
          ),
          if (paysUsers != null && paysUsers?.continent!.toLowerCase() != "africa")
            NExpandableWidget(
              title: "Rechargement(s) effectué(s)",
              isExpanded: true,
              child: AspectRatio(
                aspectRatio: 1.6,
                child: _BarChart(mn_re, te_re, wd_re, tu_re, fr_re, st_re, sn_re),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarChart extends StatefulWidget {
  final double mn, te, wd, tu, fr, st, sn;
  const _BarChart(this.mn, this.te, this.wd, this.tu, this.fr, this.st, this.sn);

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> {
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: EdgeInsets.all(4),
          tooltipMargin: 4,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              Style.defaultTextStyle(textSize: 10.0, textColor: Colors.white),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = Style.defaultTextStyle(textSize: 10.0);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          theme.colorScheme.secondary,
          theme.primaryColor,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: widget.mn,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: widget.te,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: widget.wd,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: widget.tu,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: widget.fr,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: widget.st,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: widget.sn,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}
