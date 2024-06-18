import 'package:ams/widgets/add_member_widget.dart';
import 'package:ams/widgets/member_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  bool showAddMemberCard = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Team 01'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(4.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Members',
                  style:
                      TextStyle(fontSize: 2.5.h, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      SizedBox(width: 2.0.w),
                      const Text('Search'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4.0.h),
                    child: MemberWidget(
                      name: 'kamal',
                      memberNumber: index.toString(),
                      shortLeaves: 2,
                      halfDays: 5,
                      fullDays: 3,
                    ),
                  );
                },
              ),
            ),
            if (showAddMemberCard) const AddMemberCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showAddMemberCard = !showAddMemberCard;
                    });
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Member',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                ),
                Row(
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle save logic here
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        label: const Text(''),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle delete logic here
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        label: const Text(''),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
