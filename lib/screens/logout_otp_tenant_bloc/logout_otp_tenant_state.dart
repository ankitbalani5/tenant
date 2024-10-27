part of 'logout_otp_tenant_bloc.dart';

abstract class LogoutOtpTenantState {}

class LogoutOtpTenantInitial extends LogoutOtpTenantState{}

class LogoutOtpTenantLoading extends LogoutOtpTenantState{}

class LogoutOtpTenantSuccess extends LogoutOtpTenantState{
  LogoutOtpTenantModel logoutOtpTenantModel;
  LogoutOtpTenantSuccess(this.logoutOtpTenantModel);
}

class LogoutOtpTenantError extends LogoutOtpTenantState{
  String error;
  LogoutOtpTenantError(this.error);
}