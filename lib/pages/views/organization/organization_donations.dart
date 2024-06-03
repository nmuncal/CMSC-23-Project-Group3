import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/donations_received_details.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'qr_scanner.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:cmsc_23_project_group3/styles.dart';

class OrganizationDonations extends StatefulWidget {
  const OrganizationDonations({super.key});

  @override
  State<OrganizationDonations> createState() => _OrganizationDonationsState();
}

class _OrganizationDonationsState extends State<OrganizationDonations> {
  bool _showCancelled = false;
  bool _sortAlphabetically = true;
  bool _sortAscending = true;
  late TextEditingController _searchController;
  List<Donation> _filteredDonations = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserAuthProvider>().user;
      if (user != null) {
        Provider.of<DonationProvider>(context, listen: false)
            .fetchDonationsReceived(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    context.read<DonationProvider>().dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(context),
    body: Consumer<DonationProvider>(
      builder: (context, donationProvider, child) {
        return StreamBuilder<List<Donation>>(
          stream: donationProvider.donationStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No donations found'));
            } else {
              final donations = snapshot.data!;
              _filteredDonations = _showCancelled
                  ? donations
                  : donations.where((donation) => donation.status != 'Cancelled').toList();
              _sortDonations();
              return Column(
                children: [
                  _buildSearchBar(),
                  _buildSortingIcons(), // Adding sorting icons here
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDonations.length,
                      itemBuilder: (context, index) {
                        final donation = _filteredDonations[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
  leading: _buildStatusIcon(donation.status),
  title: FutureBuilder<String?>(
    future: context.read<UserProvider>().getNameByUid(donation.donorId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error');
      } else {
        return Text(
          '${snapshot.data ?? 'Unknown Donor'}',
          style: TextStyle(fontWeight: FontWeight.bold),
        );
      }
    },
  ),
  subtitle: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${_formatDateTime(donation.selectedDateandTime)}',
        style: TextStyle(fontSize: 12),
      ),
      if (donation.isPickup)
        Text(
          'Pickup',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        )
      else
        Text(
          'Dropoff',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationDetailPage(donation: donation),
      ),
    );
  },
),

                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRCodeScannerPage()),
        );
      },
      child: Icon(Icons.qr_code),
    ),
  );
}


void _sortDonations() async {
  final donorNames = <String, String>{};

  // Pre-fetch donor names
  for (final donation in _filteredDonations) {
    if (!donorNames.containsKey(donation.donorId)) {
      donorNames[donation.donorId] = await context.read<UserProvider>().getNameByUid(donation.donorId) ?? '';
    }
  }

  // Sort donations
  if (_sortAlphabetically) {
    _filteredDonations.sort((a, b) {
      final nameA = donorNames[a.donorId]!.toLowerCase();
      final nameB = donorNames[b.donorId]!.toLowerCase();
      return _sortAscending ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });
  } else {
    _filteredDonations.sort((a, b) {
      return _sortAscending
          ? a.selectedDateandTime.compareTo(b.selectedDateandTime)
          : b.selectedDateandTime.compareTo(a.selectedDateandTime);
    });
  }
}
Widget _buildStatusIcon(String status) {
  switch (status) {
    case 'Pending':
      return Icon(Icons.access_time, color: Colors.black);
    case 'Confirmed':
    case 'Scheduled for Pick-up':
      return Icon(Icons.schedule, color: Colors.orange);
    case 'Cancelled':
      return Icon(Icons.cancel, color: Colors.red);
    case 'Complete':
      return Icon(Icons.done, color: Colors.green);
    default:
      return Icon(Icons.help, color: Colors.grey);
  }
}


  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.yMMMd().add_jms().format(dateTime);
  }
AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Donations Received',
          style: TextStyle(
            color: Styles.mainBlue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(_showCancelled ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _showCancelled = !_showCancelled;
          });
        },
      ),
    ],
  );
}

Widget _buildSortingIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      IconButton(
        icon: Icon(Icons.sort_by_alpha),
        onPressed: () {
          setState(() {
            _sortAlphabetically = true;
            _sortAscending = !_sortAscending;
            _sortDonations();
          });
        },
      ),
      IconButton(
        icon: Icon(Icons.access_time),
        onPressed: () {
          setState(() {
            _sortAlphabetically = false;
            _sortAscending = !_sortAscending;
            _sortDonations();
          });
        },
      ),
    ],
  );
}

Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search by name',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _filteredDonations = _filterDonations(value);
        });
      },
    ),
  );
}

  List<Donation> _filterDonations(String query) {
    return _filteredDonations.where((donation) {
      final donorName = context.read<UserProvider>().getNameByUid(donation.donorId);
      return '${donorName}'.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
