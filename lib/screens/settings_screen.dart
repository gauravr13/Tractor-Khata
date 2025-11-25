import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/work_provider.dart';
import '../providers/driver_provider.dart';
import '../services/localization_service.dart';
import 'driver_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkProvider>(context, listen: false).loadDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('settings.title')),
      ),
      body: ListView(
        children: [
          Consumer<DriverProvider>(
            builder: (context, driverProvider, child) {
              final profile = driverProvider.profile;
              return UserAccountsDrawerHeader(
                accountName: Text(profile.name),
                accountEmail: Text(profile.email ?? profile.phone ?? ''),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: profile.photoPath != null
                        ? (profile.photoPath!.startsWith('http')
                            ? NetworkImage(profile.photoPath!) as ImageProvider
                            : File(profile.photoPath!).existsSync() ? FileImage(File(profile.photoPath!)) : null)
                        : null,
                    child: profile.photoPath == null
                        ? const Icon(Icons.person, size: 50, color: Colors.green)
                        : null,
                  ),
                ),
                decoration: const BoxDecoration(color: Colors.green),
              );
            },
          ),

          // Driver Profile Link
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(locale.translate('settings.driver_profile_title')),
            subtitle: Text(locale.translate('settings.driver_profile_subtitle')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
              );
            },
          ),

          const Divider(),

          // Language Switcher Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.translate('settings.language'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Consumer<LocaleProvider>(
                    builder: (context, localeProvider, child) {
                      return Row(
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: () {
                                  localeProvider.setLocale(const Locale('hi'));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: localeProvider.locale.languageCode == 'hi' 
                                      ? Colors.green 
                                      : Colors.grey.shade300,
                                  foregroundColor: localeProvider.locale.languageCode == 'hi' 
                                      ? Colors.white 
                                      : Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: localeProvider.locale.languageCode == 'hi' ? 4 : 1,
                                ),
                                child: Text(
                                  locale.translate('settings.hindi'),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: () {
                                  localeProvider.setLocale(const Locale('en'));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: localeProvider.locale.languageCode == 'en' 
                                      ? Colors.green 
                                      : Colors.grey.shade300,
                                  foregroundColor: localeProvider.locale.languageCode == 'en' 
                                      ? Colors.white 
                                      : Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: localeProvider.locale.languageCode == 'en' ? 4 : 1,
                                ),
                                child: Text(
                                  locale.translate('settings.english'),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Global Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<WorkProvider>(
                  builder: (context, workProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.translate('settings.global_summary'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.translate('settings.total_works')),
                            Text(
                              '${workProvider.totalWorkCountGlobal}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.translate('settings.total_work_amount')),
                            Text(
                              '₹${workProvider.totalEarnings.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.translate('settings.total_received')),
                            Text(
                              '₹${workProvider.totalReceived.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(locale.translate('settings.total_pending')),
                            Text(
                              '₹${workProvider.totalPending.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: Text(locale.translate('settings.manage_rate_card')),
            subtitle: Text(locale.translate('settings.rate_card_subtitle')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/rate_card');
            },
          ),

          const Divider(),

          // About Section with full details
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.green),
            title: Text(
              locale.translate('settings.about'),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  locale.translate('settings.version'),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    children: [
                      TextSpan(text: locale.translate('settings.made_by')),
                      const TextSpan(
                        text: ' Gaurav Raikwar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'gauravraikwarji@gmail.com',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(locale.translate('settings.logout'), style: const TextStyle(color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(locale.translate('settings.logout_confirm_title')),
                  content: Text(locale.translate('settings.logout_confirm_message')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(locale.translate('common.cancel')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(locale.translate('settings.logout'), style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
