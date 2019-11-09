import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../core/services/connectivity_service.dart';

/// A Network Notifier Widget.
/// Use `var connectionStatus = Provider.of<ConnectivityStatus>(context)` anywhere down this widget to get connection status.
class NetworkSensitiveWidget extends StatefulWidget {
  /// A widget which will get connection status on demand. It's much recommended to pass an App-wide Material app as an argument for this field to access connection status anywhere.
  /// Use `var connectionStatus = Provider.of<ConnectivityStatus>(context)` anywhere down this widget to get connection status.
  final Widget child;

  const NetworkSensitiveWidget({Key key, this.child}) : super(key: key);

  @override
  _NetworkSensitiveWidgetState createState() => _NetworkSensitiveWidgetState();
}

class _NetworkSensitiveWidgetState extends State<NetworkSensitiveWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      builder: (context) =>
          ConnectivityService().connectionStatusController.stream,
      child: widget.child,
    );
  }
}
