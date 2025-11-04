import { PrismaClient } from "@prisma/client";
// import { findAdminOrganizationRelation } from "../utils/db.js"; Por ahora no

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

export async function listOrganizationsByAdmin({ adminId }){
    const relaciones = await prisma.administradorOrganizacion.findMany({
        where: { adminId },
        include: { organizacion: true},
    });

    const organizations = relaciones.map(r => ({
        id: r.organizacion.id,
        nombre: r.organizacion.nombre,
        codigoInvitacion: r.organizacion.codigoInvitacion,
        rol: r.rol,
        fechaUnion: r.fechaUnion,
    }));

    return organizations
}

export async function getOrganizationDetails(adminId, orgId){
    // Verificar si el admin pertenece a la organizacion
    const relacion = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId:{
                adminId,
                organizacionId: orgId,
            },
        },
        include: {
            organizacion: true,
        },
    });

    if (!relacion) return null; // No pertenece
    
    // Obetener algunos datos adicionales
    const cabanasCount = await prisma.cabana.count({where: {organizacionId: orgId}});
    const clientesCount = await prisma.cliente.count({where: {organizacionId: orgId}});
    const reservasCount = await prisma.reserva.count({where: {organizacionId: orgId}});

    return {
        id: relacion.organizacion.id,
        nombre: relacion.organizacion.nombre,
        codigoInvitacion: relacion.organizacion.codigoInvitacion,
        rol: relacion.rol,
        totales: {
            cabanas: cabanasCount,
            clientes: clientesCount,
            reservas: reservasCount,
        },
    };  
}

export async function updateOrganizationNameService( adminId, orgId, nombre ){
    const relacion = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId,
                organizacionId: orgId,
            },
        },
    });

    if(!relacion) throw new Error("NO_RELACION")

    if(relacion.rol !== "ADMIN") throw new Error("NO_AUTORIZADO")

    const update = await prisma.organizacion.update({
        where: {id: orgId},
        data: { nombre: nombre },
    });

    console.log("La respuestsa para actualizar: ", update);
    return update
}

export async function deleteOrganizationService({adminId, orgId}){
    const relacion = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId,
                organizacionId: orgId,
            },
        },
    });
    console.log("La respuesta es: ", relacion)

    if(!relacion) throw new Error("NO_EXISTE")

    if(relacion.rol !== "ADMIN") throw new Error("NO_AUTORIZADO")

    await prisma.organizacion.delete({
        where: {id: orgId},
    });

    return true
}


export async function updateMemberRoleService(requesterId, orgId, targetAdminId, nuevoRol) {
    // Verificar si quien solicita el cambio es ADMIN en la misma organización
    const requesterRelation = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId: requesterId,
                organizacionId: orgId,
            },
        },
    });

    if (!requesterRelation || requesterRelation.rol !== 'ADMIN') {
        return null; // ❌ no tiene permisos
    }

    // Verificar que el usuario destino pertenece a la misma organización
    const targetRelation = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId: targetAdminId,
                organizacionId: orgId,
            },
        },
    });

    if (!targetRelation) {
        return null; // ❌ no pertenece a la organización
    }

    // Actualizar el rol
    const updated = await prisma.administradorOrganizacion.update({
        where: {
            adminId_organizacionId: {
                adminId: targetAdminId,
                organizacionId: orgId,
            },
        },
        data: { rol: nuevoRol },
        include: { admin: true },
    });

    return {
        id: updated.admin.id,
        nombre: updated.admin.nombre,
        email: updated.admin.email,
        nuevoRol: updated.rol,
    };
}


export async function listMembersService(requesterId, orgId) {
    // Validar que el solicitante pertenece a la organización
    const requesterRelation = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId: requesterId,
                organizacionId: orgId,
            },
        },
    });

    if (!requesterRelation) return null; // ❌ No pertenece

    // Traer todos los miembros de la organización
    const members = await prisma.administradorOrganizacion.findMany({
        where: { organizacionId: orgId },
        include: {
            admin: {
                select: {
                    id: true,
                    nombre: true,
                    email: true,
                },
            },
        },
        orderBy: { fechaUnion: 'asc' },
    });

    // Mapeo de salida
    return members.map(m => ({
        id: m.admin.id,
        nombre: m.admin.nombre,
        email: m.admin.email,
        rol: m.rol,
        fechaUnion: m.fechaUnion,
    }));
}


export async function removeMemberService(requesterId, orgId, targetAdminId) {
    // Verificar que el solicitante es ADMIN en la organización
    const requesterRelation = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId: requesterId,
                organizacionId: orgId,
            },
        },
    });

    if (!requesterRelation || requesterRelation.rol !== 'ADMIN') {
        return null; // ❌ No tiene permisos
    }

    // Verificar que el usuario destino pertenece a la misma organización
    const targetRelation = await prisma.administradorOrganizacion.findUnique({
        where: {
            adminId_organizacionId: {
                adminId: targetAdminId,
                organizacionId: orgId,
            },
        },
    });

    if (!targetRelation) {
        return null; // ❌ No pertenece
    }

    // Evitar eliminar a otro ADMIN
    if (targetRelation.rol === 'ADMIN') {
        return null; // ❌ No se pueden eliminar administradores
    }

    // Eliminar la relación
    await prisma.administradorOrganizacion.delete({
        where: {
            adminId_organizacionId: {
                adminId: targetAdminId,
                organizacionId: orgId,
            },
        },
    });
 
    return true;
}