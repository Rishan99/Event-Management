import 'package:event_management/core/route/routes.dart';
import 'package:event_management/core/utils/ui_helper.dart';
import 'package:event_management/core/utils/utils.dart';
import 'package:event_management/services/provider/city_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class CityView extends StatefulWidget {
  const CityView({super.key});

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {
  final TextEditingController _cityNameController = TextEditingController();
  late final CityProvider _cityProvider;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    _cityProvider = Provider.of<CityProvider>(context, listen: false);
    _cityNameController.text = _cityProvider.selectedCity ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose a city",
        ),
      ),
      body: Padding(
        padding: pageSidePadding,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                formSeperatorBox(),
                TextFormField(
                  controller: _cityNameController,
                  decoration: const InputDecoration(hintText: "Enter city name to search"),
                  validator: Validators.cityNameValidator,
                ),
                formSeperatorBox(),
                formSeperatorBox(),
                TextButton(
                  onPressed: () async {
                    ProgressDialog pr = ProgressDialog(context, dialogMessage: "Fetching city location...");
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (formKey.currentState!.validate()) {
                      _cityProvider.updateCity(_cityNameController.text);
                      await pr.show();
                      try {
                        await _cityProvider.getWeather();
                        pr.hide();
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        } else
                          Navigator.of(context).pushReplacementNamed(Routes.homePage);
                      } on Exception catch (e) {
                        pr.hide();
                        failureSnackBar(e.toString());
                      } catch (e) {
                        pr.hide();
                        failureSnackBar(e.toString());
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
