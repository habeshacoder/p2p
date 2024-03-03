import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/widgets/phone_input.dart';

// ignore: must_be_immutable
class Textarea extends StatefulWidget {
  Textarea(
      {super.key,
      required this.hint,
      required this.isValid,
      required this.isObscure,
      required this.isPassword,
      required this.icon,
      required this.onChanged,
      required this.controller,
      required this.isAuthentication,
      this.setObscure,
      this.isEnabled,
      this.label,
      this.title,
      this.isPick,
      this.isPhone,
      this.isMap,
      this.isDescription,
      this.isDate,
      this.context,
      this.setDateTime,
      this.setPhoneNumber});
  late String hint;
  String? label;
  bool isValid;
  bool isObscure;
  bool? isDescription;
  bool? isEnabled;
  bool isPassword;
  bool isAuthentication;
  String? title;
  bool? isPhone;
  bool? isPick;
  bool? isMap;
  bool? isDate;
  Function? setDateTime;
  BuildContext? context;
  late IconData icon;
  final ValueChanged<String> onChanged;
  final VoidCallback? setObscure;
  final TextEditingController controller;
  void Function(String)? setPhoneNumber;

  @override
  State<Textarea> createState() => _TextareaState();
}

class _TextareaState extends State<Textarea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != Null)
          Text(
            widget.title ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: P2pFontSize.p2p11,
              color: P2pAppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        const SizedBox(
          height: 10,
        ),
        widget.isPhone != Null && widget.isPhone == true
            ? PhoneInput(
                setPhoneNumber: widget.setPhoneNumber,
              )
            : TextFormField(
                // maxLength: 12,
                // keyboardType: TextInputType.number,
                readOnly: widget.isDate == true ? true : false,
                maxLines: widget.isDescription == true ? 3 : 1,
                minLines: widget.isDescription == true ? 3 : 1,
                obscureText: widget.isPassword && widget.isObscure,
                decoration: InputDecoration(
                  suffixIcon: widget.isAuthentication
                      ? widget.isPassword
                          ? IconButton(
                              icon: Icon(
                                widget.isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                widget.setObscure!();
                              },
                            )
                          : IconButton(
                              onPressed: widget.isDate == true
                                  ? () => {
                                        print("excuted"),
                                        widget.setDateTime!(context)
                                      }
                                  : () => {},
                              icon: Icon(widget.icon))
                      : const Icon(null),
                  prefixIcon:
                      widget.isAuthentication || widget.isDescription == true
                          ? const Icon(null)
                          : IconButton(
                              icon: Icon(widget.icon),
                              onPressed: widget.isMap == true
                                  ? () => Navigator.pushNamed(context, '/map',
                                      arguments: {'is_pick': widget.isPick})
                                  : () => {},
                            ),
                  hintText: widget.hint,
                  labelText: widget.label,
                  hintStyle: TextStyle(
                      color: P2pAppColors.normal,
                      fontSize: P2pFontSize.p2p14,
                      fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15),
                ),
                controller: widget.controller,
                enabled: widget.isEnabled,
              ),
      ],
    );
  }
}
