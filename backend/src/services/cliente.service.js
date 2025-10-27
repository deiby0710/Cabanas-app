import { PrismaClient } from "@prisma/client";
import { findAdminOrganizationRelation } from "../utils/db.js";

const prisma = new PrismaClient();

export async function createCustomerService(adminId, orgId, data) {
    // Verificar si pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null;

    // Crear cliente dentro de la organización
    const customer = await prisma.cliente.create({
        data: {
        nombre: data.nombre,
        celular: data.celular,
        organizacionId: orgId,
        },
    });

    return customer;
}

export async function listCustomersService(adminId, orgId) {
  // Validar que el admin pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null; // ❌ no pertenece

    // Obtener todos los clientes de esa organización
    const customers = await prisma.cliente.findMany({
        where: { organizacionId: orgId },
        orderBy: { fechaRegistro: 'desc' },
    });

    return customers;
}

export async function getCustomerByIdService(adminId, orgId, clienteId) {
    // Validar que el usuario pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null;

    // Buscar cliente dentro de esa organización
    const customer = await prisma.cliente.findUnique({
        where: {
            id_organizacionId: {
                id: clienteId,
                organizacionId: orgId,
            },
        },
        include: {
            reservas: {
                select: {
                    id: true,
                    estado: true,
                    fechaInicio: true,
                    fechaFin: true,
                    abono: true,
                    numPersonas: true,
                },
            },
        },
    });

    return customer;
}


export async function updateCustomerService(adminId, orgId, clienteId, data) {
    // Validar acceso a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation) return null;

    // Verificar que el cliente existe en la organización
    const existingCustomer = await prisma.cliente.findUnique({
        where: {
            id_organizacionId: {
                id: clienteId,
                organizacionId: orgId,
            },
        },
    });

    if (!existingCustomer) return null;

    // Actualizar cliente
    const updated = await prisma.cliente.update({
        where: {
            id_organizacionId: {
                id: clienteId,
                organizacionId: orgId,
            },
        },
        data,
    });

    return updated;
}

export async function deleteCustomerService(adminId, orgId, clienteId) {
    // Validar si pertenece y tiene rol ADMIN
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    if (!relation || relation.rol !== 'ADMIN') return null;

    // Verificar si el cliente existe dentro de la organización
    const customer = await prisma.cliente.findUnique({
        where: {
            id_organizacionId: {
                id: clienteId,
                organizacionId: orgId,
            },
        },
    });

    if (!customer) return null;

    // (Opcional) Verificar si tiene reservas activas
    const reservasActivas = await prisma.reserva.count({
        where: {
            clienteId,
            organizacionId: orgId,
            estado: { in: ['PENDIENTE', 'CONFIRMADA'] },
        },
    });

    if (reservasActivas > 0) {
        return 'RESERVAS_ACTIVAS';
    }

    // Eliminar cliente
    await prisma.cliente.delete({
        where: {
            id_organizacionId: {
                id: clienteId,
                organizacionId: orgId,
            },
        },
    });

    return true;
}