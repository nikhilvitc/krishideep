import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../services/crop_service.dart';
import '../services/location_service.dart';
import '../models/crop_advice.dart';
import 'crop_result_screen.dart';

class CropAdviceScreen extends StatefulWidget {
  const CropAdviceScreen({super.key});

  @override
  State<CropAdviceScreen> createState() => _CropAdviceScreenState();
}

class _CropAdviceScreenState extends State<CropAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _soilPHController = TextEditingController();
  final _soilMoistureController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _locationController = TextEditingController();

  final CropService _cropService = CropService();
  final LocationService _locationService = LocationService();

  bool _isLoading = false;
  bool _isGettingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crop_advice_form'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header Card
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.agriculture,
                            size: 48,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'crop_advice_form'.tr(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fill in your field details to get personalized crop recommendations',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Form Fields
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Soil pH
                          TextFormField(
                            controller: _soilPHController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'soil_ph'.tr(),
                              hintText: 'Enter pH value (0-14)',
                              prefixIcon: const Icon(Icons.science),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter soil pH';
                              }
                              double? ph = double.tryParse(value);
                              if (ph == null || ph < 0 || ph > 14) {
                                return 'Please enter valid pH (0-14)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Soil Moisture
                          TextFormField(
                            controller: _soilMoistureController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'soil_moisture'.tr(),
                              hintText: 'Enter moisture percentage (0-100)',
                              prefixIcon: const Icon(Icons.water_drop),
                              suffixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter soil moisture';
                              }
                              double? moisture = double.tryParse(value);
                              if (moisture == null ||
                                  moisture < 0 ||
                                  moisture > 100) {
                                return 'Please enter valid moisture (0-100)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Farm Size
                          TextFormField(
                            controller: _farmSizeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'farm_size'.tr(),
                              hintText: 'Enter farm size',
                              prefixIcon: const Icon(Icons.landscape),
                              suffixText: 'acres',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter farm size';
                              }
                              double? size = double.tryParse(value);
                              if (size == null || size <= 0) {
                                return 'Please enter valid farm size';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Location
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'location'.tr(),
                              hintText: 'Enter your location',
                              prefixIcon: const Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                icon: _isGettingLocation
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.my_location),
                                onPressed: _isGettingLocation
                                    ? null
                                    : _getCurrentLocation,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter location';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _getRecommendation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Analyzing...'),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.analytics),
                                        const SizedBox(width: 8),
                                        Text(
                                          'get_recommendation'.tr(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Card
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Our AI analyzes your soil conditions and location to recommend the best crops for maximum yield and profit.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
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
          ),
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        final address = await _locationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        _locationController.text = address;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get location: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _getRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CropAdviceRequest(
        soilPH: double.parse(_soilPHController.text),
        soilMoisture: double.parse(_soilMoistureController.text),
        farmSize: double.parse(_farmSizeController.text),
        location: _locationController.text,
      );

      final recommendation = await _cropService.getCropRecommendation(request);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CropResultScreen(
            recommendation: recommendation,
            request: request,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get recommendation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _soilPHController.dispose();
    _soilMoistureController.dispose();
    _farmSizeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
