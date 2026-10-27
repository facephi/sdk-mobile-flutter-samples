import 'package:flutter/material.dart';

Future<void> showDocumentDataSheet(BuildContext context, Map<String, dynamic> data)
{
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (sheetContext)
    {
      final ColorScheme scheme  = Theme.of(sheetContext).colorScheme;
      final double height       = MediaQuery.sizeOf(sheetContext).height * 0.6;
      final List<String> keys   = data.keys.toList();

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
                decoration: BoxDecoration(color: scheme.outline.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(2))
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Datos del documento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Expanded(
              child: keys.isEmpty
                  ? const Center(child: Text('No hay datos'))
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.paddingOf(sheetContext).bottom),
                      itemCount: keys.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: scheme.outline.withValues(alpha: 0.2)),
                      itemBuilder: (context, index) {
                        final key = keys[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.55))),
                              const SizedBox(height: 2),
                              Text('${data[key]}', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
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
