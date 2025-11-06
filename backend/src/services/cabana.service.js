import { PrismaClient } from "@prisma/client";
import { findAdminOrganizationRelation } from "../utils/db.js";

const prisma = new PrismaClient();

export async function createCabinService(adminId, orgId, nombre, capacidad) {
    const adminOrg = await findAdminOrganizationRelation(adminId, orgId)
    // if (!adminOrg || adminOrg.rol !== 'ADMIN') {
    if (!adminOrg) {
        return null; // ❌ No tiene permisos
    }
    return await prisma.cabana.create({ 
        data: {
            nombre,
            capacidad,
            organizacionId: orgId,
        },
     });
}

export async function listCabinsService(adminId, orgId) {
    // Verificar que el admin pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId)

    if (!relation) return null; // ❌ no pertenece

    // Traer todas las cabañas de esa organización
    const cabins = await prisma.cabana.findMany({
        where: { organizacionId: orgId },
        orderBy: { fechaCreacion: 'desc' },
    });

    return cabins;
}

export async function getCabinByIdService(adminId, orgId, cabanaId) {
    // Verificar que el admin pertenece a la organización (usando la función reutilizable)
    const relation = await findAdminOrganizationRelation(adminId, orgId);

    if (!relation) return null; // ❌ no pertenece

    // Buscar la cabaña dentro de esa organización
    const cabin = await prisma.cabana.findUnique({
        where: {
            id_organizacionId: {
                id: cabanaId,
                organizacionId: orgId,
            },
        },
        include: {
            reservas: true, // opcional: incluir reservas si deseas ver disponibilidad
        },
    });

  return cabin;
}

export async function updateCabinService(adminId, orgId, cabanaId, data) {
  // Verificar si el admin pertenece a la organización
  const relation = await findAdminOrganizationRelation(adminId, orgId);

  // Solo los administradores pueden editar
//   if (!relation || relation.rol !== 'ADMIN') {
  if (!relation) {
    return null;
  }

  // Verificar que la cabaña existe y pertenece a la organización
  const existingCabin = await prisma.cabana.findUnique({
    where: {
      id_organizacionId: {
        id: cabanaId,
        organizacionId: orgId,
      },
    },
  });

  if (!existingCabin) {
    return null; // ❌ no existe o pertenece a otra org
  }

  // Actualizar la cabaña
  const updated = await prisma.cabana.update({
    where: {
      id_organizacionId: {
        id: cabanaId,
        organizacionId: orgId,
      },
    },
    data,
  });

  return updated;
}

export async function deleteCabinService(adminId, orgId, cabanaId) {
    // Verificar que el admin pertenece a la organización
    const relation = await findAdminOrganizationRelation(adminId, orgId);
    // if (!relation || relation.rol !== 'ADMIN') {
    if (!relation) {
        return null; // ❌ No tiene permisos
    }

    // Verificar que la cabaña existe y pertenece a la organización
    const existingCabin = await prisma.cabana.findUnique({
        where: {
            id_organizacionId: {
                id: cabanaId,
                organizacionId: orgId,
            },
        },
    });

    if (!existingCabin) {
        return null; // ❌ No existe
    }

    // (Opcional) Verificar si tiene reservas activas
    const reservasActivas = await prisma.reserva.count({
        where: {
            cabanaId,
            organizacionId: orgId,
            estado: { in: ['PENDIENTE', 'CONFIRMADA'] },
        },
    });

    if (reservasActivas > 0) {
        throw new Error('La cabaña tiene reservas activas y no puede eliminarse.');
    }

    // Eliminar la cabaña
    await prisma.cabana.delete({
        where: {
            id_organizacionId: {
                id: cabanaId,
                organizacionId: orgId,
            },
        },
    });

    return true;
}