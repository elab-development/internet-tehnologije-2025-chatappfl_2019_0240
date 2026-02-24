import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

/// Registration form widget for email authentication.
///
/// Displays email field and optional terms checkbox for starting registration.
/// After submission, user will proceed to set password screen.
class TermsAndPrivacyTextSrpski extends StatelessWidget {
  final VoidCallback? onTermsAndConditionsPressed;
  final VoidCallback? onPrivacyPolicyPressed;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;

  const TermsAndPrivacyTextSrpski({
    super.key,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    required this.isChecked,
    this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onCheckboxChanged,
        ),
        Expanded(
          child: Wrap(
            children: [
              const Text('Prihvatam '),
              GestureDetector(
                onTap: onTermsAndConditionsPressed,
                child: const Text(
                  'uslove korišćenja',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Text(' i '),
              GestureDetector(
                onTap: onPrivacyPolicyPressed,
                child: const Text(
                  'politiku privatnosti',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Text('.'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Registration form widget for email authentication.
///
/// Displays email field and optional terms checkbox for starting registration.
/// After submission, user will proceed to set password screen.
class StartRegistrationForm extends StatelessWidget {
  /// The controller that manages authentication state and logic.
  final EmailAuthController controller;

  /// Optional callback to call when the terms and conditions button is pressed.
  ///
  /// If not provided, defaults to null.
  final VoidCallback? onTermsAndConditionsPressed;

  /// Optional callback to call when the privacy policy button is pressed.
  ///
  /// If not provided, defaults to null.
  final VoidCallback? onPrivacyPolicyPressed;

  /// Prikaz auth koda korisniku (opciono)
  final String? authCode;

  /// Creates a [StartRegistrationForm] widget.
  const StartRegistrationForm({
    required this.controller,
    this.onTermsAndConditionsPressed,
    this.onPrivacyPolicyPressed,
    this.authCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final onTermsAndConditionsPressed = this.onTermsAndConditionsPressed;
    final onPrivacyPolicyPressed = this.onPrivacyPolicyPressed;

    final hasTermsAndConditions =
        onTermsAndConditionsPressed != null || onPrivacyPolicyPressed != null;

    return FormStandardLayout(
      title: 'Registracija preko emaila',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EmailTextField(controller: controller),
          if (hasTermsAndConditions) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: TermsAndPrivacyTextSrpski(
                onTermsAndConditionsPressed: onTermsAndConditionsPressed,
                onPrivacyPolicyPressed: onPrivacyPolicyPressed,
                isChecked: controller.legalNoticeAcceptedNotifier.value,
                onCheckboxChanged: (value) =>
                    controller.legalNoticeAcceptedNotifier.value =
                        value ?? false,
              ),
            ),
            smallGap,
          ],
          if (authCode != null) ...[
            const SizedBox(height: 16),
            Text(
              'Vaš kod za potvrdu naloga je:',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SelectableText(
              authCode!,
              style: TextStyle(fontSize: 20, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actionButton: ActionButton(
        onPressed:
            controller.emailController.text.isNotEmpty &&
                controller.state == EmailAuthState.idle &&
                (!hasTermsAndConditions ||
                    controller.legalNoticeAcceptedNotifier.value)
            ? () => unawaited(controller.startRegistration())
            : null,
        label: 'Nastavi',
        isLoading: controller.isLoading,
      ),
      bottomText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Već imate nalog?"),
          HyperlinkTextButton(
            onPressed: () => controller.navigateTo(EmailFlowScreen.login),
            label: 'Prijavite se',
          ),
        ],
      ),
    );
  }
}
