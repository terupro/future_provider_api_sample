import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_api_sample/view_model/provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureProviderAPI'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (text) {
                  onPostalCodeChanged(ref, text);
                },
              ),
            ),
            postalCode.when(
              data: (data) => Expanded(
                child: ListView.separated(
                  itemCount: data.data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.data[index].en.prefecture),
                        Text(data.data[index].en.address1),
                        Text(data.data[index].en.address2),
                        Text(data.data[index].en.address3),
                        Text(data.data[index].en.address4),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    height: 2,
                  ),
                ),
              ),
              error: (error, stack) => Text(error.toString()),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  void onPostalCodeChanged(WidgetRef ref, String text) {
    if (text.length != 7) {
      return;
    }
    try {
      int.parse(text);
      ref.watch(postalCodeProvider.notifier).state = text;
    } catch (e) {}
  }
}
