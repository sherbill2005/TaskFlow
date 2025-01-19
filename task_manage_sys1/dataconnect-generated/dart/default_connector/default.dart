library;

import 'package:firebase_data_connect/firebase_data_connect.dart';

import 'dart:convert';

class DefaultConnector {
  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'task_manage_sys1',
  );

  DefaultConnector({required this.dataConnect});
  static DefaultConnector get instance {
    return DefaultConnector(
        dataConnect:
            FirebaseDataConnect.instanceFor(connectorConfig: connectorConfig));
    // sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
