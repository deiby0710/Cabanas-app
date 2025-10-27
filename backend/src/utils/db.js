import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

// Verificar relación entre Admin y Organización
export async function findAdminOrganizationRelation(adminId, organizacionId) {
    return prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId,
                organizacionId,
            },
        },
    });
}

// Verificar si una cabaña pertenece a una organización
export async function findCabinInOrganization(cabanaId, organizacionId) {
    return prisma.cabana.findUnique({
        where: {
            id_organizacionId: {
                id: cabanaId,
                organizacionId,
            },
        },
    });
}

// Verificar si un cliente pertenece a una organización
export async function findCustomerInOrganization(clienteId, organizacionId) {
  return prisma.cliente.findUnique({
    where: {
        id_organizacionId: {
            id: clienteId,
            organizacionId,
        },
    },
  });
}