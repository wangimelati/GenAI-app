import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skin Match AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SkincareRoutineScreen(),
    );
  }
}

class SkincareRoutineScreen extends StatefulWidget {
  @override
  _SkincareRoutineScreenState createState() => _SkincareRoutineScreenState();
}

class _SkincareRoutineScreenState extends State<SkincareRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _skinTypeController = TextEditingController();
  final TextEditingController _skinConcernsController = TextEditingController();
  final TextEditingController _currentSkincareController = TextEditingController();

  String _result = '';
  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _apiService.getSkincareRoutine(
          _skinTypeController.text,
          _skinConcernsController.text,
          _currentSkincareController.text,
        );
        setState(() {
          _result = result;
        });
      } catch (e) {
        setState(() {
          _result = 'Error: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Match AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _skinTypeController,
                decoration: InputDecoration(labelText: 'Skin Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your skin type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _skinConcernsController,
                decoration: InputDecoration(labelText: 'Skin Concerns'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your skin concerns';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _currentSkincareController,
                decoration: InputDecoration(labelText: 'Current Skincare'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current skincare';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Get Skincare Routine'),
                    ),
              SizedBox(height: 16.0),
              _result.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          _result,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
