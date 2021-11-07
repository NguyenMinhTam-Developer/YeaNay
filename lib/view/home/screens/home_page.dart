import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polls/polls.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double option1 = 2.0;
  double option2 = 1.0;
  double option3 = 4.0;
  double option4 = 3.0;
  String user = "user@gmail.com";
  Map usersWhoVoted = {'test@gmail.com': 1, 'deny@gmail.com': 3, 'kent@gmail.com': 2, 'xyz@gmail.com': 3};
  String creator = "admin@gmail.com";
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32,
            ),
            Image.asset(
              'assets/icons/yeanay.png',
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            postWidget(context),
            const SizedBox(
              height: 10,
            ),
            postWidget(context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  // Widget votingCard(String text, Color color) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //            builder: (context) => ViewPostPage(),),
  //  );
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: 220,
  //       padding: EdgeInsets.only(
  //         top: 10,
  //         bottom: 10,
  //         left: 10,
  //         right: 10,
  //       ),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: color,
  //       ),
  //       child: Center(
  //           child: Text(
  //         text,
  //         style: TextStyle(
  //           fontSize: 20,
  //         ),
  //       )),
  //     ),
  //   );
  // }

  Widget postWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/icons/Profile Image.png"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Muhammad Talha Sultan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('1 day ago'),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 25,
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 220,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
            ),
            child: const Center(
                child: Text(
              'Since we are in a long weekend which is thanksgiving so has anybody eaten turkey before??  Let me know fellas...',
              style: TextStyle(
                fontSize: 20,
              ),
            )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Polls(
                children: [
                  // This cannot be less than 2, else will throw an exception
                  Polls.options(title: 'Cairo', value: option1),
                  Polls.options(title: 'Mecca', value: option2),
                  Polls.options(title: 'Denmark', value: option3),
                  Polls.options(title: 'Mogadishu', value: option4),
                ],
                question: const Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentUser: user,
                creatorID: creator,
                voteData: usersWhoVoted,
                userChoice: usersWhoVoted[user],
                onVoteBackgroundColor: Colors.blue,
                leadingBackgroundColor: Colors.blue,
                backgroundColor: Colors.white,
                onVote: (choice) {
                  setState(() {
                    usersWhoVoted[user] = choice;
                  });
                  if (choice == 1) {
                    setState(() {
                      option1 += 1.0;
                    });
                  }
                  if (choice == 2) {
                    setState(() {
                      option2 += 1.0;
                    });
                  }
                  if (choice == 3) {
                    setState(() {
                      option3 += 1.0;
                    });
                  }
                  if (choice == 4) {
                    setState(() {
                      option4 += 1.0;
                    });
                  }
                },
              ),
              const Text('50K Votes'),
            ],
          ),
        ],
      ),
    );
  }
}
