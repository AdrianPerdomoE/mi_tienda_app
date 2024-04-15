import 'package:flutter/material.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: ListView(
          children: [
            _buildSection('Datos Personales'),
            _buildField('Número de cédula', '1015816269', Icons.person),
            _buildField('Nombres', 'Paulina', Icons.person_pin),
            _buildField('Apellidos', 'Muñoz Saldarriaga', Icons.person_pin),
            const Divider(),    
            _buildSection('Datos de Contacto'),
            _buildField('Número de teléfono', '300 123 4567', Icons.phone),
            _buildField('Correo electrónico', 'paulinasaldarriaga34@gmail.com', Icons.mail),
            const Divider(),
            _buildSection('Datos de Envío'),
            _buildField('Dirección de residencia', 'Calle 123 # 45-67', Icons.house),
            const Divider(),
            _buildSection('Datos de Pago'),
            _buildField('Métodos de pago', 'Efectivo', Icons.money),
            _buildField('Monto máximo a fiar', '\$100.000', Icons.monetization_on_sharp),
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
        onPressed: (){},
        child: Text(
          'Editar',
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
          fixedSize: Size(80, 22),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value,IconData icon) {
    return ListTile(
      tileColor: null,
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        value,
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



