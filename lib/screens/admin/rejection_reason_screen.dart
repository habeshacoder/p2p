import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/app_fontsize.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/screens/admin/manage_agent_status.dart';
import 'package:p2p/screens/admin/allwidget.dart';
import 'package:p2p/service/agent_service.dart';
import 'package:p2p/widgets/button.dart';
import 'package:provider/provider.dart';

class RejectionReason extends StatefulWidget {
  final String agentIdNumber;

  const RejectionReason({
    super.key,
    required this.agentIdNumber,
  });

  @override
  State<RejectionReason> createState() => _RejectionReasonState();
}

class _RejectionReasonState extends State<RejectionReason> {
  final _fieldKey = GlobalKey<FormFieldState>();
  final textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        title: Text(
          'Rejection Reason',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 100),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Why do you want to reject this agent?',
                style: TextStyle(
                    fontSize: P2pFontSize.descriptionalTexts,
                    fontFamily: P2pAppFontsFamily.descriptionTexts.fontFamily),
              ),
              SizedBox(
                height: P2pSizedBox.betweenInputAndText,
              ),
              TextFormField(
                key: _fieldKey,
                minLines: 3,
                maxLines: 4,
                validator: (value) {
                  if (value == "" || value == null) {
                    return "please enter valid value";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                    labelText: 'Enter Rejection Reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                onSaved: (value) {
                  setState(() {
                    // _name = value;
                  });
                },
                controller: textEditingController,
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        P2pAppColors.black), // Background color
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        width: 2.0, // Border width
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Border radius
                      ),
                    ),
                  ),
                  onPressed: rejectAgent,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Submit Rejection',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:
                                P2pAppFontsFamily.descriptionTexts.fontFamily,
                            fontSize: P2pFontSize.descriptionalTexts,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void rejectAgent() async {
    if (!_fieldKey.currentState!.validate() ||
        textEditingController.text.isEmpty) {
      return;
    }
    print('rejecting...............................');
    setState(() {
      isLoading = true;
    });
    try {
      final statusCode = await Provider.of<AgentService>(context, listen: false)
          .rejectAgent(agentIdNumber: widget.agentIdNumber, rejectionReason: {
        "rejectReason": textEditingController.text.trim(),
      });
      if (statusCode == 200 || statusCode == 201) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(
              'Agent item rejected successfully',
              style: TextStyle(color: P2pAppColors.yellow),
            ),
          ),
        );
        // Future.delayed(Duration(milliseconds: 1000));
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => AllWidget(),
        //     ));
        Navigator.of(context).pop();
        //
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'failed to reject Agent',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'failed to reject agent',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }
  }
}
