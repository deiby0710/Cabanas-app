class ApiConstants {
  static const baseUrl = 'http://localhost:3000'; // reemplaza con tu dominio o localhost

  // ---- Auth ----
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/getMe';

  // ---- Organizations ----
  static const createOrganization = '/organization/create';
  static const joinOrganization = '/organization/join';
  static const myOrganizations = '/organization/my';
  static const organizationById = '/organization';

  // ---- Otros módulos ----
  static const cabins = '/cabins';
  static const reservations = '/reservations';
  static const customers = '/customers';
}