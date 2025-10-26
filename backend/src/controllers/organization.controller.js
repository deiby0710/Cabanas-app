import { 
    createOrganizationService,
    joinOrganizationService,
    listOrganizationsByAdmin,
    getOrganizationDetails,
    updateOrganizationNameService,
    deleteOrganizationService,
    updateMemberRoleService,
    listMembersService,
    removeMemberService
} from "../services/organization.service.js";

export async function createOrganization(req, res) {
    const {nombre} = req.body;
    const adminId = req.admin?.id; // Viene del token (verifyToken)

    if(!nombre){
        return res.status(400).json({ error: 'El nombre de la organización es obligatorio.'})
    }

    if(!adminId){
        return res.status(400).json({error: "El id del administrador es obligatorio."})
    }

    try {
        const result = await createOrganizationService({nombre, adminId});

        res.status(201).json({
            message: 'Organización creada exitosamente.',
            organizacion: result.organizacion,
            rol: result.rol,
        })
    } catch (error) {
        console.error('Error al crear la organización:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function joinOrganization(req, res) {
    const { codigoInvitacion } = req.body;
    const adminId = req.admin?.id;
    
    if(!codigoInvitacion){
        return res.status(400).json({ error: 'El código de invitación es obligatorio.' });
    }

    if(!adminId){
        return res.status(400).json({error: "El id del administrador es obligatorio."})
    }

    try {
        const result = await joinOrganizationService({ codigoInvitacion, adminId });

        res.status(200).json({
            message: 'Te has unido a la organización exitosamente.',
            organizacion: result.organizacion,
            rol: result.rol,
        });
    } catch (error) {
        console.log('Error al unirse a la organización:', error);
        if (error.message === 'ORG_NO_ENCONTRADA') {
            return res.status(404).json({ error: 'Código de invitación inválido.' });
        }
        if (error.message === 'YA_ES_MIEMBRO') {
            return res.status(400).json({ error: 'Ya perteneces a esta organización.' });
        }
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function listMyOrganizations(req, res){
    try {
        const adminId = req.admin.id;

        if(!adminId){
            return res.status(400).json({error: "El id del administrador es obligatorio."})
        }

        const organizacions = await listOrganizationsByAdmin({ adminId })
    
        res.status(200).json({
            message: "Organizaciones obtenidas correctamente.",
            organizacions
        });
    } catch (error) {
        console.error('Error al listar organizaciones:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function getOrganizationById(req, res){
    try {
        const admin = req.admin.id;
        const orgId = parseInt(req.params.id); // Parametro que pasamos mediante el endpoint

        const organization = await getOrganizationDetails(admin, orgId);

        if(!organization){
            return res.status(400).json({ error: "Organizacion no encontrada o sin permisos."})
        }

        if(!orgId){
            return res.status(400).json({error: "El id de la organizacion es obligatorio."})
        }

        if(!admin){
            return res.status(400).json({error: "El id del administrador es obligatorio."})
        }

        res.status(200).json({
            message: "Organizacion obtenida correctamente",
            organization,
        });
    } catch (error) {
        console.error("Error al obtener organización:", error);
        res.status(500).json({ error: "Error en el servidor."});
    }
}

export async function updateOrganizationName(req, res){
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.id);
        const { nombre } = req.body;

        if(!nombre || nombre.trim() === ''){
            return res.status(400).json({error: "El nombre es obligatorio."})
        }

        if(!adminId){
            return res.status(400).json({error: "El id del administrador es obligatorio."})
        }

        if(!orgId){
            return res.status(400).json({error: "El id de la organizacion es obligatorio."})
        }

        const result = await updateOrganizationNameService(adminId, orgId, nombre.trim());
        res.status(200).json({
            message: "La organizacion fue actualizada correctamente.",
            result
        });
    } catch (error) {
        if(error.message === "NO_RELACION"){
            return res.status(404).json({error: "El admin no esta relacionada con la organizacion."})
        }
        if(error.message === "NO_AUTORIZADO"){
            return res.status(401).json({error: "El usuario no esta autorizado."})
        }
        console.error("Error en el servidor: ", error)
        res.status(500).json({ error: "Error en el servidor." })
    }
}

export async function deleteOrganization(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.id);

        if(!adminId){
            return res.status(400).json({error: "El id del administrador es obligatorio."})
        }

        if(!orgId){
            return res.status(400).json({error: "El id de la organizacion es obligatorio."})
        }

        await deleteOrganizationService({adminId, orgId})

        res.status(200).json({
            message: "Organizacion eliminada correctamente."
        });
    } catch (error) {
        if(error.message === "NO_EXISTE"){
            return res.status(404).json({error: "El admin no esta relacionada con la organizacion."});
        }
        if(error.message === "NO_AUTORIZADO"){
            return res.status(401).json({error: "El usuario no esta autorizado."});
        }
        console.error("Error en el servidor: ", error)
        res.status(500).json({ error: "Error en el servidor." })
    }
}

export async function updateMemberRole(req, res) {
    try {
        const requesterId = req.admin.id; // el admin que hace la solicitud
        const orgId = parseInt(req.params.id);
        const targetAdminId = parseInt(req.params.adminId)
        const { nuevoRol } = req.body;

        if (!nuevoRol || !['ADMIN', 'MEMBER'].includes(nuevoRol)) {
            return res.status(400).json({ error: 'Rol inválido. Debe ser ADMIN o MEMBER.' });
        }

        // Evitamos que un admin se degrade a sí mismo
        if (requesterId === targetAdminId && nuevoRol === 'MEMBER') {
            return res.status(400).json({ error: 'No puedes cambiar tu propio rol a MEMBER.' });
        }

        const updatedMember = await updateMemberRoleService(requesterId, orgId, targetAdminId, nuevoRol);

        if (!updatedMember) {
            return res.status(403).json({ error: 'No tienes permisos para cambiar roles en esta organización.' });
        }

        res.status(200).json({
            message: 'Rol actualizado correctamente.',
            member: updatedMember,
        });
    } catch (error) {
        console.error('Error al actualizar rol:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function listOrganizationMembers(req, res) {
    try {
        const adminId = req.admin.id; // quien hace la petición
        const orgId = parseInt(req.params.id);

        const members = await listMembersService(adminId, orgId);

        if (!members) {
            return res.status(403).json({
                error: 'No tienes acceso a esta organización o no existe.',
            });
        }

        res.status(200).json({
            message: 'Miembros obtenidos correctamente.',
            members,
        });
    } catch (error) {
        console.error('Error al listar miembros:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function removeMemberFromOrg(req, res) {
    try {
        const requesterId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const targetAdminId = parseInt(req.params.adminId);

        // Evitar que un admin se elimine a sí mismo
        if (requesterId === targetAdminId) {
            return res.status(400).json({ error: 'No puedes eliminarte a ti mismo de la organización.' });
        }

        const removed = await removeMemberService(requesterId, orgId, targetAdminId);

        if (!removed) {
            return res.status(403).json({ error: 'No tienes permisos o el miembro no pertenece a esta organización.' });
        }

        res.status(200).json({ message: 'Miembro eliminado correctamente.' });
    } catch (error) {
        console.error('Error al eliminar miembro:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}