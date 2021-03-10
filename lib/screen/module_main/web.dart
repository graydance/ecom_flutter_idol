import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:idol/models/appstate.dart';
import 'package:idol/models/arguments/arguments.dart';
import 'package:idol/widgets/loading.dart';
import 'package:idol/widgets/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InnerWebViewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InnerWebViewScreenState();
}

class _InnerWebViewScreenState extends State<InnerWebViewScreen> {
  InnerWebViewArguments arguments;
  WebViewController _controller;
  bool _loadFinish = false;
  String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdolUI.appBar(context, _title),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebView(
            initialUrl: arguments.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onPageFinished: (url) {
              setState(() {
                _loadFinish = true;
              });
              _controller.evaluateJavascript("document.title").then((result) {
                if (result != null && result.isNotEmpty) {
                  setState(() {
                    _title = result;
                  });
                }
              });
            },
            onWebResourceError: (error) {
              setState(() {
                _loadFinish = true;
              });
              EasyLoading.showError(error.description);
            },
          ),
          Visibility(
            child: Center(
              child: IdolLoadingWidget(),
            ),
            visible: !_loadFinish,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    arguments = StoreProvider.of<AppState>(context, listen: false)
        .state
        .innerWebViewArguments;
    _title = arguments.title;
  }
}
