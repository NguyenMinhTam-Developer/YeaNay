import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:yea_nay/domain/models/user_model.dart';
import 'interest_picking_screen.dart';
import '../../widgets/image_picker_dialog.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateOfBirthInputController = TextEditingController();
  XFile? _file;

  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      fillColor: Colors.grey.shade200,
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: _file != null
                              ? Image.file(
                                  File(_file!.path),
                                  fit: BoxFit.cover,
                                )
                              : widget.user.avatar != null
                                  ? Image.network(
                                      widget.user.avatar!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.asset(
                                          'assets/icons/Profile Image.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/icons/Profile Image.png',
                                      fit: BoxFit.cover,
                                    ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: SizedBox(
                          height: 46,
                          width: 46,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: const BorderSide(color: Colors.white),
                              ),
                              primary: Colors.white,
                              backgroundColor: const Color(0xFFF5F6F9),
                            ),
                            onPressed: () async {
                              _file = await showDialog<XFile?>(
                                context: context,
                                builder: (context) {
                                  return const ImagePickerDialog(title: "Pick your avatar from?");
                                },
                              );

                              setState(() {});
                            },
                            child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              //
              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'display_name',
                onChanged: (value) => _user.name = value,
                initialValue: _user.name,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                decoration: inputDecoration.copyWith(hintText: 'Display name'),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: () => showMonthPicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 100, 5),
                  lastDate: DateTime(DateTime.now().year - 16, DateTime.now().month, DateTime.now().day),
                  initialDate: DateTime.now(),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      _user.dob = Timestamp.fromDate(date);
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
                    decoration: inputDecoration.copyWith(
                      hintText: 'Date of birth',
                      suffixIcon: const Icon(Icons.today),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'email',
                onChanged: (value) => _user.email = value,
                initialValue: _user.email,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                decoration: inputDecoration.copyWith(
                  hintText: 'Email address',
                  suffixIcon: const Icon(Icons.alternate_email_rounded),
                ),
                keyboardType: TextInputType.emailAddress,
              ),

              const Divider(height: 32),

              FormBuilderTextField(
                name: 'city',
                onChanged: (value) => _user.city = value,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                decoration: inputDecoration.copyWith(hintText: 'City'),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'state',
                onChanged: (value) => _user.state = value,
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                decoration: inputDecoration.copyWith(hintText: 'State'),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'country',
                onChanged: (value) => _user.country = value,
                textInputAction: TextInputAction.done,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                decoration: inputDecoration.copyWith(hintText: 'Country'),
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Get.to(() => InterestPickingScreen(
                          user: widget.user,
                          file: _file,
                        ));
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
