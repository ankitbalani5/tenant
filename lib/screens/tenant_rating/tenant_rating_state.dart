part of 'tenant_rating_bloc.dart';

@immutable
abstract class TenantRatingState {}

class TenantRatingInitial extends TenantRatingState {}
class TenantRatingLoading extends TenantRatingState {}
class TenantRatingSuccess extends TenantRatingState {
  TenantRatingModel tenantRatingModel;
  TenantRatingSuccess(this.tenantRatingModel);
}
class TenantRatingError extends TenantRatingState {
  String error;
  TenantRatingError(this.error);
}
