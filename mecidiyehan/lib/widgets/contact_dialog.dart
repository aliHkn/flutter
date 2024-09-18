import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDialog extends StatelessWidget {
  const ContactDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('İletişim'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.instagram),
            title: const Text('_alfalogy'),
            onTap: () {
              FlutterWebBrowser.openWebPage(
                url: 'https://www.instagram.com/_alfalogy',
                customTabsOptions: const CustomTabsOptions(
                  toolbarColor: Colors.blue,
                  showTitle: true,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('alfalogy.com'),
            onTap: () {
              FlutterWebBrowser.openWebPage(
                url: 'http://alfalogy.com',
                customTabsOptions: const CustomTabsOptions(
                  toolbarColor: Colors.blue,
                  showTitle: true,
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Eyyup KAYA'),
            onTap: () async {
              const url = 'tel:+905432798699';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Kapat'),
        ),
      ],
    );
  }
}
