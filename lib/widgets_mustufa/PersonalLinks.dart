import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API_Integration/Add Links/apiServices.dart';
import '../Custom_Widget/CustomContainer/OutlinedButton.dart';
import '../Utils/AppSizes.dart';
import '../Utils/colors.dart'; // Import your service class

class PersonalLinks extends StatefulWidget {
  const PersonalLinks({Key? key}) : super(key: key);

  @override
  _PersonalLinksState createState() => _PersonalLinksState();
}

class _PersonalLinksState extends State<PersonalLinks> {
  final List<String> _platforms = [
    'Certificate',
    'LOR',
    'LinkedIn',
    'Portfolio',
    'GitHub',
    'Other'
  ];
  String _selectedPlatform = 'LinkedIn';
  final TextEditingController _linkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddPersonalLinksService _service = AddPersonalLinksService(); // Initialize your service class

  Map<String, String> _existingLinks = {
    'LinkedIn': '',
    'GitHub': '',
    'Portfolio': '',
    'Other': '',
  };

  @override
  void initState() {
    super.initState();
    _loadPersonalLinks();
  }

  Future<void> _loadPersonalLinks() async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = prefs.getInt('profileId');
    if (profileId != null) {
      final links = await _service.getPersonalLinks();
      setState(() {
        for (var link in links) {
          if (link.containsKey('linkedin_url')) {
            _existingLinks['LinkedIn'] = link['linkedin_url'] ?? '';
          }
          if (link.containsKey('github_url')) {
            _existingLinks['GitHub'] = link['github_url'] ?? '';
          }
          if (link.containsKey('Portfolio')) {
            _existingLinks['Portfolio'] = link['Portfolio'] ?? '';
          }
          if (link.containsKey('Others')) {
            _existingLinks['Other'] = link['Others'] ?? '';
          }
        }
        _linkController.text = _existingLinks[_selectedPlatform] ?? '';
      });
    } else {
      print('Profile ID not found in SharedPreferences.');
    }
  }

  Future<void> _savePersonalLink() async {
    if (_formKey.currentState!.validate()) {
      final link = _linkController.text;
      final prefs = await SharedPreferences.getInstance();
      final profileId = prefs.getInt('profileId');
      if (profileId != null) {
        final details = {
          'linkedin_url': _existingLinks['LinkedIn'] ?? '',
          'github_url': _existingLinks['GitHub'] ?? '',
          'Portfolio': _existingLinks['Portfolio'] ?? '',
          'Others': _existingLinks['Other'] ?? '',
          'profile': profileId.toString(),
        };

        switch (_selectedPlatform) {
          case 'LinkedIn':
            details['linkedin_url'] = link;
            break;
          case 'GitHub':
            details['github_url'] = link;
            break;
          case 'Portfolio':
            details['Portfolio'] = link;
            break;
          case 'Other':
            details['Others'] = link;
            break;
          default:
            break;
        }

        final success = await _service.addPersonalLinks(details);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link added successfully!')),
          );
          setState(() {
            _existingLinks[_selectedPlatform] = link;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add link.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile ID not found')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      showEdit: false,
      title: 'Add Links',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PersonalLinksChild(
              platforms: _platforms,
              selectedPlatform: _selectedPlatform,
              onPlatformChanged: (String? newValue) {
                setState(() {
                  _selectedPlatform = newValue!;
                  _linkController.text = _existingLinks[_selectedPlatform] ?? '';
                });
              },
              linkController: _linkController,
            ),
            SizedBox(
              height: Sizes.responsiveMd(context),
            ),
            SizedBox(
              height: Sizes.responsiveLg(context) * 1.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.radiusXs),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: Sizes.responsiveVerticalSpace(context),
                        horizontal: Sizes.responsiveMdSm(context))),
                onPressed: _savePersonalLink,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Add Links ',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .apply(color: AppColors.white),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 8,
                      color: AppColors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PersonalLinksChild extends StatelessWidget {
  const PersonalLinksChild({
    Key? key,
    required this.platforms,
    required this.selectedPlatform,
    required this.onPlatformChanged,
    required this.linkController,
  }) : super(key: key);

  final List<String> platforms;
  final String selectedPlatform;
  final ValueChanged<String?> onPlatformChanged;
  final TextEditingController linkController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            width: Sizes.responsiveSm(context) * 25,
            height: Sizes.responsiveSm(context) * 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(width: 0.5, color: AppColors.secondaryText),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.responsiveSm(context) * 1.15,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPlatform,
                onChanged: onPlatformChanged,
                items: platforms.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.75),
                      ),
                    ),
                  );
                }).toList(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: Sizes.responsiveSm(context),
        ),
        Container(
          width: Sizes.responsiveSm(context) * 25,
          height: Sizes.responsiveSm(context) * 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                width: 0.5,
                color: linkController.text.isNotEmpty
                    ? AppColors.green
                    : AppColors.secondaryText,
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.responsiveSm(context) * 1.15,
            ),
            child: TextFormField(
              controller: linkController,
              decoration: InputDecoration(
                hintText: 'Paste Link',
                hintStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.25),
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a link';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
