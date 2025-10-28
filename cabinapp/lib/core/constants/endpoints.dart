class ApiConstants {
  static const baseUrl = 'http://localhost:3000'; // reemplaza con tu dominio o localhost

  // ---- Auth ----
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/getMe';

  // ---- Organizations ----
  static const organizations = '/organizations';
  static const joinOrganization = '/organizations/join';

  // ---- Otros módulos ----
  static const cabins = '/cabins';
  static const reservations = '/reservations';
  static const customers = '/customers';
}