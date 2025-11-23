import { PrismaClient } from "@prisma/client";
import {
  listReservationsService
} from "../services/reserva.service.js";

const prisma = new PrismaClient();

// =====================
//  UTILIDADES
// =====================

// Normaliza nombres de fechas desde la IA
function normalizeDates(params) {
  return {
    fechaInicio:
      params.fechaInicio ??
      params.startDate ??
      params.from ??
      null,

    fechaFin:
      params.fechaFin ??
      params.endDate ??
      params.to ??
      null,
  };
}

// ------------------------------------------
// Resolver cabaña por nombre (Búsqueda difusa)
// ------------------------------------------
async function resolveCabinId(cabinName, orgId) {
    if (!cabinName) return null;

    const name = cabinName.trim();

    // 1️⃣ Intentar coincidencia exacta
    let cabana = await prisma.cabana.findFirst({
        where: {
        organizacionId: orgId,
        nombre: { equals: name, mode: "insensitive" }
        }
    });

    if (cabana) return cabana.id;

    // 2️⃣ Intentar coincidencia parcial (contains)
    cabana = await prisma.cabana.findFirst({
        where: {
        organizacionId: orgId,
        nombre: { contains: name, mode: "insensitive" }
        }
    });

    if (cabana) return cabana.id;

    // 3️⃣ Intentar coincidencia al revés (cuando usuario escribe solo “Refugio”)
    cabana = await prisma.cabana.findFirst({
        where: {
        organizacionId: orgId,
        nombre: {
            contains: name.split(" ").slice(-1)[0], // última palabra
            mode: "insensitive"
        }
        }
    });

    if (cabana) return cabana.id;

    // 4️⃣ Como último intento, eliminar acentos y comparar
    const normalize = str =>
        str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");

    const normalizedName = normalize(name);

    const allCabins = await prisma.cabana.findMany({
        where: { organizacionId: orgId }
    });

    const match = allCabins.find(c =>
        normalize(c.nombre).toLowerCase().includes(normalizedName.toLowerCase())
    );

    return match ? match.id : null;
}


// =====================
//  INTENT ROUTER
// =====================

