import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class Client {
  final String name;
  final String surname;
  final String phone;
  final String address;
  final int id;
  late List<Sale> sales;

  Client(
      {required this.name,
      required this.surname,
      required this.phone,
      required this.address,
      required this.id});
}

class Sale {
  final int id;
  final int clientId;
  final DateTime date;
  final int userId;
  late List<SaleItem> items;

  Sale(
      {required this.id,
      required this.clientId,
      required this.date,
      required this.userId});
}

class SaleItem {
  final int saleId;
  final int productId;
  final int quantity;
  final double price;
  late Product product;

  SaleItem(
      {required this.saleId,
      required this.productId,
      required this.quantity,
      required this.price});
}

class Product {
  final String name;
  final double price;
  final int id;

  Product({required this.id, required this.name, required this.price});
}

class ClientRepository {
  late PostgreSQLConnection connection;

  Future<void> initialize() async {
    clientRepository.connection = PostgreSQLConnection(
      dotenv.env['DB_HOST']!,
      int.parse(dotenv.env['DB_PORT']!),
      dotenv.env['DB_NAME']!,
      username: dotenv.env['DB_USER']!,
      password: dotenv.env['DB_PASSWORD']!,
    );
    await clientRepository.connection.open();
  }

  Future<List<Client>> getClients(int page) async {
    var results = await connection
        .query('SELECT * FROM clients offset ${page * 10} limit 10');

    return results
        .map((e) => Client(
              name: e[0] as String,
              surname: e[1] as String,
              address: e[3] as String,
              phone: e[2] as String,
              id: e[4] as int,
            ))
        .toList();
  }

  Future<List<Sale>> getClientBill(int clientId) async {
    var sales = (await connection
            .query("select * from sale s where s.id = $clientId order by s.id"))
        .map((e) => Sale(
            clientId: e[0] as int,
            date: e[1] as DateTime,
            id: e[2] as int,
            userId: e[3] as int))
        .toList();

    if (sales.isEmpty) {
      return [];
    }

    var saleIds = sales.map((e) => e.id).join(",");

    var saleItems = (await connection.query(
            "select*from sale_item si where si.sale_id in($saleIds) order by si.sale_id"))
        .map((e) => SaleItem(
            saleId: e[0], productId: e[1], quantity: e[2], price: e[3]))
        .toList();

    for (var sale in sales) {
      sale.items =
          saleItems.where((element) => element.saleId == sale.id).toList();
    }
    return sales;
  }

  Future<void> postClients(
      {required String name,
      required String surname,
      String phone = '',
      String address = ''}) async {
    try {
      await connection.query(
        "INSERT INTO clients VALUES ('$name', '$surname', '$phone', '$address')",
      );
    } catch (e) {
      if ((e as PostgreSQLException).code == '23505') {
        print(e);
      } else {
        print(e);
      }
    }
  }
}

final ClientRepository clientRepository = ClientRepository();
