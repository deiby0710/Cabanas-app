export function convertirFechaUTC(fechaString) {
  const [year, month, day] = fechaString.split('-')
  return new Date(Date.UTC(year, month - 1, day))
}