export async function routeIntent(intent, params) {
    const adminId = params.adminId;
    const orgId = params.orgId;

    // 1️⃣ Normalizar nombres de fechas que la IA ya devolvió como YYYY-MM-DD
    const { fechaInicio, fechaFin } = normalizeDates(params);

    // 2️⃣ Convertir directo a Date (ahora la IA ya manda fechas reales)
    const start = fechaInicio ? new Date(fechaInicio) : null;
    const end   = fechaFin ? new Date(fechaFin) : null;

    // ----------------------------------
    // Resolver ID de cabaña
    // ----------------------------------
    let cabanaId = params.cabanaId ?? null;

    if (!cabanaId && params.cabinName) {
    cabanaId = await resolveCabinId(params.cabinName, orgId);
    }

    if (params.cabinName && !cabanaId) {
        return {
            intent,
            error: "CABIN_NOT_FOUND",
            message: `No encontré la cabaña '${params.cabinName}' en esta organización.`,
            cabinName: params.cabinName
        };
    }

    // ===============================================
    // INTENT: Conversación normal (sin tocar BD)
    // ===============================================
    if (intent === "small_talk") {
        return {
            intent,
            message: "SMALL_TALK"
        };
    }
    // =============================
    // INTENT 1: Disponibilidad
    // =============================
    if (intent === "check_cabin_availability") {

        const reservas = await listReservationsService(adminId, orgId, {
            cabanaId,
            desde: start,
            hasta: end,
        });

        if (!reservas) {
            return {
                intent,
                error: "NO_PERMISSION_OR_INVALID_ORG",
                message: "No tienes acceso a esta organización o no perteneces a ella.",
                orgId,
                adminId
            };
        }

        const disponible = reservas.length === 0;

        return {
            intent,
            disponible,
            reservas,
            cabanaId,
            fechaInicio: start,
            fechaFin: end,
        };
    }

    // =============================
    // INTENT 2: Listar reservas
    // =============================
    if (intent === "list_reservations_by_range") {

        const reservas = await listReservationsService(adminId, orgId, {
            desde: start,
            hasta: end,
        });

        if (!reservas) {
            return {
                intent,
                error: "NO_PERMISSION_OR_INVALID_ORG",
                message: "No tienes acceso a esta organización.",
                orgId,
                adminId
            };
        }

        return {
            intent,
            reservas,
            fechaInicio: start,
            fechaFin: end,
        };
    }

    // =========================================
    // INTENT 3: Quién ocupa X cabaña en fecha Y
    // =========================================
    if (intent === "who_has_cabin_on_date") {
        const fechaTexto =
        params.fecha ??
        params.date ??
        fechaInicio ??
        null;

        const fechaReal = fechaTexto ? new Date(fechaTexto) : null;

        if (!fechaReal) {
            return {
                intent,
                error: "INVALID_DATE",
                message: `No pude interpretar la fecha '${fechaTexto}'.`
            };
        }

        const reservas = await listReservationsService(adminId, orgId, {
            cabanaId,
            desde: fechaReal,
            hasta: fechaReal,
        });

        if (!reservas) {
            return {
                intent,
                error: "NO_PERMISSION_OR_INVALID_ORG",
                message: "No tienes acceso a esta organización.",
            };
        }

        const occupant = reservas.find(r =>
            fechaReal >= new Date(r.fechaInicio) &&
            fechaReal < new Date(r.fechaFin)
        );

        return {
            intent,
            ocupante: occupant ?? null,
            cabanaId,
            fecha: fechaReal
        };
    }

    // ==========================================================
    // INTENT 4: Qué cabañas están ocupadas entre fechas
    // ==========================================================
    if (intent === "occupied_cabins_between") {
        const reservas = await listReservationsService(adminId, orgId, {
            desde: start,
            hasta: end,
        });

        if (!reservas) {
            return {
                intent,
                error: "NO_PERMISSION_OR_INVALID_ORG",
                message: "No tienes acceso a esta organización.",
            };
        }

        const cabins = [
        ...new Set(reservas.map(r => r.cabana.nombre))
        ];

        return {
            intent,
            fechaInicio: start,
            fechaFin: end,
            cabins,
            reservas,
        };
    }

    // ==========================================================
    // INTENT 5: Listamos cabañas
    // ==========================================================
    if (intent === "list_cabins") {
        const cabanas = await prisma.cabana.findMany({
            where: { organizacionId: orgId },
            select: { id: true, nombre: true, capacidad: true }
        });

        return { intent, cabanas };
    }

    // =============================
    // INTENT 6: Listar clientes
    // =============================
    if (intent === "list_customers") {
        const clientes = await prisma.cliente.findMany({
            where: { organizacionId: orgId },
            select: {
            id: true,
            nombre: true,
            celular: true,
            }
        });

        return {
            intent,
            clientes
        };
    }

    // ================================================
    // INTENT 7: Listar reservas por nombre de cliente
    // ================================================
    if (intent === "list_reservations_by_customer") {
        // El modelo envía el nombre del cliente en params.customerName
        const customerName = params.customerName ?? params.clienteName;

        if (!customerName) {
            return {
                intent,
                error: "MISSING_CUSTOMER_NAME",
                message: "Necesito el nombre del cliente para buscar sus reservas."
            };
        }

        // Buscar cliente por nombre (coincidencia parcial, ignore case)
        const cliente = await prisma.cliente.findFirst({
            where: {
                organizacionId: orgId,
                nombre: { contains: customerName, mode: "insensitive" }
            }
        });

        if (!cliente) {
            return {
                intent,
                error: "CUSTOMER_NOT_FOUND",
                message: `No encontré un cliente llamado '${customerName}' en esta organización.`,
                customerName
            };
        }

        // Listar reservas del cliente encontrado
        const reservas = await prisma.reserva.findMany({
            where: {
                organizacionId: orgId,
                clienteId: cliente.id
            },
            include: {
                cabana: { select: { id: true, nombre: true } }
            }
        });

        return {
            intent,
            cliente: {
                id: cliente.id,
                nombre: cliente.nombre,
                celular: cliente.celular,
            },
            reservas
        };
    }

    // ===============================================
    // INTENT 8: Obtener cliente por nombre
    // ===============================================
    if (intent === "get_customer_by_name") {
        const customerName =
            params.customerName ??
            params.clienteName ??
            params.name ??
            null;

        if (!customerName) {
            return {
                intent,
                error: "MISSING_CUSTOMER_NAME",
                message: "Necesito el nombre del cliente para buscarlo."
            };
        }

        // Buscar cliente por coincidencia parcial, ignore case
        const cliente = await prisma.cliente.findFirst({
            where: {
                organizacionId: orgId,
                nombre: { contains: customerName, mode: "insensitive" }
            }
        });

        if (!cliente) {
            return {
                intent,
                error: "CUSTOMER_NOT_FOUND",
                message: `No encontré ningún cliente llamado '${customerName}'.`,
                customerName
            };
        }

        return {
                intent,
                cliente: {
                id: cliente.id,
                nombre: cliente.nombre,
                celular: cliente.celular,
            }
        };
    }

    // ===============================================
    // INTENT 9: Obtener información de una cabaña
    // ===============================================
    if (intent === "get_cabin_info") {

        const cabinName =
            params.cabinName ??
            params.cabanaName ??
            params.name ??
            null;

        if (!cabinName) {
            return {
                intent,
                error: "MISSING_CABIN_NAME",
                message: "Necesito el nombre de la cabaña para buscarla."
            };
        }

        // Buscar cabaña por coincidencia parcial (insensible a mayúsculas)
        const cabana = await prisma.cabana.findFirst({
            where: {
                organizacionId: orgId,
                nombre: { contains: cabinName, mode: "insensitive" }
            }
        });

        if (!cabana) {
            return {
                intent,
                error: "CABIN_NOT_FOUND",
                message: `No encontré la cabaña '${cabinName}' en esta organización.`,
                cabinName
            };
        }

        return {
                intent,
                cabana: {
                id: cabana.id,
                nombre: cabana.nombre,
                capacidad: cabana.capacidad,
                organizacionId: cabana.organizacionId
            }
        };
    }

    // =======================================================
    // INTENT 10: Listar reservas por nombre de cabaña
    // =======================================================
    if (intent === "list_reservations_by_cabin") {

        const cabinName =
            params.cabinName ??
            params.cabanaName ??
            params.name ??
            null;

        if (!cabinName) {
            return {
                intent,
                error: "MISSING_CABIN_NAME",
                message: "Necesito el nombre de la cabaña para buscar sus reservas."
            };
        }

        // Resolver cabaña por nombre (insensible a mayúsculas)
        const cabana = await prisma.cabana.findFirst({
            where: {
                organizacionId: orgId,
                nombre: { contains: cabinName, mode: "insensitive" }
            }
        });

        if (!cabana) {
            return {
                intent,
                error: "CABIN_NOT_FOUND",
                message: `No encontré la cabaña '${cabinName}' en esta organización.`,
                cabinName
            };
        }

        // Buscar reservas de esa cabaña
        const reservas = await prisma.reserva.findMany({
            where: {
                organizacionId: orgId,
                cabanaId: cabana.id
            },
            include: {
                cliente: { select: { id: true, nombre: true, celular: true } }
            }
        });

        return {
            intent,
            cabana: {
                id: cabana.id,
                nombre: cabana.nombre
            },
            reservas
        };
    }

    // =======================================================
    // INTENT 11: Contar reservas en un rango
    // =======================================================
    if (intent === "count_reservations") {

        // El modelo debe enviar fechas naturales:
        // startDate, endDate o expresiones tipo "este mes", "hoy"
        const { fechaInicio, fechaFin } = normalizeDates(params);

        const start = fechaInicio ? new Date(fechaInicio) : null;
        const end   = fechaFin ? new Date(fechaFin) : null;

        if (!start || !end || isNaN(start) || isNaN(end)) {
            return {
                intent,
                error: "INVALID_DATE",
                message: "Las fechas enviadas no son válidas.",
                fechaInicio,
                fechaFin
            };
        }

        // Contar reservas en ese rango
        const total = await prisma.reserva.count({
            where: {
                organizacionId: orgId,
                fechaInicio: { gte: start },
                fechaFin:    { lte: end }
            }
        });

        return {
            intent,
            total,
            fechaInicio: start,
            fechaFin: end
        };
    }

    // =============================
    // INTENT DESCONOCIDO
    // =============================
    return {
        error: "Intent no reconocido",
        intent,
        params,
    };
}