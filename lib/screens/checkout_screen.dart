import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_miac/screens/orders_history_screen.dart';
import '../models/product.dart';
import '../models/order_manager.dart'; 

class CheckoutScreen extends StatefulWidget {
  final Product product;

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0; 

  final _formKeyLivraison = GlobalKey<FormState>();
  final _formKeyPaiement = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedCity;
  final List<String> _cities = ['Casablanca', 'Rabat', 'Marrakech', 'Agadir', 'Fes', 'Tangier'];

  String _selectedPaymentMethod = 'COD'; 
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvcController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvcController.dispose();
    super.dispose();
  }

  
  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_formKeyLivraison.currentState!.validate() && _selectedCity != null) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs de livraison.')),
        );
        return false;
      }
    } else if (_currentStep == 1) {
      if (_selectedPaymentMethod == 'STRIPE' || _selectedPaymentMethod == 'CMI') {
        if (_formKeyPaiement.currentState!.validate()) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez renseigner les informations de carte valides.')),
          );
          return false;
        }
      }
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffbf7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfffbf7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3e5219)),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentStep == 1 ? 'Secure Checkout' : 'MIAC',
          style: GoogleFonts.ebGaramond(
            color: const Color(0xFF3e5219),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildStepIndicator(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildStepContent(),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, 'Livraison'),
        _buildStepLine(0),
        _buildStepCircle(1, 'Paiement'),
        _buildStepLine(1),
        _buildStepCircle(2, 'Résumé'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String title) {
    bool isDone = _currentStep >= step;
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isDone ? const Color(0xFF94492c) : Colors.grey[300],
          child: Text(
            '${step + 1}',
            style: TextStyle(color: isDone ? Colors.white : Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: _currentStep == step ? FontWeight.bold : FontWeight.normal,
            color: _currentStep == step ? const Color(0xFF3e5219) : Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isDone = _currentStep > step;
    return Container(
      width: 50,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 15),
      color: isDone ? const Color(0xFF94492c) : Colors.grey[300],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildLivraisonForm();
      case 1:
        return _buildPaiementForm();
      case 2:
        return _buildResumeContent();
      default:
        return const SizedBox();
    }
  }

  Widget _buildLivraisonForm() {
    return Form(
      key: _formKeyLivraison,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Adresse de livraison',
            style: GoogleFonts.ebGaramond(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219)),
          ),
          const SizedBox(height: 5),
          Text('Veuillez renseigner vos coordonnées pour l\'expédition.', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 20),
          _buildTextField('Nom complet', 'Ex: Ahmed Benjelloun', _nameController, Icons.person_outline),
          const SizedBox(height: 15),
          _buildTextField('Numéro de téléphone', '+212 6 XX XX XX XX', _phoneController, Icons.phone_outlined, isPhone: true),
          const SizedBox(height: 15),
          _buildTextField('Adresse', 'Numéro de rue, quartier...', _addressController, Icons.home_outlined, maxLines: 2),
          const SizedBox(height: 15),
          Text('Ville', style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF45483c))),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _selectedCity,
            decoration: InputDecoration(
              fillColor: const Color(0xFFf7f4f0),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            hint: const Text('Sélectionnez votre ville'),
            items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
            onChanged: (val) => setState(() => _selectedCity = val),
            validator: (value) => value == null ? 'Champ obligatoire' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPaiementForm() {
    return Form(
      key: _formKeyPaiement,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Payment Method',
            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 15),

          _buildPaymentMethodCard(
            id: 'COD',
            title: 'Paiement à la livraison',
            subtitle: 'Payez en espèces dès réception de votre commande',
            icon: Icons.delivery_dining_outlined,
          ),
          const SizedBox(height: 12),

          _buildPaymentMethodCard(
            id: 'STRIPE',
            title: 'Credit Card / Apple Pay',
            subtitle: 'Secure payment via Stripe',
            icon: Icons.credit_card_outlined,
          ),
          const SizedBox(height: 12),

          _buildPaymentMethodCard(
            id: 'CMI',
            title: 'Local Card (CMI)',
            subtitle: 'Payment via Moroccan Interbank Center',
            icon: Icons.account_balance_wallet_outlined,
          ),
          
          if (_selectedPaymentMethod == 'STRIPE' || _selectedPaymentMethod == 'CMI') ...[
            const SizedBox(height: 25),
            Text('CARDHOLDER NAME', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _cardNameController,
              decoration: _getInputDecoration('Khalid El Mansouri', null),
              validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
            ),
            const SizedBox(height: 15),

            Text('CARD NUMBER', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: _getInputDecoration('•••• •••• •••• ••••', Icons.credit_card),
              validator: (v) => (v == null || v.length < 16) ? 'Numéro invalide' : null,
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EXPIRY (MM/YY)', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cardExpiryController,
                        decoration: _getInputDecoration('12 / 26', null),
                        validator: (v) => (v == null || !v.contains('/')) ? 'Invalide' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVC', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _cardCvcController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        decoration: _getInputDecoration('•••', null),
                        validator: (v) => (v == null || v.length < 3) ? 'Invalide' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResumeContent() {
    String methodText = 'Paiement à la livraison';
    if (_selectedPaymentMethod == 'STRIPE') methodText = 'Credit Card (Stripe)';
    if (_selectedPaymentMethod == 'CMI') methodText = 'Local Card (CMI)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Résumé de la commande', style: GoogleFonts.ebGaramond(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF3e5219))),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFf7f4f0), borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(widget.product.image, width: 60, height: 60, fit: BoxFit.cover)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.product.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: const Color(0xFF45483c))),
                    Text('${widget.product.price.toInt()} DH', style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSummaryRow('Client:', _nameController.text),
        _buildSummaryRow('Téléphone:', _phoneController.text),
        _buildSummaryRow('Adresse d\'expédition:', '${_addressController.text}, $_selectedCity'),
        _buildSummaryRow('Méthode de Paiement:', methodText),
      ],
    );
  }

  Widget _buildPaymentMethodCard({required String id, required String title, required String subtitle, required IconData icon}) {
    bool isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFf7f4f0),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFF94492c) : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3e5219), size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF45483c))),
                  Text(subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF94492c), width: 2),
                color: isSelected ? const Color(0xFF94492c) : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String hint, IconData? suffixIcon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(color: Colors.black26, fontSize: 14),
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.black45) : null,
      fillColor: const Color(0xFFf7f4f0),
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, IconData icon, {bool isPhone = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF45483c))),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF3e5219), size: 20),
            fillColor: const Color(0xFFf7f4f0),
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (value) => (value == null || value.trim().isEmpty) ? 'Ce champ est obligatoire' : null,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: GoogleFonts.dmSans(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600)),
          Expanded(child: Text(value, style: GoogleFonts.dmSans(color: const Color(0xFF45483c), fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    String btnText = 'Continuer';
    if (_currentStep == 1) {
      btnText = _selectedPaymentMethod == 'COD' ? 'Confirmer à la livraison' : 'Payer ${widget.product.price.toInt()} MAD';
    }
    if (_currentStep == 2) btnText = 'Confirmer la commande';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF94492c),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () {
          if (_validateCurrentStep()) {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _showSuccessDialog(); 
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_selectedPaymentMethod != 'COD' && _currentStep == 1 ? Icons.lock_outline : Icons.shopping_bag_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(btnText, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
  // Kat-sifit l-produit dynamicly l l-manager bla ma t-khreb l-app
  OrderManager.addOrder(
    widget.product.name, 
    widget.product.price, 
    widget.product.image
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Icon(Icons.check_circle, color: Color(0xFF3e5219), size: 60),
      content: Text(
        _selectedPaymentMethod == 'COD' 
          ? 'Votre commande a été enregistrée avec succès! Vous payerez à la livraison.' 
          : 'Votre paiement a été traité en toute sécurité o commande dazet perfectly!', 
        textAlign: TextAlign.center, 
        style: GoogleFonts.dmSans()
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx); // Sdd l-dialog
            Navigator.pop(context); // Rj3 l-home directly
            
            // Di l-user direct l l-historique bach i-tchif l-tracking line perfectly!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrdersHistoryScreen()),
            );
          },
          child: Text('Parfait', style: GoogleFonts.dmSans(color: const Color(0xFF94492c), fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
}