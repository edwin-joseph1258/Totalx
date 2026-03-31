import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    // Placeholder for illustration
                    Icon(Icons.mobile_friendly, size: 120, color: Colors.blue.shade300),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Text(
                'Enter Phone Number',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.phone,
                onChanged: authViewModel.setPhoneNumber,
                decoration: InputDecoration(
                  hintText: 'Enter Phone Number *',
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black12, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black12, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: 'By Continuing, I agree to TotalX\'s ',
                  style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
                  children: [
                    TextSpan(
                      text: 'Terms and condition',
                      style: GoogleFonts.inter(color: Colors.blue.shade400, fontSize: 12),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: 'privacy policy',
                      style: GoogleFonts.inter(color: Colors.blue.shade400, fontSize: 12),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Get OTP',
                isLoading: authViewModel.isLoading,
                onPressed: () => authViewModel.getOtp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
