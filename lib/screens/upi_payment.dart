import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class UpiPaymentScreen extends StatefulWidget {
  const UpiPaymentScreen({super.key});

  @override
  _UpiPaymentScreenState createState() => _UpiPaymentScreenState();
}

class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }

  String getIconPathForApp(String packageName) {
    switch (packageName) {
      case 'com.google.android.apps.nbu.paisa.user':
        return 'assets/images/gpay.png'; // Replace with your actual image asset
      case 'net.one97.paytm':
        return 'assets/images/paytm.png'; // Replace with your actual image asset
      default:
        return 'assets/images/paytm.png'; // Replace with your default image asset
    }
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "7265917118@paytm",
      receiverName: 'Vrajkumar Pithwa',
      transactionRefId: 'Testing Upi India Plugin',
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
      merchantId: '',
    );
  }

  void showUpiAppsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select UPI App'),
          content: SingleChildScrollView(
            child: Wrap(
              children: apps!.map<Widget>((UpiApp app) {
                IconData iconData;
                Color iconColor;
                String appName;

                // Set icon and color based on the app
                if (app.packageName ==
                    'com.google.android.apps.nbu.paisa.user') {
                  appName = 'Google Pay';
                } else if (app.packageName == 'net.one97.paytm') {
                  appName = 'Paytm';
                } else {
                  iconData = Icons.payment;
                  iconColor = Colors.black;
                  appName = 'Unknown';
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _transaction = initiateTransaction(app);
                    setState(() {});
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          child: Image.asset(
                            getIconPathForApp(app.packageName),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(appName),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on the device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
            child: Text(
              body,
              style: value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upgrade to Premium"),
      ),
      body: Column(
        children: <Widget>[
          // First Subscription Plan Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: ListTile(
              title: const Text('Dummy Plan'),
              subtitle: const Text(
                  'Explore our app for free with the Basic Access plan! Enjoy unlimited usage, full feature access, and a taste of premium features—all without any payment. It`s the perfect opportunity to discover what our app has to offer. Sign up now and experience the freedom of Basic Access! 🚀'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Try Now',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
            ),
          ),

          // Second Subscription Plan Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: ListTile(
              title: const Text('Premium Plan'),
              subtitle: const Text(
                  'Upgrade to our Premium Plan today and elevate your app experience to new heights. Embrace the advantages of premium membership and enjoy a smoother, more feature-rich journey. Your satisfaction is our priority—subscribe now and unlock the full potential of our app! 🌟'),
              trailing: ElevatedButton(
                onPressed: () {
                  showUpiAppsDialog();
                },
                child: Text("Pay",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary)),
              ),
            ),
          ),

          // Existing UPI Payment Widgets
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder:
                  (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: header,
                      ), // Print's text message on screen
                    );
                  }

                  UpiResponse _upiResponse = snapshot.data!;

                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  _checkTxnStatus(status);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(''),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
