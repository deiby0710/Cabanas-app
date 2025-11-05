import { PrismaClient, EstadoReserva } from "@prisma/client";
import { convertirFechaUTC } from "../utils/fecha.js";
import { 
    findAdminOrganizationRelation,
    findCabinInOrganization,
    findCustomerInOrganization
 } from "../utils/db.js";

const prisma = new PrismaClient();

export async function createReservationService(adminId, data) {
    // Verificar que el admin pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, data.organizacionId);
    if (!relation) return null;

    // Verificar que la cabaña pertenece a la misma organización
    const cabana = await findCabinInOrganization(data.cabanaId, data.organizacionId);
    if (!cabana) return null;

    // Verificar que el cliente pertenece a la misma organización
    const cliente = await findCustomerInOrganization(data.clienteId, data.organizacionId);
    if (!cliente) return null;

    // Crear reserva
    const reservation = await prisma.reserva.create({
        data: {
            cabanaId: data.cabanaId,
            clienteId: data.clienteId,
            adminId: adminId,
            organizacionId: data.organizacionId,
            estado: EstadoReserva.PENDIENTE,
            fechaInicio: data.fechaInicio,
            fechaFin: data.fechaFin,
            abono: data.abono,
            numPersonas: data.numPersonas,
        },
        include: {
            cliente: true,
            cabana: true,
        },
    });

    return reservation;
}


export async function listReservationsService(adminId, orgId, filters = {}) {
    // Validar que el usuario pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null;

    // Construir dinámicamente el objeto `where`
    // Operador Spread (...): Si la condicion es True agrega ese campo al where, sino no agrega nada {}
    const where = {
        organizacionId: orgId,
        ...(filters.estado ? { estado: filters.estado } : {}),
        ...(filters.cabanaId ? { cabanaId: filters.cabanaId } : {}),
        ...(filters.clienteId ? { clienteId: filters.clienteId } : {}),
        ...(filters.desde && filters.hasta
        ? { fechaInicio: { gte: filters.desde, lte: filters.hasta } }
        : filters.desde
        ? { fechaInicio: { gte: filters.desde } }
        : filters.hasta
        ? { fechaInicio: { lte: filters.hasta } }
        : {}),
    };

    // Obtener las reservas aplicando los filtros
    const reservations = await prisma.reserva.findMany({
        where,
            orderBy: { fechaInicio: 'desc' },
        include: {
            cabana: { select: { id: true, nombre: true, capacidad: true} },
            cliente: { select: { id: true, nombre: true, celular: true } },
            adminOrg: {
                select: {
                admin: { select: { id: true, nombre: true, email: true } },
                },
            },
        },
    });

    // Formatear salida
    return reservations.map(r => ({
        id: r.id,
        estado: r.estado,
        fechaInicio: r.fechaInicio,
        fechaFin: r.fechaFin,
        abono: r.abono,
        numPersonas: r.numPersonas,
        cabana: r.cabana,
        cliente: r.cliente,
        creadoPor: r.adminOrg?.admin || null,
    }));
}

export async function getReservationByIdService(adminId, orgId, reservaId) {
    // Validar pertenencia a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null;

    // Traer la reserva garantizando aislamiento por org
    const r = await prisma.reserva.findFirst({
        where: { id: reservaId, organizacionId: orgId },
        include: {
            cabana: { select: { id: true, nombre: true, capacidad: true } },
            cliente: { select: { id: true, nombre: true, celular: true } },
            adminOrg: { select: { admin: { select: { id: true, nombre: true, email: true } } } },
        },
    });

    if (!r) return null;

    // Formato de salida limpio
    return {
        id: r.id,
        estado: r.estado,
        fechaInicio: r.fechaInicio,
        fechaFin: r.fechaFin,
        abono: r.abono,
        numPersonas: r.numPersonas,
        createdAt: r.createdAt ?? r.created_at ?? r.createdAt, // por si tu campo es createdAt
        updatedAt: r.updateAt,                                  // tu schema lo llama updateAt
        cabana: r.cabana,
        cliente: r.cliente,
        creadoPor: r.adminOrg?.admin || null,
    };
}


