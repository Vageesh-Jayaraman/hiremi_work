import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info section
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harsh Pawar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'App ID: HM 23458 73432',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: screenWidth * 0.01),
                        const Text(
                          'Verified',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Account section
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                height: 70,
                width: 520,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextButton(
                  onPressed: () {

                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person_outline,
                            color: Colors.red, size: 20.0),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      const Expanded(
                        child: Text(
                          'Personal Info',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 25),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),

              const Text(
                'Privacy & Security',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                width: 520,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {

                      },

                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.folder_shared,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'Manage Permission',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 25),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.lock_outline,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'Change password',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 25),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.notifications_active_outlined,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Switch(
                              value: false,
                              onChanged: (value) {},
                              activeColor: Colors.white,
                              inactiveThumbColor: Colors.red),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.location_on_outlined,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'Location',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            activeTrackColor: Colors.red,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),

              const Text(
                'About & More',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Container(
                
                width: 520,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {

                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.menu_book,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'About Us',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Switch(
                            value: true,
                            onChanged: (value) {},
                            activeColor: Colors.white,
                            activeTrackColor: Colors.red,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {

                      },
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Icon(Icons.phone_forwarded_rounded,
                                color: Colors.red, size: 20.0),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          const Expanded(
                            child: Text(
                              'Help & Support',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.grey, size: 25),
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}