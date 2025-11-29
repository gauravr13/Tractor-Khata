import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_provider.dart';
import '../services/localization_service.dart';
import 'add_work_type_screen.dart';
import '../database/database.dart';
import '../widgets/delete_dialog.dart';

class RateCardScreen extends StatefulWidget {
  const RateCardScreen({super.key});

  @override
  State<RateCardScreen> createState() => _RateCardScreenState();
}

class _RateCardScreenState extends State<RateCardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkProvider>(context, listen: false).loadWorkTypes();
    });
  }

  void _deleteWorkType(WorkType workType) async {
    final locale = AppLocalizations.of(context)!;
    final confirm = await showDeleteDialog(
      context,
      title: locale.translate('rate_card.delete_confirm_title'),
      content: locale.translate('rate_card.delete_confirm_message', params: {'name': workType.name}),
    );

    if (confirm == true) {
      if (!mounted) return;
      await Provider.of<WorkProvider>(context, listen: false).deleteWorkType(workType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background
      appBar: AppBar(
        title: Text(locale.translate('rate_card.title')),
        elevation: 0,
      ),
      body: Consumer<WorkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.workTypes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    locale.translate('rate_card.no_work_types'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.workTypes.length,
            itemBuilder: (context, index) {
              final workType = provider.workTypes[index];
              return Card(
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.agriculture_rounded, color: Colors.blue),
                  ),
                  title: Text(
                    workType.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '₹${workType.ratePerHour.toStringAsFixed(0)} / ${locale.translate('add_work.hour')}',
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_rounded, color: Colors.red.shade400),
                    onPressed: () => _deleteWorkType(workType),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkTypeScreen()),
          ).then((_) {
            Provider.of<WorkProvider>(context, listen: false).loadWorkTypes();
          });
        },
        label: Text(locale.translate('rate_card.add_work_type'), style: const TextStyle(fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}
