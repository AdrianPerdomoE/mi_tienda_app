import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {

  bool isEditing = false;

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController maxAmountController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: ListView(
          children: [
            _buildSection('Datos Personales'),
            _buildField('Número de cédula', '1015816269', Icons.person, idController),
            _buildField('Nombres', 'Paulina', Icons.person_pin, nameController),
            _buildField('Apellidos', 'Muñoz Saldarriaga', Icons.person_pin, lastNameController),
            const Divider(),    
            _buildSection('Datos de Contacto'),
            _buildField('Número de teléfono', '300 123 4567', Icons.phone, phoneController),
            _buildField('Correo electrónico', 'paulinasaldarriaga34@gmail.com', Icons.mail, emailController),
            const Divider(),
            _buildSection('Datos de Envío'),
            _buildField('Dirección de residencia', 'Calle 123 # 45-67', Icons.house, addressController),
            const Divider(),
            _buildSection('Datos de Pago'),
            _buildField('Métodos de pago', 'Efectivo', Icons.money, paymentMethodController),
            _buildField('Monto máximo a fiar', '\$100.000', Icons.monetization_on_sharp, maxAmountController),
            _buildButton('Cambiar contraseña'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return ListTile(
      tileColor: null,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: ElevatedButton(
        onPressed: (){
          setState(() {
            isEditing = !isEditing;
          });
        },
        child: Text(
          isEditing ? 'Guardar':'Editar',
          style: TextStyle(
            fontSize: 12
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF8697C3),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          fixedSize: Size(95, 22),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value,IconData icon, TextEditingController controller) {
    controller.text = value;
    return ListTile(
      tileColor: null,
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: value,
        ),
        enabled: isEditing,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildButton(String label){
    return Center(
      child: ElevatedButton(
        onPressed: (){},
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFABCFB9),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fixedSize: Size(200, 40),
        ),
      ),
    );
  }
}



