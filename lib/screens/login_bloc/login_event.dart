part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  final String mobile_no, password, imei_no, device_id,
      ip_address, carrier_name, app_version,
      phone_model, phone_manufacturer, sdk_phone_version;
 const LoginEvent(
     this.mobile_no,
     this.password,
     this.imei_no,
     this.device_id,
     this.ip_address,
     this.carrier_name,
     this.app_version,
     this.phone_model,
     this.phone_manufacturer,
     this.sdk_phone_version
     );
}

class LoginRefreshEvent extends LoginEvent {
  const LoginRefreshEvent(super.mobile_no,super.password,
      super.imei_no,super.device_id,
      super.ip_address, super.carrier_name, super.app_version,
      super.phone_model, super.phone_manufacturer,
      super.sdk_phone_version
      );
}