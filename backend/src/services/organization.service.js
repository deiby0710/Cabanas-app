import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function createOrganizationService({nombre, adminId}){
    // Generamos codigo de invitacion
    const codigoInvitacion = Math.random().toString(36).substring(2, 8).toUpperCase();

    // Crear organizacion
    const organizacion = await prisma.organizacion.create({
        data: {
            nombre,
            codigoInvitacion,
        },
    });

    // Crear relacion en AdministradorOrgaizacion
    const relacion = await prisma.administradorOrganizacion.create({
        data: {
            adminId,
            organizacionId: organizacion.id,
            rol: 'ADMIN',
        },
    });
    
    return {
        organizacion,
        rol: relacion.rol
    }
}

export async function joinOrganizationService({ codigoInvitacion, adminId}) {
    // Busca la organizacion
    const organizacion = await prisma.organizacion.findUnique({
        where: { codigoInvitacion },
    })

    if(!organizacion) throw new Error('ORG_NO_ENCONTRADA');

    // Verificamos si ya pertenece
    const existingRelation = await prisma.administradorOrganizacion.findFirst({
        where: {
            adminId,
            organizacionId: organizacion.id,
        },
    });

    if(existingRelation) throw new Error('YA_ES_MIEMBRO');

    //Crear relacion como miembro
    const relacion = await prisma.administradorOrganizacion.create({
        data: {
            adminId,
            organizacionId: organizacion.id,
            rol: 'MEMBER',
        },
    });

    return {
        organizacion,
        rol: relacion.rol,
    }
}