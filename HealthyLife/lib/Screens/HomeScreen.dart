import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/dietPlanScreen.dart';
import 'package:healthy_me/Screens/tracMacrosScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'factsScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const baseurl = "https://healthy-me-sever.herokuapp.com";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isButtonDiasbled = false;
  bool fetchingData = false;
  Widget loadingWidget() {
    if (fetchingData == false) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Loading',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          SpinKitWave(
            color: Colors.pinkAccent,
            size: 15.0,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('assets/health.png'),
                  backgroundColor: Colors.black,
                  radius: 35.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Healthy Life',
                  style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Healthy Life is a health tracker app. Keep your health on track and change yourself by choosing from the wide variety of features this app provides.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                OutlineButton(
                  highlightedBorderColor: Colors.pinkAccent,
                  onPressed: isButtonDiasbled
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/bmi_screen');
                        },
                  child: Text('BMI Calculator',
                      style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
                ),
                OutlineButton(
                  highlightedBorderColor: Colors.pinkAccent,
                  onPressed: isButtonDiasbled
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/calorie_screen');
                        },
                  child: Text('Calorie Counter',
                      style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
                ),
                OutlineButton(
                  highlightedBorderColor: Colors.pinkAccent,
                  onPressed: isButtonDiasbled
                      ? null
                      : () async {
                          var url = '$baseurl/api/foodMacros';
                          try {
                            setState(() {
                              fetchingData = true;
                              isButtonDiasbled = true;
                            });
                            var response = await http.get(url);
                            setState(() {
                              fetchingData = false;
                              isButtonDiasbled = false;
                            });
                            print('Response status: ${response.statusCode}');
                            if (response.statusCode == 200) {
                              var foods = json.decode(response.body);
                              List<String> foodNames = [];
                              foods.forEach((var food) {
                                foodNames.add(food['foodName']);
                              });
                              print(foodNames);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TracMacrosScreen(
                                    foodList: foodNames,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FactsScreen(
                                      title: 'Network Error',
                                      description:
                                          "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error $e');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FactsScreen(
                                    title: 'Network Error',
                                    description:
                                        "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                              ),
                            );
                          }
                        },
                  child: Text('Calorie Tracker',
                      style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
                ),
                OutlineButton(
                  highlightedBorderColor: Colors.pinkAccent,
                  onPressed: isButtonDiasbled
                      ? null
                      : () async {
                          var url = '$baseurl/api/weightLoss';
                          try {
                            setState(() {
                              fetchingData = true;
                              isButtonDiasbled = true;
                            });
                            var response = await http.get(url);
                            setState(() {
                              fetchingData = false;
                              isButtonDiasbled = false;
                            });
                            print('Response status: ${response.statusCode}');
                            if (response.statusCode == 200) {
                              var plans = json.decode(response.body);
                              List<String> planTitles = [];
                              plans.forEach((var planTitle) {
                                planTitles.add(planTitle['title']);
                              });
                              print(planTitles);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DietPlanScreen(
                                    titles: planTitles,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FactsScreen(
                                      title: 'Network Error',
                                      description:
                                          "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error $e');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FactsScreen(
                                    title: 'Network Error',
                                    description:
                                        "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                              ),
                            );
                          }
                        },
                  child: Text('Diet Plans',
                      style: TextStyle(fontSize: 20, color: Colors.pinkAccent)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
