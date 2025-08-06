import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double? headingRowHeight;
  final double? dataRowHeight;
  final bool showCheckboxColumn;

  const CustomDataTable({
    required this.columns,
    required this.rows,
    this.headingRowHeight,
    this.dataRowHeight,
    this.showCheckboxColumn = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: rows,
        headingRowHeight: headingRowHeight ?? 56,
        dataRowHeight: dataRowHeight ?? 48,
        showCheckboxColumn: showCheckboxColumn,
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        dataRowColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : Colors.transparent,
        ),
      ),
    );
  }
}