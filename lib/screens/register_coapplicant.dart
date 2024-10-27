import 'package:flutter/material.dart';
class RegisterCoApplicant extends StatefulWidget {
  const RegisterCoApplicant({super.key});

  @override
  State<RegisterCoApplicant> createState() => _RegisterCoApplicantState();
}

class _RegisterCoApplicantState extends State<RegisterCoApplicant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Please Enter Details of your guardian', style: TextStyle(fontWeight: FontWeight.w500),),
          const SizedBox(height: 10,),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Email')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Name')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Phone')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('DOB')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Relation')
            ),
          ),
          const SizedBox(height: 10,),
          const Text('Document', style: TextStyle(fontWeight: FontWeight.w500),),
          const SizedBox(height: 10,),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Doc Type')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Doc Id')
            ),
          ),
          const SizedBox(height: 10,),
          const Text('Employment Details', style: TextStyle(fontWeight: FontWeight.w500),),
          const SizedBox(height: 10,),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Company Name')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Work Email')
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text('Monthly Income')
            ),
          ),

        ],
      ),
    );
  }
}
