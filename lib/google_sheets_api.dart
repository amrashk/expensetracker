import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
    {
  "type": "service_account",
  "project_id": "oceanic-bindery-350310",
  "private_key_id": "b8a7ce49a67310d5fc6a410a6b2c6afc90ce088d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCU8sN7wGhnVgLa\npGbivCJ9/Nze21M7GDXI8L7gJntZGsmLI741CVRDMmtpL/xs2n9TPaMLyw7Xuj7j\nzCyovktitvBwwlhmv6Q7rGZAgFAFG35DS3lzbke9R66l5FhwKuvOcnMXbbYGKIaK\nl3YCw9gURgnenq+TUzoEnJjE+6L3ocy9udMfamDTx++Y59nkWKxoh/I26Dw+G0ha\nYfCbcHPNezSVKephMPpmpRHNwYLjs9Y7iZYIA6VWW7zmbWhpPSM/Jod9sLQOLBbd\nDFaGlcLIzx0quYAaorSJL40GHZ9KMkwpc4GdcvlWMKzediVWLNTQqawmCoTA1S9E\nq7td4ynjAgMBAAECggEASgE8Y1Y8CWvQyzV38Rusv5BNZWTvu6LRxl7nV5OHIcSP\nctR1gwB5n1GD0KWI88S0EnXDdu6TF1hwOtqNLeIuroNaf4vwREzfms6Tl2SpXYBF\ngcYUN+gJOOBOxBnqXwDUXKS8zl0yXWjxQBb1CXao+5m4+aU6cyac4wGzXdvxIru9\nWzGhP8ZKuvb0LaIisXrz6IaFAeuKMZ1m9+eOPuOKPUt6XO2wzAw6H6fF5P+rIBdM\n0az7/JAYUyvTm2NYvLeoHyYIASRNIAoqSnoM1Tr4dBAZErvGTI/eG0oVYghcs2kc\nXuPE6lJcLKsRU8A8eZ+LbNRYjHH/o+PhzfsqxFFpwQKBgQDHPdvjT68ML2XRbRcl\nfD5lFydIyVbjlxbZycXWdIQSf7BykttQvtpSH2riSmBEsQstrwJB0B83HpE3ufPC\n3YFy5L6keeKkk50n3HVbKd2hV/2Ag7HotX5v1ZPXmGYj5WX9DinSLil73b2jNwtp\nzMuLBR+6KoUlQ7jQ927E96glkwKBgQC/YSaHwXVG47y1rnpcy9+OCDoURKJf1EIM\nkEaEHJAilzFz9+W9bHXmNySBhdILfYhOqesFVdh5Mu5lWtZaftIexoGOBKrWQcj7\nw9iKQB5+0QdY3EOR246CWIC0oDE528gs5DjIn6TDXuNqha1OOb0Ta0d8RH22/ikD\nQv6IbkeccQKBgG7C68e9V5HNk6vOGo0DOeiW64biLwSMzO475linI3jpNV0sWPHV\nd6cpwhCUylnFlnJKFVYi7geFXbN+E44j97+4fGcRPzbAvSAYxcDtUEFOmiXkkHXO\n18AyGmNDXJzd/UmlowguE2/BwJfIlPa3G/xn19B1rNkfgdHhi9nB198zAoGBAJym\nXO+KPwDDsNfV9Xq3tkmAGmo0s+RUzauS/OVuq9xkfao7I+YlPWwvfsY2T3PwUP5y\nv1kip4qtUc3MyOBSJpPiUHF7CItQVb8e08R2L4AGgUkPIo/lc4TmBJPU+/YsHHIC\nbShq5Ga26NdsjCsXv9iBW4YwWebLq65rzATIn/1BAoGAJuOAeyDHdmd9O7wFeEmI\nR2h3MtcUZhZoOOeccUzT4790qISoLFN7E99yFZLpNqjdHaf/h5Q2VetmRMxG3RTz\noqYld86YTHi2Ql4fiLU1Az9TqYeHPGOUSBCDs7XpI2JR1GznH0+hxWkUbVBjmI/x\nrpEF8oMy7JoVQuuHcJ+oqkA=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@oceanic-bindery-350310.iam.gserviceaccount.com",
  "client_id": "109470772318936274996",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40oceanic-bindery-350310.iam.gserviceaccount.com"
}
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1ybGz1wd3Jnk1h37xhoHzP3fjgAX89rgB2OIDXLA4qZU';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
