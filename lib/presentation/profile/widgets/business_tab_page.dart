import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:vba/presentation/profile/bloc/profile_bloc.dart';

class BusinessTabPage extends StatelessWidget {
  const BusinessTabPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Thông tin Doanh nghiệp',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (state.user?.productsAndServices != null)...[
              HtmlWidget(state.user!.productsAndServices!),
            ],
            // ... Thêm các widget khác
          ],
        );
      },
    );
  }
}
