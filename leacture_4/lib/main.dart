import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

const people = [
  Person(name: "John", age: 20, emoji: "💁🏽‍"),
  Person(name: "Jane", age: 21, emoji: "👩🏽‍🦰"),
  Person(name: "Jack", age: 22, emoji: "👨🏽‍🦳"),
];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, idx) {
          final person = people[idx];

          return ListTile(
            leading: Text(
              person.emoji,
              style: const TextStyle(fontSize: 40),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_sharp, size: 14),
            title: Text(person.name),
            subtitle: Text("${person.age} years old"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DetailsPage(person: person);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Person person;

  const DetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          person.emoji,
          style: const TextStyle(fontSize: 40),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              person.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "${person.age} years old",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
