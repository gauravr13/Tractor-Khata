import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/farmer_provider.dart';
import '../providers/work_provider.dart';
import '../services/localization_service.dart';
import 'add_work_screen.dart';
import 'add_payment_screen.dart';
import 'add_farmer_screen.dart';

class FarmerProfileScreen extends StatefulWidget {
  final int farmerId;

  const FarmerProfileScreen({super.key, required this.farmerId});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    await Provider.of<WorkProvider>(context, listen: false).loadTransactionsForFarmer(widget.farmerId);
  }

  Future<void> _deleteFarmer(Farmer farmer) async {
    final locale = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(locale.translate('farmer_profile.delete_confirm_title')),
        content: Text(locale.translate('farmer_profile.delete_confirm_message', params: {'name': farmer.name})),
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

    if (confirm == true) {
      if (!mounted) return;
      await Provider.of<FarmerProvider>(context, listen: false).deleteFarmer(farmer);
      
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Consumer<FarmerProvider>(
      builder: (context, farmerProvider, child) {
        final farmer = farmerProvider.farmers.firstWhere(
          (f) => f.id == widget.farmerId,
          orElse: () => throw Exception('Farmer not found'),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(farmer.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFarmerScreen(farmerToEdit: farmer)),
                  ).then((_) => _loadData());
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteFarmer(farmer),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildHeader(context, farmer),
              const Divider(height: 1),
              Expanded(
                child: Consumer<WorkProvider>(
                  builder: (context, workProvider, child) {
                    if (workProvider.isLoading) {
                      return Center(child: Text(locale.translate('common.loading')));
                    }

                    if (workProvider.transactions.isEmpty) {
                      return Center(child: Text(locale.translate('farmer_profile.no_history')));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 8),
                      itemCount: workProvider.transactions.length,
                      cacheExtent: 1000, // Preload for smooth scrolling
                      itemBuilder: (context, index) {
                        final item = workProvider.transactions[index];
                        if (item is Work) {
                          return _buildWorkCard(context, item, workProvider.workTypes);
                        } else if (item is Payment) {
                          return _buildPaymentCard(context, item);
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FloatingActionButton.extended(
                    heroTag: 'payment',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPaymentScreen(farmerId: farmer.id)),
                      ).then((_) => _loadData());
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    label: Text(locale.translate('farmer_profile.receive_payment')),
                    icon: const Icon(Icons.currency_rupee),
                    elevation: 4,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FloatingActionButton.extended(
                    heroTag: 'work',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddWorkScreen(farmerId: farmer.id)),
                      ).then((_) => _loadData());
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    label: Text(locale.translate('farmer_profile.add_work')),
                    icon: const Icon(Icons.add_task),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Farmer farmer) {
    final locale = AppLocalizations.of(context)!;
    return Consumer<WorkProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'avatar_${farmer.id}',
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(farmer.name[0].toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(farmer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        if (farmer.phone != null) Text(farmer.phone!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(locale.translate('farmer_profile.works_count', params: {'count': provider.farmerWorkCount.toString()}), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.translate('farmer_profile.pending'), style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('₹${provider.farmerPendingAmount.toStringAsFixed(0)}', style: TextStyle(color: Colors.red.shade900, fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.translate('farmer_profile.received'), style: TextStyle(color: Colors.green.shade700, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('₹${provider.farmerTotalReceived.toStringAsFixed(0)}', style: TextStyle(color: Colors.green.shade900, fontSize: 18, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkCard(BuildContext context, Work work, List<WorkType> types) {
    final locale = AppLocalizations.of(context)!;
    final typeName = work.customWorkName ?? 
        types.firstWhere((t) => t.id == work.workTypeId, orElse: () => WorkType(id: -1, name: 'Unknown', ratePerHour: 0, createdAt: DateTime.now(), updatedAt: DateTime.now())).name;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkScreen(farmerId: work.farmerId, workToEdit: work)),
          ).then((_) => _loadData());
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.agriculture, color: Colors.blue, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, height: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM', locale.locale.languageCode).format(work.workDate),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${work.durationInMinutes} ${locale.translate('add_work.minutes')}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${work.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              if (work.notes != null && work.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Text(
                    work.notes!,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment) {
    final locale = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPaymentScreen(farmerId: payment.farmerId, paymentToEdit: payment)),
          ).then((_) => _loadData());
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.currency_rupee, color: Colors.green, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.translate('farmer_profile.payment_received'),
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, height: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM yyyy', locale.locale.languageCode).format(payment.date),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${payment.amount.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              if (payment.notes != null && payment.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Text(
                    payment.notes!,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}





