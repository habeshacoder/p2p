import 'package:flutter/material.dart';
import 'package:p2p/appStyles/app_colors.dart';
import 'package:p2p/appStyles/fontsfamiliy.dart';
import 'package:p2p/appStyles/sized_boxes.dart';
import 'package:p2p/models/agent_model.dart';
import 'package:p2p/screens/admin/manage_agent_status.dart';
import 'package:p2p/screens/admin/rejection_reason_screen.dart';
import 'package:p2p/service/agent_service.dart';
import 'package:provider/provider.dart';

class AllWidget extends StatefulWidget {
  const AllWidget({super.key});

  @override
  State<AllWidget> createState() => _AllWidgetState();
}

class _AllWidgetState extends State<AllWidget> {
  late Future<List<DeliveryAgentModel>> agents;
  List<bool> isLoadingList = [];

  Future<void> _refreshOrders() async {
    setState(() {
      agents = Provider.of<AgentService>(context, listen: false)
          .fetchAllAgents(isFromAll: true);
    });
  }

  @override
  void didChangeDependencies() {
    print('get mu order ...........');

    agents = Provider.of<AgentService>(context, listen: false)
        .fetchAllAgents(isFromAll: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: agents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          //add values to loading
          if (snapshot.data!.isEmpty) {
            return Text('No agent data is available');
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    "${snapshot.data![index].user!.firstName![0].toUpperCase()}${snapshot.data![index].user!.lastName![0].toUpperCase()}",
                                    style: TextStyle(
                                        fontFamily: P2pAppFontsFamily
                                            .descriptionTexts.fontFamily),
                                  )),
                              SizedBox(
                                width: 3,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${snapshot.data![index].user!.firstName} ${snapshot.data![index].user!.lastName}'),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                          '${snapshot.data![index].user!.address!.street}, ${snapshot.data![index].user!.address!.city}'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.call,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                          '${snapshot.data![index].user!.userName}'),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.delete,
                                color: Colors.red,
                              )
                            ],
                          ),
                        ),
                        if (snapshot.data![index].approvedStatus == 'PENDING' ||
                            snapshot.data![index].approvedStatus == 'REJECTED')
                          TextButton(
                              onPressed: () {
                                approveAgent(
                                    index,
                                    snapshot.data![index].agentIdNumber!,
                                    'APPROVED');
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        P2pAppColors.black), // Background color
                                side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                    width: 2.0, // Border width
                                  ),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Border radius
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified, color: Colors.white),
                                  Text(
                                    'Approve',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )),
                        if (snapshot.data![index].approvedStatus == 'APPROVED')
                          TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RejectionReason(
                                        agentIdNumber: snapshot
                                            .data![index].agentIdNumber!),
                                  )).then((value) {
                                _refreshOrders();
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  P2pAppColors.black), // Background color
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                  width: 2.0, // Border width
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Border radius
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon(Icons.verified, color: Colors.white),
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 26,
                                      color: P2pAppColors.white,
                                    ), // The first icon
                                    Positioned(
                                      top: 10,
                                      left: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: P2pAppColors.red,
                                            shape: BoxShape.circle),
                                        child: Icon(Icons.close,
                                            size: 13,
                                            color: P2pAppColors.white),
                                      ), // The close icon positioned at the top right corner
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Reject',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                      ],
                    ));
              });
        }
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Please try again later.'),
                    SizedBox(
                      height: P2pSizedBox.betweenButton,
                    ),
                    Text('${snapshot.error}'),
                  ]),
            ),
          );
        }
        return Center(
          child: Text('no available data'),
        );
      },
    );
  }

  void approveAgent(
      int index, String agentIdNumber, String approvedStatus) async {
    print('approving...............................');
    // setState(() {
    //   isLoadingList[index] = true;
    // });
    try {
      final statusCode = await Provider.of<AgentService>(context, listen: false)
          .approveAgent(
              agentIdNumber: agentIdNumber, approvedStatus: approvedStatus);
      if (statusCode == 200 || statusCode == 201) {
        // setState(() {
        //   isLoadingList[index] = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(
              'Agent item approved successfully',
              style: TextStyle(color: P2pAppColors.yellow),
            ),
          ),
        );
        await _refreshOrders();

        //
      } else {
        // setState(() {
        //   isLoadingList[index] = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
              'failed to approve Agent',
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
        return;
      }
    } catch (error) {
      // setState(() {
      //   isLoadingList[index] = false;
      // });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'failed to approve agent',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }
  }
}
