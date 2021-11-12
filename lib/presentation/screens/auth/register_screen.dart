import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../interest_picking_screen.dart';
import '../../widgets/image_picker_dialog.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
    this.avatarUrl,
    this.displayName,
    this.email,
  }) : super(key: key);

  final String? avatarUrl, displayName, email;

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateOfBirthInputController = TextEditingController();

  String? _displayName, _dateOfBirth, _email, _city, _state, _country;

  XFile? _selectedImage;

  FocusNode? _displayNameNode;
  FocusNode? _dateOfBirthNode;
  FocusNode? _emailNode;
  FocusNode? _cityNode;
  FocusNode? _stateNode;
  FocusNode? _countryNode;

  @override
  void initState() {
    super.initState();

    _displayName = widget.displayName;
    _email = widget.email;

    _displayNameNode = FocusNode();
    _dateOfBirthNode = FocusNode();
    _emailNode = FocusNode();
    _cityNode = FocusNode();
    _stateNode = FocusNode();
    _countryNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _displayNameNode!.dispose();
    _dateOfBirthNode!.dispose();
    _emailNode!.dispose();
    _cityNode!.dispose();
    _stateNode!.dispose();
    _countryNode!.dispose();
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
                          child: _selectedImage != null
                              ? Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : widget.avatarUrl != null
                                  ? Image.network(
                                      widget.avatarUrl!,
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
                              _selectedImage = await showDialog<XFile?>(
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
                onChanged: (value) => _displayName = value,
                onEditingComplete: () => _dateOfBirthNode!.requestFocus(),
                initialValue: _displayName,
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
                  lastDate: DateTime(DateTime.now().year, DateTime.now().month),
                  initialDate: DateTime.now(),
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      _dateOfBirth = DateFormat('MMMM, yyyy').format(date);
                      _dateOfBirthInputController.text = _dateOfBirth ?? '';
                    });
                  }
                }),
                child: IgnorePointer(
                  child: FormBuilderTextField(
                    name: 'date_of_birth',
                    focusNode: _dateOfBirthNode,
                    controller: _dateOfBirthInputController,
                    onChanged: (value) => _dateOfBirth = value.toString(),
                    onEditingComplete: () => _emailNode!.requestFocus(),
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
                focusNode: _emailNode,
                onChanged: (value) => _email = value,
                onEditingComplete: () => _cityNode!.requestFocus(),
                initialValue: _email,
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
                focusNode: _cityNode,
                onChanged: (value) => _city = value,
                onEditingComplete: () => _stateNode!.requestFocus(),
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
                focusNode: _stateNode,
                onChanged: (value) => _state = value,
                onEditingComplete: () => _countryNode!.requestFocus(),
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
                focusNode: _countryNode,
                onChanged: (value) => _country = value,
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
                          displayName: _displayName!,
                          dateOfBirth: _dateOfBirth!,
                          email: _email!,
                          city: _city!,
                          state: _state!,
                          country: _country!,
                          avatarUrl: widget.avatarUrl,
                          selectedImage: _selectedImage,
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
