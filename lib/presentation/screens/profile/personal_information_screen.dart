import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/domain/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/user_controller.dart';
import 'package:yea_nay/presentation/widgets/image_picker_dialog.dart';

class PersonalInformationScreen extends StatefulWidget {
  static const String routeName = '/personal_information';
  const PersonalInformationScreen(
    this.user, {
    Key? key,
  }) : super(key: key);

  final UserModel user;

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateOfBirthInputController = TextEditingController();
  final UserController _userController = Get.put(UserController());

  String? _name, _email, _state, _city, _country;
  Timestamp? _dob;
  XFile? _file;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
    _state = widget.user.state;
    _city = widget.user.city;
    _country = widget.user.country;
    _dateOfBirthInputController.text = widget.user.dob != null ? DateFormat('MMMM, yyyy').format(widget.user.dob!.toDate()) : '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(title: Text("Personal Information".tr)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(SizeConfig.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(SizeConfig.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            PhysicalModel(
                              color: Get.theme.colorScheme.background,
                              shape: BoxShape.circle,
                              elevation: 3,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(color: Get.theme.colorScheme.primary.withOpacity(0.15), shape: BoxShape.circle),
                                child: _file != null
                                    ? Image.file(
                                        File(_file!.path),
                                        fit: BoxFit.cover,
                                        height: Get.width * 0.3,
                                        width: Get.width * 0.3,
                                      )
                                    : Image.network(
                                        widget.user.avatar ?? '',
                                        fit: BoxFit.cover,
                                        height: Get.width * 0.3,
                                        width: Get.width * 0.3,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Icon(
                                            Icons.account_circle_rounded,
                                            color: Get.theme.colorScheme.primary,
                                            size: Get.width * 0.3,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  _file = await showDialog<XFile?>(
                                    context: context,
                                    builder: (context) {
                                      return const ImagePickerDialog(title: "Pick your avatar from?");
                                    },
                                  );

                                  setState(() {});
                                },
                                child: PhysicalModel(
                                  color: Get.theme.colorScheme.background,
                                  shape: BoxShape.circle,
                                  elevation: 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Get.theme.colorScheme.background,
                                    ),
                                    padding: const EdgeInsets.all(SizeConfig.padding / 2),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: SizeConfig.padding * 2, color: Colors.grey),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: SizeConfig.padding),
                            FormBuilderTextField(
                              name: 'name',
                              onChanged: (value) => _name = value,
                              initialValue: _name ?? '',
                              decoration: const InputDecoration(
                                labelText: "Full name",
                              ),
                            ),
                            const SizedBox(height: SizeConfig.padding),
                            InkWell(
                              onTap: () => showMonthPicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 100, 5),
                                lastDate: DateTime(DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
                                initialDate: _dob != null ? _dob!.toDate() : DateTime.now(),
                              ).then((date) {
                                if (date != null) {
                                  setState(() {
                                    _dob = Timestamp.fromDate(date);
                                    _dateOfBirthInputController.text = DateFormat('MMMM, yyyy').format(date);
                                  });
                                }
                              }),
                              child: IgnorePointer(
                                child: FormBuilderTextField(
                                  name: 'date_of_birth',
                                  controller: _dateOfBirthInputController,
                                  textInputAction: TextInputAction.next,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(context),
                                  ]),
                                  decoration: const InputDecoration(
                                    labelText: 'Date of birth',
                                    suffixIcon: Icon(Icons.today),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: SizeConfig.padding),
                            FormBuilderTextField(
                              name: 'email',
                              onChanged: (value) => _email = value,
                              initialValue: _email ?? '',
                              decoration: const InputDecoration(
                                labelText: "Emaill",
                              ),
                            ),
                            const Divider(height: SizeConfig.padding * 2, color: Colors.grey),
                            FormBuilderTextField(
                              name: 'state',
                              onChanged: (value) => _state = value,
                              initialValue: _state ?? '',
                              decoration: const InputDecoration(
                                labelText: "State",
                              ),
                            ),
                            const SizedBox(height: SizeConfig.padding),
                            FormBuilderTextField(
                              name: 'city',
                              onChanged: (value) => _city = value,
                              initialValue: _city ?? '',
                              decoration: const InputDecoration(
                                labelText: "City",
                              ),
                            ),
                            const SizedBox(height: SizeConfig.padding),
                            FormBuilderTextField(
                              name: 'country',
                              onChanged: (value) => _country = value,
                              initialValue: _country ?? '',
                              decoration: const InputDecoration(
                                labelText: "Country",
                              ),
                            ),
                            const SizedBox(height: SizeConfig.padding),
                          ],
                        ),
                      ),
                      const Divider(height: SizeConfig.padding * 2, color: Colors.grey),
                      ElevatedButton(
                        onPressed: () {
                          _userController.updateUser(
                            UserModel(
                              id: widget.user.id,
                              avatar: widget.user.avatar,
                              name: _name,
                              email: _email,
                              dob: _dob,
                              location: widget.user.location,
                              state: _state,
                              city: _city,
                              country: _country,
                              areaOfInterest: widget.user.areaOfInterest,
                            ),
                            _file,
                          );
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
