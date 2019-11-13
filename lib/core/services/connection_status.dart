/// From [this StackOverflow answer](https://stackoverflow.com/a/53855326/10854681)

import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';

/// ConnectionStatusSingleton
/// First we setup a Singleton. If you're unfamiliar with this pattern there's
/// a lot of good info online about them. But the gist is that you want to make
/// a single instance of a class during the application life cycle and be able
/// to use it anywhere.
///
/// This singleton hooks into flutter_connectivity and listens for
/// connectivity changes, then tests the network connection, then uses a
/// StreamController to update anything that cares.
///
/// Initialize like
///```
/// void main() {
///   ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
///   connectionStatus.initialize();
///
///   runApp(MyApp());
///
///   //Call this if initialization is occuring in a scope that will end during app lifecycle
///   //connectionStatus.dispose();
/// }
///```
///```
/// import 'dart:async'; //For StreamSubscription
///
///...
///
/// class MyWidgetState extends State<MyWidget> {
///    StreamSubscription _connectionChangeStream;
///
///    bool isOffline = false;
///
///    @override
///    initState() {
///        super.initState();
///
///        ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
///        _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
///    }
///
///    void connectionChanged(dynamic hasConnection) {
///        setState(() {
///            isOffline = !hasConnection;
///        });
///    }
///
///    @override
///    Widget build(BuildContext ctxt) {
///        ...
///    }
/// }
/// ```
class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = new StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch(_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
void main(){
  ConnectionStatusSingleton.getInstance();
}