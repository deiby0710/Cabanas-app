import { crearReserva } from "../services/reserva.service.js";
import { convertirFechaUTC } from "../utils/fecha.js";

export async function postReserva(req, res) {
    const {
        cabanaId,
        clienteId,
        fechaInicio,
        fechaFin,
        abono,
        numPersonas,
        estado
    } = req.body

    const adminId = req.admin.id // Viene con el token

    if(!cabanaId||!clienteId||!fechaInicio||!abono||!numPersonas) {
        return res.status(400).json({ error: 'Faltan campos obligatorios.'})
    }

    // Validar que la fecha no este en el pasado
    const hoy = new Date();
    const inicio = convertirFechaUTC(fechaInicio)
    const fin = fechaFin? convertirFechaUTC(fechaFin): inicio
    hoy.setUTCHours(0, 0, 0, 0)

    if(inicio < hoy){
        return res.status(400).json({ error: 'No puedes reservar en fechas pasadas.' })
    }

    if (fin < inicio) {
        return res.status(400).json({ error: 'La fecha de fin debe ser posterior a la de inicio.' })
    }

    try {
        const reserva = await crearReserva({
            cabanaId: Number(cabanaId),
            clienteId: Number(clienteId),
            fechaInicio: inicio,
            fechaFin: fin,
            abono: Number(abono),
            numPersonas: Number(numPersonas),
            estado: estado || 'reservada',
            adminId
        })

        res.status(201).json({
            message: 'Reserva creada exitosamente.',
            reserva
        })
    } catch (error) {
        if (error.message === 'RESERVA_SUPERPUESTA') {
            return res.status(400).json({ error: 'Ya existe una reserva para esta cabaña en la fecha seleccionada.'})
        }
        console.error(error)
        res.status(500).json({ error: 'Error al crear la reserva.'})
    }
}