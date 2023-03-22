import 'package:finderr/pages/roles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Text(
                  "Finder X BMSCE",
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Text(
                  "Connecting Teachers & Students !",
                  style: GoogleFonts.varela(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 400,
              width: 500,
              child: Lottie.network(
                'https://assets8.lottiefiles.com/packages/lf20_lxnm28aj.json',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoButton(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).backgroundColor,
                        onPressed: () {
                          _navigateToNextScreen(context);
                        },
                        child: const Center(
                            child: Text(
                          "Get Started",
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewScreen()));
  }
}

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Text(
                  "Interact & acquire projects of similar interests & needs! ",
                  style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 400,
              width: 500,
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_yCjSOH1fA9.json',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoButton(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).backgroundColor,
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const Roles();
                          }));
                        },
                        child: const Center(
                            child: Text(
                          "Next",
                          style: TextStyle(color: Colors.black, fontSize: 16.0),
                        ))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
