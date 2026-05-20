import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/language_toggle.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.userManagement),
        actions: const [LanguageToggle(), SizedBox(width: 8)],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: l.students),
            Tab(text: l.brigadistas),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _UserList(
            stream: authService.usersStream(role: UserRole.student),
            authService: authService,
          ),
          _UserList(
            stream: authService.usersStream(role: UserRole.brigadista),
            authService: authService,
          ),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final Stream<List<UserModel>> stream;
  final AuthService authService;

  const _UserList({required this.stream, required this.authService});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return StreamBuilder<List<UserModel>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final users = snap.data ?? [];
        if (users.isEmpty) {
          return Center(
            child: Text(
              'No hay usuarios registrados',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final user = users[i];
            return _UserCard(
              user: user,
              onApprove: user.isApproved
                  ? null
                  : () => authService.setUserApproval(user.uid, true),
              onBlock: user.isBlocked
                  ? () => authService.setUserBlocked(user.uid, false)
                  : () => authService.setUserBlocked(user.uid, true),
              l: l,
            );
          },
        );
      },
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onApprove;
  final VoidCallback? onBlock;
  final AppLocalizations l;

  const _UserCard({
    required this.user,
    this.onApprove,
    this.onBlock,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    if (user.isBlocked) {
      statusColor = AppTheme.emergencyRed;
      statusLabel = l.blocked;
    } else if (user.isApproved) {
      statusColor = AppTheme.successGreen;
      statusLabel = l.approved;
    } else {
      statusColor = AppTheme.alertYellow;
      statusLabel = l.pending;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceDark),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.surface,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : null,
            child: user.photoURL == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.navyDark,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(user.email,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onApprove != null)
                _ActionBtn(
                  label: l.approve,
                  color: AppTheme.successGreen,
                  onTap: onApprove!,
                ),
              const SizedBox(height: 6),
              _ActionBtn(
                label: user.isBlocked ? 'Desbloquear' : l.block,
                color: user.isBlocked
                    ? AppTheme.navyDark
                    : AppTheme.emergencyRed,
                onTap: onBlock!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
