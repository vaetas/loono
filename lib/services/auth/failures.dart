import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loono/l10n/ext.dart';
import 'package:loono/models/social_login_account.dart';

part 'failures.freezed.dart';

const _anonymizedAppleEmailDomain = 'privaterelay.appleid.com';

extension AuthFailureMessageExt on AuthFailure {
  String getMessage(BuildContext context) {
    return when(
      unknown: (message) => message ?? context.l10n.auth_unknown_failure_message,
      noMessage: () => '',
      accountNotExists: (socialAccount) {
        var email = socialAccount.email;
        if (email?.endsWith(_anonymizedAppleEmailDomain) == true) {
          // this email with such domain will not say to the user anything
          email = null;
        }
        return '${context.l10n.auth_account_not_exists_message} ${email == null ? '' : '($email).'}';
      },
      network: (message) => message ?? context.l10n.auth_network_failure_message,
    );
  }
}

@freezed
class AuthFailure with _$AuthFailure {
  const AuthFailure._();

  const factory AuthFailure.unknown([String? message]) = UnknownFailure;

  const factory AuthFailure.noMessage() = NoMessageFailure;

  const factory AuthFailure.accountNotExists(SocialLoginAccount socialLoginAccount) =
      AccountNotExists;

  const factory AuthFailure.network([String? message]) = NetworkFailure;
}
