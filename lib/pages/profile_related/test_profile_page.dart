import 'package:pks_14/pages/orders_page.dart';
import 'package:flutter/material.dart';

class TestProfilePage extends StatelessWidget {
  const TestProfilePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Тестовый профиль'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Вы вошли в аккаунт!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "ID: 0",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Email: user_0_mail@mail.mail",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ),
                    );
                  },
                  child: const Text("Ваши заказы")
              ),
              const SizedBox(height: 60),
            ],
          )
      ),
    );
  }
}