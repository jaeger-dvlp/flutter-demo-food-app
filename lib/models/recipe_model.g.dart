// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
  idMeal: json['idMeal'] as String,
  strMeal: json['strMeal'] as String,
  strCategory: json['strCategory'] as String,
  strArea: json['strArea'] as String,
  strInstructions: json['strInstructions'] as String,
  strMealThumb: json['strMealThumb'] as String,
);

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
  'idMeal': instance.idMeal,
  'strMeal': instance.strMeal,
  'strCategory': instance.strCategory,
  'strArea': instance.strArea,
  'strInstructions': instance.strInstructions,
  'strMealThumb': instance.strMealThumb,
};
