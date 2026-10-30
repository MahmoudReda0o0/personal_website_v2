import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_button/custom_button.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/core/custom_widgets/custom_text_field/custom_text_field.dart';
import 'package:mivo/core/model/custom_link.dart';
import 'package:mivo/feature/supabase_data/s_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Admin (mobile): create a personal link for a company or a person, and
/// copy any link made before. Opening the link shows `Hi <name>` plus the
/// optional message on the website.
class CustomLinksScreen extends StatefulWidget {
  const CustomLinksScreen({super.key});

  @override
  State<CustomLinksScreen> createState() => _CustomLinksScreenState();
}

class _CustomLinksScreenState extends State<CustomLinksScreen> {
  final _db = SupabaseDatabase.instance;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<CustomLink> _links = const [];
  bool _loadingList = true;
  bool _creating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadLinks() async {
    setState(() => _loadingList = true);
    try {
      final links = await _db.getCustomLinks();
      if (mounted) setState(() => _links = links);
    } catch (e) {
      log('load_custom_links_error: $e');
      _toast('Could not load links. Check your connection.');
    } finally {
      if (mounted) setState(() => _loadingList = false);
    }
  }

  Future<void> _create() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Write a name first.');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _creating = true;
      _error = null;
    });
    try {
      final link = await _db.createCustomLink(
        name: name,
        description: _descriptionController.text,
      );
      _nameController.clear();
      _descriptionController.clear();
      if (!mounted) return;
      setState(() => _links = [link, ..._links]);
      await _copy(link);
    } on PostgrestException catch (e) {
      log('create_custom_link_error: ${e.code} ${e.message}');
      setState(
        () => _error = e.code == '23505'
            ? 'There is already a link for "$name". Copy it from the list.'
            : 'Could not create the link: ${e.message}',
      );
    } catch (e) {
      log('create_custom_link_error: $e');
      setState(() => _error = 'Could not create the link. Try again.');
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _copy(CustomLink link) async {
    await Clipboard.setData(ClipboardData(text: link.url));
    _toast('Link for ${link.name} copied');
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Links')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadLinks,
          child: ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              _buildCreateCard(context),
              SizedBox(height: 28.h),
              const CustomText(
                text: 'Your links',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),
              if (_loadingList)
                const Center(child: CircularProgressIndicator())
              else if (_links.isEmpty)
                const CustomText(
                  text: 'No links yet. Create your first one above.',
                  color: AppColors.lightTextSecondary,
                  fontSize: 14,
                )
              else
                for (final link in _links) _LinkTile(link: link, onCopy: _copy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Create a link',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          const CustomText(
            text: 'They will see "Hi <name> 👋" and your message.',
            color: AppColors.lightTextSecondary,
            fontSize: 13,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: _nameController,
            hintText: 'Name (company or person)',
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.badge_outlined),
            enabled: !_creating,
          ),
          SizedBox(height: 12.h),
          CustomTextField(
            controller: _descriptionController,
            hintText: 'Message for them (optional)',
            minLines: 2,
            maxLines: 4,
            prefixIcon: const Icon(Icons.chat_bubble_outline),
            enabled: !_creating,
          ),
          if (_error != null) ...[
            SizedBox(height: 10.h),
            CustomText(
              text: _error!,
              color: Theme.of(context).colorScheme.error,
              fontSize: 13,
            ),
          ],
          SizedBox(height: 16.h),
          CustomButton(
            text: 'Create link',
            icon: const Icon(Icons.link, size: 20),
            isLoading: _creating,
            onTap: _create,
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.link, required this.onCopy});

  final CustomLink link;
  final ValueChanged<CustomLink> onCopy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: ListTile(
        title: Text(
          link.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (link.description != null)
              Text(
                link.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              link.url,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (!link.isActive)
              const Text(
                'Turned off',
                style: TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
          ],
        ),
        isThreeLine: link.description != null,
        trailing: IconButton(
          tooltip: 'Copy link',
          icon: const Icon(Icons.copy_rounded),
          onPressed: () => onCopy(link),
        ),
        onTap: () => onCopy(link),
      ),
    );
  }
}
