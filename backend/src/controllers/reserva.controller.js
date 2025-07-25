import { crearReserva,
        observarReservas, 
        obtenerReservaPorId, 
        actualizarReserva,
        eliminarReserva
    } from "../services/reserva.service.js";
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

export async function getReservas(req, res){
    try {
        const reservas = await observarReservas()
        res.json(reservas)
    } catch (error) {
        console.error('Error al obtener las reservas: ', error)
        res.status(500).json({ error: 'Error al obtener las reservas.'})
    }
}

export async function getReservasById(req, res){
    const { id } = req.params

    try {
        const reserva = await obtenerReservaPorId(Number(id));
        res.json(reserva)
    } catch (error) {
        if (error.message === 'RESERVA_NO_ENCONTRADA'){
            return res.status(404).json({ error: 'Reserva no encontrada.'})
        }
        console.error('Error al obtener la reserva: ', error)
        res.status(500).json({ error: 'Error al obtener la reserva.'})
    }
}

export async function putReserva(req, res){
    const { id } = req.params;
    const {
        cabanaId,
        clienteId,
        fechaInicio,
        fechaFin,
        abono,
        numPersonas,
        estado
    } = req.body
    const adminId = req.admin.id

    if (!cabanaId || !clienteId || !fechaInicio || !abono || !numPersonas) {
        return res.status(400).json({ error: 'Faltan campos obligatorios.' })
    }
    try {
        const reserva = await actualizarReserva(Number(id), {
            cabanaId: Number(cabanaId),
            clienteId: Number(clienteId),
            fechaInicio,
            fechaFin,
            abono: Number(abono),
            numPersonas: Number(numPersonas),
            estado: estado || 'reservada',
            adminId
        })
        res.json({
            message: 'Reserva actualizada exitosamente.',
            reserva
        })
    } catch (error) {
        if(error.message === 'RESERVA_SUPERPUESTA') {
            return res.status(400).json({ error: 'Las fechas se superponen con otra reserva.'})
        }
        console.error(error)
        res.status(500).json({ error: 'Error al actualizar la reserva.' })
    }
}

export async function deleteReserva(req, res) {
    const { id } = req.params

    try {
        const reservaEliminada = await eliminarReserva(Number(id))
        res.json({
            message: 'Reserva eliminada exitosamente.',
            reserva: reservaEliminada
        })
    } catch (error) {
        if(error.message === 'RESERVA_NO_ENCONTRADA'){
            return res.status(404).json({ error: 'La reserva no existe.' })
        }
        console.error(error)
        res.status(500).json({error: 'Error al eliminar la reserva.'})
    }
}