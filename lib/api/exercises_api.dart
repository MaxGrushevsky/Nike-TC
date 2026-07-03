import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'models/exercise_dto.dart';

part 'exercises_api.g.dart';

@RestApi()
abstract class ExercisesApi {
  factory ExercisesApi(Dio dio) = _ExercisesApi;

  @GET('/v1/exercises')
  Future<List<ExerciseDto>> getExercises({
    @Query('name') String? name,
    @Query('type') String? type,
    @Query('muscle') String? muscle,
    @Query('difficulty') String? difficulty,
    @Query('equipments') String? equipments,
  });
}
