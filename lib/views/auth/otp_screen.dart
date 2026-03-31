import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: GoogleFonts.inter(
        fontSize: 20,
        color: AppColors.red,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    String formatMaskedNumber(String number) {
      if (number.length >= 2) {
        return '*******${number.substring(number.length - 2)}';
      }
      return '*******21'; 
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'asset/images/OTP.png',
                      height: 150, 
                      width: 150, 
                      fit: BoxFit.cover, 
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
              Text(
                'OTP Verification',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter the verification code we just sent to your number +91 ${formatMaskedNumber(authViewModel.phoneNumber)}.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.black54,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration?.copyWith(
                      border: Border.all(color: Colors.deepOrange),
                    ),
                  ),
                  onChanged: authViewModel.setOtp,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '${authViewModel.resendTimer} Sec',
                  style: GoogleFonts.inter(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t Get OTP? ',
                      style: GoogleFonts.inter(color: AppColors.black54),
                    ),
                    TextButton(
                      onPressed: authViewModel.resendTimer == 0
                          ? () => authViewModel.startResendTimer()
                          : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Resend',
                        style: GoogleFonts.inter(
                          color: authViewModel.resendTimer == 0
                              ? AppColors.blue.shade600
                              : AppColors.blue.shade200,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Verify',
                isLoading: authViewModel.isLoading,
                onPressed: () => authViewModel.verifyOtp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
