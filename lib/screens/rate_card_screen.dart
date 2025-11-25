import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import '../providers/work_provider.dart';
import '../services/localization_service.dart';

/// Rate Card Screen.
/// Displays a list of work types and their default rates.
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

  Future<void> _deleteWorkType(WorkType workType) async {
    final locale = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.translate('rate_card.delete_confirm_title')),
        content: Text(locale.translate('rate_card.delete_confirm_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(locale.translate('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(locale.translate('common.delete'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await Provider.of<WorkProvider>(context, listen: false).deleteWorkType(workType);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('rate_card.title')),
      ),
      body: Consumer<WorkProvider>(
        builder: (context, provider, child) {
          if (provider.workTypes.isEmpty) {
            return Center(
              child: Text(
                locale.translate('rate_card.no_work_types'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.workTypes.length,
            itemBuilder: (context, index) {
              final workType = provider.workTypes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    workType.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${locale.translate('add_work.rate_per_hour')}: ₹${workType.ratePerHour.toStringAsFixed(0)} / ${locale.translate('rate_card.per_hour')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteWorkType(workType),
                  ),
                  onTap: () {
                    // Edit functionality can be added in future versions
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_work_type');
        },
        label: Text(locale.translate('rate_card.add_work_type')),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
