import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(QuoteApp());

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});
}

class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  List<Quote> quotes = [];

  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random/'));
    if (response.statusCode == 200) {
      final quoteData = json.decode(response.body);
      final quote = Quote(
        text: quoteData[0]['q'],
        author: quoteData[0]['a'],
      );
      setState(() {
        quotes.add(quote);
      });
    } else {
      throw Exception('Failed to load quote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Zen Quotes App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (quotes.isNotEmpty)
                Column(
                  children: [
                    Text(
                      quotes.last.text,
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "- ${quotes.last.author}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => fetchQuote(),
                child: Text('Refresh Quote'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuoteListScreen(quotes),
                    ),
                  );
                },
                child: Text('View List of Quotes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuoteListScreen extends StatelessWidget {
  final List<Quote> quotes;

  QuoteListScreen(this.quotes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Quotes'),
      ),
      body: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quotes[index].text,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "- ${quotes[index].author}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
