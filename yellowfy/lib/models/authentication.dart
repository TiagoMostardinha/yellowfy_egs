class Authentication {
  final int id;
  final String email;
  final String name;
  final String password;
  final bool looking_for_work;
  final String mobile_number;

  Authentication(
    this.id,
    this.email,
    this.password,
    this.name,
    this.looking_for_work,
    this.mobile_number,
  );
}
