import { 
    createReservationService,
    listReservationsService,
    getReservationByIdService,
    updateReservationService,
    deleteReservationService
    } from "../services/reserva.service.js";
import { convertirFechaUTC } from "../utils/fecha.js";

export async function createReservation(req, res) {
    try {
        const adminId = req.admin.id;
        const {
            organizacionId,
            cabanaId,
            clienteId,
            fechaInicio,
            fechaFin,
            abono,
            numPersonas
        } = req.body;

        if (!organizacionId || !cabanaId || !clienteId || !fechaInicio || !fechaFin) {
            return res.status(400).json({ error: 'Faltan campos obligatorios.' });
        }

        if (new Date(fechaInicio) >= new Date(fechaFin)) {
            return res.status(400).json({ error: 'La fecha de inicio debe ser menor que la fecha de fin.' });
        }

        const reservation = await createReservationService(adminId, {
            organizacionId,
            cabanaId,
            clienteId,
            fechaInicio: new Date(fechaInicio),
            fechaFin: new Date(fechaFin),
            abono: abono || 0,
            numPersonas: numPersonas || 1
        });

        if (!reservation) {
            return res.status(403).json({ error: 'No tienes permisos o los datos son inválidos.' });
        }

        res.status(201).json({
            message: 'Reserva creada correctamente.',
            reservation,
        });
    } catch (error) {
        console.error('Error al crear reserva:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function listReservations(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);

        // Query params opcionales
        const { estado, cabanaId, clienteId, desde, hasta } = req.query;

        const filters = {
            estado: estado || null,
            cabanaId: cabanaId ? parseInt(cabanaId) : null,
            clienteId: clienteId ? parseInt(clienteId) : null,
            desde: desde ? new Date(desde) : null,
            hasta: hasta ? new Date(hasta) : null,
        };

        const reservations = await listReservationsService(adminId, orgId, filters);

        if (!reservations) {
            return res.status(403).json({ error: 'No tienes acceso a esta organización.' });
        }

        res.status(200).json({
            message: 'Reservas obtenidas correctamente.',
            filters: filters,
            reservations,
        });
    } catch (error) {
        console.error('Error al listar reservas:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function getReservationById(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const reservaId = parseInt(req.params.reservaId);

        const reservation = await getReservationByIdService(adminId, orgId, reservaId);

        if (!reservation) {
            return res.status(403).json({ error: 'No tienes acceso o la reserva no existe.' });
        }

        res.status(200).json({
            message: 'Reserva obtenida correctamente.',
            reservation,
        });
    } catch (error) {
        console.error('Error al obtener reserva:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}


export async function updateReservation(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const reservaId = parseInt(req.params.reservaId);

        // Campos opcionales
        const {
        estado,           // 'PENDIENTE' | 'CONFIRMADA' | 'CANCELADA' | 'COMPLETADA'
        fechaInicio,
        fechaFin,
        abono,
        numPersonas,
        cabanaId,
        clienteId,
        } = req.body;

        // Validación simple de fechas si vienen ambas
        if (fechaInicio && fechaFin && new Date(fechaInicio) >= new Date(fechaFin)) {
        return res.status(400).json({ error: 'La fecha de inicio debe ser menor que la fecha de fin.' });
        }

        const updated = await updateReservationService(adminId, orgId, reservaId, {
            estado,
            fechaInicio: fechaInicio ? new Date(fechaInicio) : undefined,
            fechaFin:    fechaFin ? new Date(fechaFin) : undefined,
            abono,
            numPersonas,
            cabanaId,
            clienteId,
        });

        if (updated === 'NO_PERMISSION') {
            return res.status(403).json({ error: 'No tienes permisos para modificar reservas en esta organización.' });
        }
        if (updated === 'NOT_FOUND') {
            return res.status(404).json({ error: 'La reserva no existe en esta organización.' });
        }
        if (updated === 'INVALID_CABIN') {
            return res.status(400).json({ error: 'La cabaña no pertenece a la organización.' });
        }
        if (updated === 'INVALID_CUSTOMER') {
            return res.status(400).json({ error: 'El cliente no pertenece a la organización.' });
        }
        if (updated === 'DATE_OVERLAP') {
            return res.status(409).json({ error: 'La cabaña ya tiene una reserva en ese rango de fechas.' });
        }

        res.status(200).json({
            message: 'Reserva actualizada correctamente.',
            reservation: updated,
        });
    } catch (error) {
        console.error('Error al actualizar reserva:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function deleteReservation(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const reservaId = parseInt(req.params.reservaId);

        const result = await deleteReservationService(adminId, orgId, reservaId);

        if (result === 'NO_PERMISSION') {
            return res.status(403).json({ error: 'No tienes permisos para eliminar reservas.' });
        }
        if (result === 'NOT_FOUND') {
           return res.status(404).json({ error: 'La reserva no existe o no pertenece a esta organización.' });
        }
        if (result === 'COMPLETED_BLOCKED') {
            return res.status(400).json({ error: 'No se puede eliminar una reserva completada.' });
        }

        res.status(200).json({ message: 'Reserva eliminada correctamente.' });
    } catch (error) {
        console.error('Error al eliminar reserva:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}