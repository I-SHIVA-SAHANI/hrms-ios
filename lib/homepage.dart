import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hrms/locationfetching.dart';
import 'package:hrms/login.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  String _checkinOutTime = '';
  String _name = '';
  String _employeeId = '';

  // Flag to indicate check-in/out progress

  // latitude and longitude variables
  late double lat;
  late double long;
  String locationMessage = 'NILL';

  // Styling for the buttons
  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: const Color.fromARGB(255, 0, 191, 255));
  TextStyle textStyle = const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold);

  Locationfetching locationfetching = Locationfetching();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443ca9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Employee Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                const Text(
                  "Qineos Software Private Limited",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 1),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Employee Name : ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Flexible(
                          child: Text(
                            _name.isEmpty ? "<<Name>>" : _name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Employee ID : ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Flexible(
                          child: Text(
                            _employeeId.isEmpty
                                ? "<<employee ID>>"
                                : _employeeId,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //CARD VIEW

                const SizedBox(height: 100),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status: ",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  _checkinOutTime.isEmpty
                                      ? "Not Checked In/Out"
                                      : _checkinOutTime,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Location: ",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  locationMessage,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //Buttons

                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              fetchLocation();
                              DateTime now = DateTime.now();
                              String format =
                                  DateFormat('dd-MM-yyyy hh:mm:ss a')
                                      .format(now);

                              setState(() {
                                _checkinOutTime = "Checked in at $format";
                              });
                            },
                            style: buttonStyle,
                            child: Text(
                              "Check In",
                              style: textStyle,
                            ),
                          ),

                          //Checkout Button
                          ElevatedButton(
                            onPressed: () {
                              fetchLocation();
                              DateTime now = DateTime.now();
                              String format =
                                  DateFormat('dd-MM-yyyy hh:mm:ss a')
                                      .format(now);
                              setState(() {
                                _checkinOutTime = "Checked out at $format";
                              });
                            },
                            style: buttonStyle,
                            child: Text(
                              "Checkout",
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: buttonStyle,
                            onPressed: generatePdfReport,
                            child: Text(
                              "Submit",
                              style: textStyle,
                            ),
                          ),
                          ElevatedButton(
                            style: buttonStyle,
                            onPressed: signOut,
                            child: Text(
                              "Logout",
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // fetch Employee Data
  Future<void> _fetchEmployeeData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final docSnap = await FirebaseFirestore.instance
          .collection("Employees")
          .doc(userId)
          .get();
      if (docSnap.exists) {
        final employeeData = docSnap.data()!;
        setState(() {
          _name = employeeData['Name'];
          _employeeId = employeeData['Employee ID'];
        });
      } else {
        Fluttertoast.showToast(msg: "No Employee data Found");
      }
    } else {
      Fluttertoast.showToast(msg: "No Logged in user");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  // Fetching the current user location

  void fetchLocation() {
    locationfetching.getCurrentLocation().then((value) {
      lat = value.latitude;
      long = value.longitude;
      placemarkFromCoordinates(lat, long).then((placemarks) {
        Placemark placemark = placemarks.first;
        setState(() {
          locationMessage =
              '${placemark.street}, ${placemark.thoroughfare}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
        });
      });
    });
  }

  Future<void> generatePdfReport() async {
    // Set default values if parameters are null
    // employeeName ??= _name;
    // employeeID ??= _employeeId;
    // location ??= locationMessage;

    final pdf = pw.Document();

    // Load logo as Uint8List
    final ByteData logoData =
        await rootBundle.load('assets/images/companyLogo.jpg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    // Create PDF page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Add logo
              pw.Image(
                pw.MemoryImage(logoBytes),
                width: 180,
                height: 150,
              ),
              pw.SizedBox(height: 20),

              // Title and employee details
              pw.Text(
                "Qineos Software Private Limited",
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Employee Attendance Report",
                style: const pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Name: $_name", style: const pw.TextStyle(fontSize: 16)),
              pw.Text("Employee-ID: $_employeeId",
                  style: const pw.TextStyle(fontSize: 16)),
              pw.Text("Location: $locationMessage",
                  style: const pw.TextStyle(fontSize: 16)),

              // Check-in and check-out times

              pw.Text("Status: $_checkinOutTime",
                  style: const pw.TextStyle(fontSize: 16)),
            ],
          );
        },
      ),
    );

    // Get the directory to save the PDF file
    final Directory outputDir = await getApplicationDocumentsDirectory();
    final String filePath =
        "${outputDir.path}/attendance_report_$_checkinOutTime.pdf";

    // Save PDF file
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    // Add any additional actions after sign-out, like navigating to a login screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
