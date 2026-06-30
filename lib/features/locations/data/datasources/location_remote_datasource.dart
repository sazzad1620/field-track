import 'package:dio/dio.dart';
import 'package:field_track/core/constants/api_constants.dart';
import 'package:field_track/features/locations/data/models/location_model.dart';

class LocationRemoteDatasource {
  final Dio dio;

  LocationRemoteDatasource(this.dio);

  Future<List<LocationModel>> fetchLocations() async {
    final response = await dio.get(ApiConstants.locations);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>;
    return list
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<LocationModel> createLocation({
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
  }) async {
    final response = await dio.post(
      ApiConstants.locations,
      data: {
        'location_name': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'radius_m': radiusM,
      },
    );
    return LocationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<LocationModel> updateLocation({
    required String id,
    required String locationName,
    required double latitude,
    required double longitude,
    required int radiusM,
    required bool isActive,
  }) async {
    final response = await dio.put(
      '${ApiConstants.locations}/$id',
      data: {
        'location_name': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'radius_m': radiusM,
        'is_active': isActive,
      },
    );
    return LocationModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteLocation(String id) async {
    await dio.delete('${ApiConstants.locations}/$id');
  }
}
