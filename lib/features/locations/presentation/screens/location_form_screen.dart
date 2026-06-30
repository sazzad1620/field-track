import 'package:field_track/core/constants/shell_layout.dart';
import 'package:field_track/core/di/injection.dart';
import 'package:field_track/core/theme/app_colors.dart';
import 'package:field_track/features/locations/domain/entities/location.dart';
import 'package:field_track/features/locations/presentation/bloc/location_form_bloc.dart';
import 'package:field_track/features/locations/presentation/bloc/location_form_event.dart';
import 'package:field_track/features/locations/presentation/bloc/location_form_state.dart';
import 'package:field_track/features/locations/presentation/widgets/geofence_radius_slider.dart';
import 'package:field_track/features/locations/presentation/widgets/location_active_switch.dart';
import 'package:field_track/features/locations/presentation/widgets/location_delete_button.dart';
import 'package:field_track/features/locations/presentation/widgets/location_dashed_button.dart';
import 'package:field_track/features/locations/presentation/widgets/location_form_field.dart';
import 'package:field_track/features/locations/presentation/widgets/location_map_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LocationFormScreen extends StatefulWidget {
  final Location? existing;

  const LocationFormScreen({super.key, this.existing});

  @override
  State<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends State<LocationFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  double _radiusM = 150;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameController = TextEditingController(text: e?.locationName ?? '');
    _latController = TextEditingController(
      text: e?.latitude.toString() ?? '25.2048',
    );
    _lngController = TextEditingController(
      text: e?.longitude.toString() ?? '55.2708',
    );
    _radiusM = e?.radiusM.toDouble() ?? 150;
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final name = _nameController.text.trim();
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());

    if (name.isEmpty || lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }

    context.read<LocationFormBloc>().add(
          LocationFormSubmitted(
            locationName: name,
            latitude: lat,
            longitude: lng,
            radiusM: _radiusM.round(),
            isActive: _isActive,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return BlocProvider(
      create: (_) => LocationFormBloc(sl())
        ..add(LocationFormStarted(existing: widget.existing)),
      child: BlocConsumer<LocationFormBloc, LocationFormState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.latitude != curr.latitude ||
            prev.longitude != curr.longitude,
        listener: (context, state) {
          _latController.text = state.latitude.toStringAsFixed(4);
          _lngController.text = state.longitude.toStringAsFixed(4);
          if (state.status == LocationFormStatus.success ||
              state.status == LocationFormStatus.deleted) {
            context.pop(true);
          } else if (state.status == LocationFormStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final saving = state.status == LocationFormStatus.saving ||
              state.status == LocationFormStatus.loading;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      ShellLayout.contentHorizontalPadding,
                      8,
                      ShellLayout.contentHorizontalPadding,
                      14,
                    ),
                    child: Row(
                      children: [
                        Material(
                          color: AppColors.surface,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: saving ? null : () => context.pop(),
                            borderRadius: BorderRadius.circular(12),
                            child: const SizedBox(
                              width: 38,
                              height: 38,
                              child: Icon(
                                Icons.chevron_left,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit location' : 'New location',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              height: 22 / 18,
                              letterSpacing: -0.36,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        ShellLayout.contentHorizontalPadding,
                        4,
                        ShellLayout.contentHorizontalPadding,
                        92,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LocationMapPreview(isEditing: isEditing),
                          if (!isEditing) ...[
                            const SizedBox(height: 4),
                            LocationDashedButton(
                              onPressed: saving
                                  ? null
                                  : () => context
                                      .read<LocationFormBloc>()
                                      .add(const LocationFormUseCurrentLocation()),
                              icon: Icons.my_location_outlined,
                              label: 'Use my current location',
                            ),
                          ],
                          const SizedBox(height: 14),
                          LocationFormField(
                            label: 'Location name',
                            controller: _nameController,
                            hint: 'Downtown Branch',
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: LocationFormField(
                                    label: 'Latitude',
                                    controller: _latController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: LocationFormField(
                                    label: 'Longitude',
                                    controller: _lngController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GeofenceRadiusSlider(
                            value: _radiusM,
                            onChanged: saving
                                ? null
                                : (v) => setState(() => _radiusM = v),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              26,
                              0,
                              isEditing ? 16 : 22,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Active',
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w600,
                                          height: 18 / 14.5,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Workers can check in here',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          height: 15 / 12.5,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                LocationActiveSwitch(
                                  value: _isActive,
                                  onChanged: saving
                                      ? null
                                      : (v) => setState(() => _isActive = v),
                                ),
                              ],
                            ),
                          ),
                          if (isEditing)
                            Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FilledButton(
                                    onPressed:
                                        saving ? null : () => _submit(context),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size.fromHeight(52),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      saving ? 'Saving...' : 'Update location',
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        height: 19 / 15.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 11),
                                  LocationDeleteButton(
                                    onPressed: saving
                                        ? null
                                        : () => _confirmDelete(context),
                                  ),
                                ],
                              ),
                            )
                          else
                            FilledButton(
                              onPressed: saving ? null : () => _submit(context),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                saving ? 'Saving...' : 'Save location',
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  height: 19 / 15.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete location?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<LocationFormBloc>().add(const LocationFormDeleteRequested());
    }
  }
}
