typedef StringOrNullFunction = String? Function(
    String); // Defincion de un tipo de función que recibe un string y retorna un string o null

class InputRegexValidator {
  // Clase que contiene los métodos de validación de campos de texto de forma estática
  static final RegExp _emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]+$'); // Expresión regular para un correo electrónico, validando que tenga un @ y un dominio
  static final RegExp _passwordRegExp = RegExp(
      r'^[a-zA-Z0-9]{6,}$'); // Expresión regular para una contraseña , validando que tenga al menos 6 caracteres
  static final RegExp _nameRegExp = RegExp(
      r'^[a-zA-Z\s]+$'); // Expresión regular para un nombre, validando solo letras y espacios
  static final RegExp _phoneRegExp = RegExp(
      r'^[0-9]{10}$'); // Expresión regular para un número de teléfono, validando solo números y de 10 dígitos
  static final RegExp _addressRegExp = RegExp(
      r'^(calle|carrera)\s\d+[A-Za-z]?\s#\s\d+[A-Za-z]?\s?[A-Za-z0-9\s]{0,100}$'); // Expresión regular para una dirección, validando que inicie con calle o carrera, seguido de un número y una letra opcional, seguido de un # y un número y una letra opcional, seguido de un espacio y un texto de 0 a 100 caracteres
  static final RegExp _textAreaRegExp = RegExp(
      r'^\w+(\s+\w+)*$'); // Expresión regular para un campo de texto, validando que inicie con una palabra y pueda tener más palabras separadas por espacios
  static final RegExp _ratingRegExp = RegExp(
      r'^[0-5]$'); // Expresión regular para una calificación, validando que sea un número entre 0 y 5

  static String? validateEmail(String email) {
    // Método que valida un correo electrónico
    if (email.isEmpty) {
      return 'El campo es requerido';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  static String? validatePassword(String password) {
    // Método que valida una contraseña
    if (password.isEmpty) {
      return 'El campo es requerido';
    } else if (!_passwordRegExp.hasMatch(password)) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  static String? validateName(String name) {
    // Método que valida un nombre
    if (name.isEmpty) {
      return 'El campo es requerido';
    } else if (!_nameRegExp.hasMatch(name)) {
      return 'Ingresa un nombre válido';
    }
    return null;
  }

  static String? validatePhone(String phone) {
    // Método que valida un número de teléfono
    if (phone.isEmpty) {
      return 'El campo es requerido';
    } else if (!_phoneRegExp.hasMatch(phone)) {
      return 'Ingresa un número de teléfono válido de 10 dígitos';
    }
    return null;
  }

  static String? validateAddress(String address) {
    // Método que valida una dirección
    if (address.isEmpty) {
      return 'El campo es requerido';
    } else if (!_addressRegExp.hasMatch(address)) {
      return 'Ingresa una dirección válida';
    }
    return null;
  }

  static String? validateTextArea(String textArea) {
    // Método que valida un campo de texto
    if (textArea.isEmpty) {
      return 'El campo es requerido';
    } else if (!_textAreaRegExp.hasMatch(textArea)) {
      return 'Ingresa almenos una palabra';
    }
    return null;
  }

  static String? validateRating(String rating) {
    // Método que valida una calificación
    if (rating.isEmpty) {
      return 'El campo es requerido';
    } else if (!_ratingRegExp.hasMatch(rating)) {
      return 'Ingresa un valor entre 0 y 5';
    }
    return null;
  }

  static String? validateAmount(String value) {
    // Método que valida un monto
    if (value.isEmpty) {
      return 'El campo es requerido';
    } else if (double.parse(value) <= 0) {
      return 'Ingresa un valor mayor a 0';
    }
    return null;
  }

  static String? validateNumber(String value) {
    // Método que valida un número
    if (value.isEmpty) {
      return 'El campo es requerido';
    } else if (double.parse(value) < 0) {
      return 'Ingresa un valor mayor o igual a 0';
    }
    return null;
  }

  static String? validateDiscount(String value) {
    // Método que valida un número
    if (value.isEmpty) {
      return 'El campo es requerido';
    } else if (double.parse(value) < 0 || double.parse(value) >= 1) {
      return 'Ingresa un valor entre 0 y 1';
    }
    return null;
  }
}
