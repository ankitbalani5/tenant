part of 'logout_otp_tenant_bloc.dart';

@immutable
abstract class LogoutOtpTenantEvent {
  const LogoutOtpTenantEvent();
}

class LogoutOtpTenantRefreshEvent extends LogoutOtpTenantEvent {
  String tenantId;
  LogoutOtpTenantRefreshEvent(this.tenantId);
}