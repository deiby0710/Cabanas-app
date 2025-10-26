import { 
    createOrganizationService,
    joinOrganizationService
} from "../services/organization.service.js";

export async function createOrganization(req, res) {
    const {nombre} = req.body;
    const adminId = req.admin?.id; // Viene del token (verifyToken)

    if(!nombre){
        return res.status(400).json({ error: 'El nombre de la organización es obligatorio.'})
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

    console.log("Codigo invitacion: ", codigoInvitacion);
    console.log("AdminID: ",adminId);
    
    if(!codigoInvitacion){
        return res.status(400).json({ error: 'El código de invitación es obligatorio.' });
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