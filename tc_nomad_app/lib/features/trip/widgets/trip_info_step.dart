import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/utils/validators.dart';

/// Step 1: Trip Info
/// Destination, dates, trip type, travel type, airline, travelers, gender
class TripInfoStep extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> tripData;

  const TripInfoStep({
    super.key,
    required this.onNext,
    required this.tripData,
  });

  @override
  State<TripInfoStep> createState() => _TripInfoStepState();
}

class _TripInfoStepState extends State<TripInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _destinationController;
  late DateTime _startDate;
  late DateTime _endDate;
  String _tripType = AppConstants.tripTypes.first;
  String _travelType = AppConstants.travelTypes.first;
  String? _airline;
  int _travelers = 1;
  String _gender = 'Male';

  final List<String> _airlines = [
    'American Airlines',
    'Delta Air Lines',
    'United Airlines',
    'Lufthansa',
    'British Airways',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController(
      text: widget.tripData['destination'] ?? '',
    );
    _startDate = widget.tripData['startDate'] ?? DateTime.now().add(const Duration(days: 7));
    _endDate = widget.tripData['endDate'] ?? DateTime.now().add(const Duration(days: 10));
    _tripType = widget.tripData['tripType'] ?? _tripType;
    _travelType = widget.tripData['travelType'] ?? _travelType;
    _airline = widget.tripData['airline'];
    _travelers = widget.tripData['travelers'] ?? _travelers;
    _gender = widget.tripData['gender'] ?? _gender;
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    widget.tripData['destination'] = _destinationController.text;
    widget.tripData['startDate'] = _startDate;
    widget.tripData['endDate'] = _endDate;
    widget.tripData['tripType'] = _tripType;
    widget.tripData['travelType'] = _travelType;
    widget.tripData['airline'] = _airline;
    widget.tripData['travelers'] = _travelers;
    widget.tripData['gender'] = _gender;

    widget.onNext();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 3));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        children: [
          Text(
            'Where are you going?',
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Destination
          CustomTextField(
            label: 'Destination',
            hint: 'City, Country',
            controller: _destinationController,
            prefixIcon: Icons.location_on_outlined,
            validator: (value) => Validators.minLength(value, 2, fieldName: 'Destination'),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Travel Dates
          Text(
            'Travel Dates',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Start Date',
                  date: _startDate,
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: _buildDateField(
                  label: 'End Date',
                  date: _endDate,
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Trip Type
          Text(
            'Trip Type',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          DropdownButtonFormField<String>(
            value: _tripType,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.category_outlined),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            items: AppConstants.tripTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => setState(() => _tripType = value!),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Travel Type
          Text(
            'How are you traveling?',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          DropdownButtonFormField<String>(
            value: _travelType,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            items: AppConstants.travelTypes.map((type) {
              String emoji = type == 'Airplane' ? '✈️' : type == 'Car' ? '🚗' : type == 'Train' ? '🚆' : '🚌';
              return DropdownMenuItem(value: type, child: Text('$emoji $type'));
            }).toList(),
            onChanged: (value) => setState(() => _travelType = value!),
          ),
          if (_travelType == 'Airplane') ...[
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Strict weight & size limits apply',
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
            ),
          ],
          const SizedBox(height: AppConstants.spacingLg),

          // Airline (only for airplane)
          if (_travelType == 'Airplane') ...[
            Text(
              'Airline',
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            DropdownButtonFormField<String>(
              value: _airline,
              hint: const Text('Select airline'),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.flight_outlined),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  borderSide: const BorderSide(color: AppColors.border, width: 2),
                ),
              ),
              items: _airlines.map((airline) {
                return DropdownMenuItem(value: airline, child: Text(airline));
              }).toList(),
              onChanged: (value) => setState(() => _airline = value),
            ),
            const SizedBox(height: AppConstants.spacingLg),
          ],

          // Number of Travelers
          Text(
            'Number of Travelers',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          DropdownButtonFormField<int>(
            value: _travelers,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.people_outline),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            items: List.generate(4, (index) {
              int count = index + 1;
              String label = count == 1 ? 'Just me' : '$count travelers';
              if (count == 4) label = '4+ travelers';
              return DropdownMenuItem(value: count, child: Text(label));
            }).toList(),
            onChanged: (value) => setState(() => _travelers = value!),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Gender
          Text(
            'Gender',
            style: AppTextStyles.labelLarge,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Mixed', child: Text('Mixed group')),
              DropdownMenuItem(value: 'Prefer not to say', child: Text('Prefer not to say')),
            ],
            onChanged: (value) => setState(() => _gender = value!),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Continue Button
          GradientButton(
            text: 'Continue',
            onPressed: _handleNext,
          ),
          const SizedBox(height: AppConstants.spacingLg),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.border, width: 2),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  '${date.month}/${date.day}/${date.year}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
