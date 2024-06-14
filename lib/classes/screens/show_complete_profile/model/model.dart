class UserData {
  final String dob;
  final String occupation;
  final String annualIncome;
  final String sourceOfIncome;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String ssn;

  UserData({
    required this.dob,
    required this.occupation,
    required this.annualIncome,
    required this.sourceOfIncome,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.ssn,
  });

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      dob: data['dob'] ?? '',
      occupation: data['occupation'] ?? '',
      annualIncome: data['Salary'] ?? '',
      sourceOfIncome: data['PlaceOfWork'] ?? '',
      address: data['address'] ?? '',
      city: data['City'] ?? '',
      state: data['state'] ?? '',
      postalCode: data['zipcode'] ?? '',
      ssn: data['ssn'] ?? '',
    );
  }
}
