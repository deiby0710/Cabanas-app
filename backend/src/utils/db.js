import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

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