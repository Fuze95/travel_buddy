import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/faq_list_widget.dart';

class TravelGuideScreen extends StatefulWidget {
  const TravelGuideScreen({Key? key}) : super(key: key);

  @override
  State<TravelGuideScreen> createState() => _TravelGuideScreenState();
}

class _TravelGuideScreenState extends State<TravelGuideScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<FAQItem> get _faqItems => [
    FAQItem(
      question: 'What is the best time to visit Sri Lanka?',
      answer: 'The best time depends on what you want to experience. Peak season is from December to March (dry season), but you can find good weather in other months too.',
    ),
    FAQItem(
      question: 'What currency is used in Sri Lanka?',
      answer: 'Sri Lankan Rupee (LKR)',
    ),
    FAQItem(
      question: 'Do I need a visa to visit Sri Lanka?',
      answer: 'Visa requirements vary depending on your nationality. Check the official Sri Lanka Tourism website for the latest information.',
    ),
    FAQItem(
      question: 'How can I get around Sri Lanka?',
      answer: 'Options include trains, buses, taxis, tuk-tuks, and renting a car/motorbike.',
    ),
    FAQItem(
      question: 'Are there any domestic flights within Sri Lanka?',
      answer: 'Yes, there are domestic flights between major cities.',
    ),
    FAQItem(
      question: 'Is it safe to drink tap water in Sri Lanka?',
      answer: 'No, it is generally not recommended to drink tap water in Sri Lanka. Stick to bottled water.',
    ),
    FAQItem(
      question: 'What are the different types of accommodation available in Sri Lanka?',
      answer: 'From budget guesthouses and homestays to luxury resorts and boutique hotels.',
    ),
    FAQItem(
      question: 'Can I find affordable accommodation in Sri Lanka?',
      answer: 'Yes, there are plenty of budget-friendly options available, especially outside peak season.',
    ),
    FAQItem(
      question: 'What are the must-see attractions in Sri Lanka?',
      answer: 'Sigiriya Rock Fortress, Dambulla Cave Temple, Kandy Temple of the Tooth, Yala National Park, Galle Fort.',
    ),
    FAQItem(
      question: 'What are some popular beaches in Sri Lanka?',
      answer: 'Bentota, Unawatuna, Mirissa, Arugam Bay',
    ),
    // more FAQs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: Column(
        children: [
          // Fixed Header Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Travel',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Guides',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: FAQListWidget(faqs: _faqItems),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        noFill: false,
        onTap: (index) {},
      ),
    );
  }
}