import express from 'express'
import { PrismaClient } from '@prisma/client'
import { verifyToken } from '../middlewares/verifyToken.js'

const router = express.Router()
const prisma = new PrismaClient()

// Read de cabanas: Traemos todas la cabanas
router.get('/', verifyToken, async (req, res) => {
    try {
        const reservas = await prisma.reserva.findMany({
            include: {
                cliente: true,
                cabana: true,
                administrador: true
            },
            orderBy: {
                fechaReserva: 'asc'
            }
        })
        res.json(reservas)
    } catch (error) {
        console.error('Error al obtener las reservas: ', error)
        res.status(500).json({ error: 'Error al obtener las reservas.'})
    }
})

// Post de cabanas
router.post('/', verifyToken, async (req, res) => {
    const {
        clienteId,
        cabanaId,
        fechaReserva,
        abono,
        numPersonas
    } = req.body
    // Validaciones
    if(!clienteId || !cabanaId || !fechaReserva || abono == null || !numPersonas) {
        return res.status(400).json({ error: 'Todos los campos son obligatorios'})
    }
    try {
        // Validar disponibilidad: ¿ya existe una reserva para esa cabaña en esa fecha?
        const existeReserva = await prisma.reserva.findFirst({
            where: {
                cabanaId: Number(cabanaId),
                fechaReserva: new Date(fechaReserva)
            }
        })
        if(existeReserva) {
            return res.status(409).json({ error: 'Ya existe una reserva para esa cabaña en esa fecha' })
        }
        // Creamos la reserva
        const nuevaReserva = await prisma.reserva.create({
            data: {
                clienteId: Number(clienteId),
                cabanaId: Number(cabanaId),
                fechaReserva: new Date(fechaReserva),
                abono: parseFloat(abono),
                numPersonas: Number(numPersonas),
                estado: 'reservada',
                adminId: req.admin.id
            }, 
            include: {
                cliente: true,
                cabana: true,
                administrador: true
            }
        })
        res.status(201).json({
            message: 'Reserva creada exitosamente',
            reserva: nuevaReserva
        })
    } catch (error) {
        console.error('Error al crear la reserva: ', error)
        res.status(500).json({ error: 'Error en el servidor al crear la reserva'})
    }
})

export default router