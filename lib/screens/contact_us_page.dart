import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../core/localization/app_localizations.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> with SingleTickerProviderStateMixin {
  // 1. Form Management
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _subjectController;
  late TextEditingController _messageController;

  // 2. Focus Nodes
  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _subjectFocusNode;
  late FocusNode _messageFocusNode;

  // 3. State Variables
  bool _isLoading = false;
  String? _submissionError;
  
  // Animation controllers
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _subjectController = TextEditingController();
    _messageController = TextEditingController();

    // Initialize focus nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();

    // Initialize animation controller and animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();

    _animationController.dispose();
    super.dispose();
  }

  // --- Form Validation Methods ---
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email.';
    }
    // Basic email validation regex
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateSubject(String? value) { // Optional
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a subject.';
    }
    return null;
  }

  String? _validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your message.';
    }
    if (value.trim().length < 10) {
      return 'Message must be at least 10 characters long.';
    }
    return null;
  }

  // --- Form Submission Logic ---
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _submissionError = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          _showSuccessDialog();
          _formKey.currentState?.reset();
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _submissionError = 'An error occurred. Please try again later.';
        });

        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_submissionError ?? 'Failed to send message.'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: _submitForm,
              ),
            ),
          );
        }
      }
    }
  }

  void _showSuccessDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 30),
              const SizedBox(width: 10),
              Text(l10n.thankYou),
            ],
          ),
          content: Text(
            l10n.messageSentSuccessfully,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.primary, fontSize: 16),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // --- UX Helper Methods ---
  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  InputDecoration _getInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: TextStyle(color: AppColors.textPrimary),
      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
      errorStyle: TextStyle(color: AppColors.error),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.couldNotLaunch} $urlString'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorLaunching} $urlString: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Contact from AgriCure App',
      },
    );
    await _launchUrl(emailUri.toString());
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(RegExp(r'[^\d+]'), ''),
    );
    await _launchUrl(phoneUri.toString());
  }

  Future<void> _launchMaps(String address) async {
    final String encodedAddress = Uri.encodeComponent(address);
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    await _launchUrl(googleMapsUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contactUs),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Contact Info Card
                Card(
                  elevation: 4,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  margin: const EdgeInsets.only(bottom: 24.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.contact_support_outlined, 
                              color: AppColors.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Contact Information',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                       Center(
  child: FractionallySizedBox(
    widthFactor: 0.6,          // 60 % of the parent's width
    alignment: Alignment.center, // optional—Center already does this
    child: Image.asset(
      'assets/images/AXCESS_LOGO_1.png',
      fit: BoxFit.contain,
    ),
  ),
),

                        const SizedBox(height: 20),
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          content: 'axcesstechsolutions@gmail.com',
                          iconColor: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          title: 'Phone',
                          content: '+201055656507',
                          iconColor: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          icon: Icons.location_on_outlined,
                          title: 'Address',
                          content: 'kafrelsheikh, Egypt',
                          iconColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Message Form Section
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 20),
                  child: Row(
                    children: [
                      Icon(Icons.message_outlined, 
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Send Us a Message',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Fields
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    decoration: _getInputDecoration(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: _validateName,
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _nameFocusNode, _emailFocusNode),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: _getInputDecoration(
                      label: 'Email Address',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: _validateEmail,
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _emailFocusNode, _subjectFocusNode),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _subjectController,
                    focusNode: _subjectFocusNode,
                    decoration: _getInputDecoration(
                      label: 'Subject',
                      hint: 'Reason for contacting',
                      icon: Icons.label_outline,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: _validateSubject,
                    onFieldSubmitted: (_) => _fieldFocusChange(context, _subjectFocusNode, _messageFocusNode),
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 24.0),
                  child: TextFormField(
                    controller: _messageController,
                    focusNode: _messageFocusNode,
                    decoration: _getInputDecoration(
                      label: 'Your Message',
                      hint: 'Write your message here...',
                      icon: Icons.message_outlined,
                    ).copyWith(
                      alignLabelWithHint: true,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 3,
                    textInputAction: TextInputAction.done,
                    validator: _validateMessage,
                    onFieldSubmitted: (_) => _isLoading ? null : _submitForm(),
                  ),
                ),

                // Submit Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isLoading)
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        Text(
                          _isLoading ? 'Sending...' : 'Send Message',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!_isLoading)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.send_outlined, size: 20),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    bool isClickable = true;
    VoidCallback? onTap;

    switch (title.toLowerCase()) {
      case 'email':
        onTap = () => _launchEmail(content);
        break;
      case 'phone':
        onTap = () => _launchPhone(content);
        break;
      case 'address':
        onTap = () => _launchMaps(content);
        break;
      default:
        isClickable = false;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isClickable) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.launch,
                        size: 14,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isClickable ? AppColors.primary : AppColors.textSecondary,
                    height: 1.4,
                    decoration: isClickable ? TextDecoration.underline : null,
                    decorationColor: AppColors.primary.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
