class InputValidators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa un monto';
    }
    final number = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (number == null || number <= 0) {
      return 'Ingresa un monto válido';
    }
    return null;
  }
}