// (Opcional) valida traslape con otras reservas activas de la misma cabaña
async function hasDateOverlap(orgId, cabanaId, reservaIdToExclude, fechaInicio, fechaFin) {
    if (!fechaInicio || !fechaFin) return false;

    const count = await prisma.reserva.count({
        where: {
            organizacionId: orgId,
            cabanaId,
            id: { not: reservaIdToExclude },
            estado: { in: ['PENDIENTE', 'CONFIRMADA'] },
            // traslape: (startA < endB) && (endA > startB)
            AND: [
                { fechaInicio: { lt: fechaFin } },
                { fechaFin: { gt: fechaInicio } },
            ],
        },
    });
    return count > 0;
}

export async function updateReservationService(adminId, orgId, reservaId, data) {
    // Permisos
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation || relation.rol !== 'ADMIN') return 'NO_PERMISSION';

    // Traer la reserva dentro de la org
    const current = await prisma.reserva.findFirst({
        where: { id: reservaId, organizacionId: orgId },
    });
    if (!current) return 'NOT_FOUND';

    // Si cambian cabana/cliente, validar pertenencia a la org
    if (data.cabanaId && data.cabanaId !== current.cabanaId) {
        const cabana = await findCabinInOrganization(data.cabanaId, orgId);
        if (!cabana) return 'INVALID_CABIN';
    }
    if (data.clienteId && data.clienteId !== current.clienteId) {
        const cliente = await findCustomerInOrganization(data.clienteId, orgId);
        if (!cliente) return 'INVALID_CUSTOMER';
    }

    // 4) Validación de traslape (si cambian fechas o cabaña)
    const nextCabanaId = data.cabanaId ?? current.cabanaId;
    const nextInicio   = data.fechaInicio ?? current.fechaInicio;
    const nextFin      = data.fechaFin ?? current.fechaFin;

    const overlap = await hasDateOverlap(orgId, nextCabanaId, current.id, nextInicio, nextFin);
    if (overlap) return 'DATE_OVERLAP';

    // Ejecutar update (solo aplica los campos definidos)
    const updateData = {
        ...(data.estado !== undefined ? { estado: data.estado } : {}),
        ...(data.fechaInicio !== undefined ? { fechaInicio: data.fechaInicio } : {}),
        ...(data.fechaFin !== undefined ? { fechaFin: data.fechaFin } : {}),
        ...(data.abono !== undefined ? { abono: data.abono } : {}),
        ...(data.numPersonas !== undefined ? { numPersonas: data.numPersonas } : {}),
        ...(data.cabanaId !== undefined ? { cabanaId: data.cabanaId } : {}),
        ...(data.clienteId !== undefined ? { clienteId: data.clienteId } : {}),
    };

    const updated = await prisma.reserva.update({
        where: { id: current.id },
        data: updateData,
        include: {
            cabana: { select: { id: true, nombre: true } },
            cliente:{ select: { id: true, nombre: true, celular: true } },
            adminOrg: { select: { admin: { select: { id: true, nombre: true, email: true } } } },
        },
    });

    return {
        id: updated.id,
        estado: updated.estado,
        fechaInicio: updated.fechaInicio,
        fechaFin: updated.fechaFin,
        abono: updated.abono,
        numPersonas: updated.numPersonas,
        cabana: updated.cabana,
        cliente: updated.cliente,
        creadoPor: updated.adminOrg?.admin || null,
        organizacionId: orgId,
    };
}

export async function deleteReservationService(adminId, orgId, reservaId) {
    // Verificar que el usuario pertenece a la organización y tiene rol ADMIN
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation || relation.rol !== 'ADMIN') return 'NO_PERMISSION';

    // Verificar que la reserva pertenece a la organización
    const reserva = await prisma.reserva.findFirst({
        where: { id: reservaId, organizacionId: orgId },
    });
    if (!reserva) return 'NOT_FOUND';

    // Bloquear eliminación si está completada
    if (reserva.estado === 'COMPLETADA') {
        return 'COMPLETED_BLOCKED';
    }

    // Eliminar la reserva
    await prisma.reserva.delete({
        where: { id: reserva.id },
    });

    return true;
}