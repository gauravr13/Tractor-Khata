import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../data/local/database.dart';
import '../../../core/providers/farmer_provider.dart';
import '../../../core/providers/work_provider.dart';
import '../../../core/services/localization_service.dart';
import '../work/add_work_screen.dart';
import '../work/add_payment_screen.dart';
import 'add_farmer_screen.dart';
import '../../components/list_items/staggered_list_item.dart';
import '../../components/buttons/scale_button.dart';
import '../../components/dialogs/delete_dialog.dart';
import '../../../core/utils/color_utils.dart';

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
    final workProvider = Provider.of<WorkProvider>(context, listen: false);
    await Future.wait([
      workProvider.loadTransactionsForFarmer(widget.farmerId),
      workProvider.loadWorkTypes(),
    ]);
  }

  Future<void> _deleteFarmer(Farmer farmer) async {
    final locale = AppLocalizations.of(context)!;
    final confirm = await showDeleteDialog(
      context,
      title: locale.translate('farmer_profile.delete_confirm_title'),
      content: locale.translate('farmer_profile.delete_confirm_message', params: {'name': farmer.name}),
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
    final farmerProvider = Provider.of<FarmerProvider>(context);
    
    // Handle case where farmer might be deleted
    if (!farmerProvider.farmers.any((f) => f.id == widget.farmerId)) {
      return const SizedBox.shrink();
    }

    final farmer = farmerProvider.farmers.firstWhere((f) => f.id == widget.farmerId);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(farmer.name),
        elevation: 0,
        actions: [
          ScaleButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddFarmerScreen(farmerToEdit: farmer, isBottomSheet: true),
              ).then((_) => _loadData());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.edit_rounded),
            ),
          ),
          ScaleButton(
            onPressed: () => _deleteFarmer(farmer),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_rounded),
            ),
          ),
        ],
      ),
      body: Consumer<WorkProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildHeader(context, farmer),
              Expanded(
                child: provider.transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_rounded, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              locale.translate('farmer_profile.no_transactions'),
                              style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100, top: 16), // Space for FABs
                        itemCount: provider.transactions.length,
                        itemBuilder: (context, index) {
                          final item = provider.transactions[index];
                          if (item is Work) {
                            return _buildWorkCard(context, item, provider.workTypes);
                          } else if (item is Payment) {
                            return _buildPaymentCard(context, item);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(context, farmer),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context, Farmer farmer) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPaymentScreen(farmerId: farmer.id)),
                  ).then((_) => _loadData());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.payments_outlined, size: 24),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    locale.translate('farmer_profile.receive_payment'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddWorkScreen(farmerId: farmer.id)),
                  ).then((_) => _loadData());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Matches Tractor icon color
                  foregroundColor: Colors.white,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.agriculture_rounded, size: 24), // Tractor icon
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    locale.translate('farmer_profile.add_work'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Farmer farmer) {
    final locale = AppLocalizations.of(context)!;
    return Consumer<WorkProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: ColorUtils.getAvatarColor(farmer.name).withValues(alpha: 0.35),
                    child: Text(
                      farmer.name[0].toUpperCase(), 
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: ColorUtils.getAvatarColor(farmer.name)
                      )
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(farmer.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        if (farmer.phone != null) 
                          Row(
                            children: [
                              Icon(Icons.phone_rounded, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(farmer.phone!, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        locale.translate('farmer_profile.works_count', params: {'count': provider.farmerWorkCount.toString()}), 
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.translate('farmer_profile.pending'), style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('₹${provider.farmerPendingAmount.toStringAsFixed(0)}', style: TextStyle(color: Colors.red.shade900, fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.translate('farmer_profile.received'), style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('₹${provider.farmerTotalReceived.toStringAsFixed(0)}', style: TextStyle(color: Colors.green.shade900, fontSize: 20, fontWeight: FontWeight.bold)),
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
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.agriculture_rounded, color: Colors.blue, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                typeName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                              ),
                            ),
                            Text(
                              '₹${work.totalAmount.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM', locale.locale.languageCode).format(work.workDate),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              '${work.durationInMinutes} ${locale.translate('add_work.minutes')}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        if (work.notes != null && work.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.edit_note_rounded, size: 16, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    work.notes!,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.3),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment) {
    final locale = AppLocalizations.of(context)!;
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.payments_outlined, color: Colors.green, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.translate('farmer_profile.payment_received'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
                            ),
                            Text(
                              '₹${payment.amount.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM yyyy', locale.locale.languageCode).format(payment.date),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        if (payment.notes != null && payment.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.edit_note_rounded, size: 16, color: Colors.grey.shade500),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    payment.notes!,
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.3),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
