import 'package:example/models/flows_result.dart';
import 'package:flutter/material.dart';

Future<void> showFlowsResultsBottomSheet(
    BuildContext context,
    List<FlowsResult> list,
    void Function(VoidCallback fn) setState,
    ValueNotifier<String> flow) async
{
  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      final height = MediaQuery.sizeOf(sheetContext).height * 0.5;
      return SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Flujos disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('No hay resultados'))
                  : ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, index) {
                        final item = list[index];
                        return ListTile(
                          title: Text(item.name.isEmpty ? '(sin nombre)' : item.name),
                          subtitle: Text(
                            [
                              if (item.id.isNotEmpty) item.id,
                              if (item.operationType.isNotEmpty) item.operationType,
                            ].join(' · '),
                          ),
                          onTap: () {
                            setState(() {
                              flow.value = item.id;
                            });
                            Navigator.of(sheetContext).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
