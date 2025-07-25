import { PrismaClient } from "@prisma/client";
import { convertirFechaUTC } from "../utils/fecha.js";

const prisma = new PrismaClient();

export async function crearReserva(data) {
    const { cabanaId, fechaInicio, fechaFin } = data

    // Validar si se solapa con otra reserva
    const conflicto = await prisma.reserva.findFirst({
        where:{
            cabanaId,
            AND: [
                {fechaInicio: { lte: fechaFin}},
                {fechaFin: { gte: fechaInicio}}
            ]
        }
    })

    if(conflicto){
        throw new Error('RESERVA_SUPERPUESTA')
    }
    const nuevaReserva = await prisma.reserva.create({
        data: {
            ...data,
            fechaInicio,
            fechaFin
        }, 
        include: {
            cliente: true,
            cabana: true,
            administrador: true
        }
    })

    return nuevaReserva
}


// Get: Traemos todas las reservas
export async function observarReservas(){
    return prisma.reserva.findMany({
        orderBy: {
            fechaInicio: 'asc'
        }, 
        include: {
            cliente: true,
            cabana: true,
            administrador: {
                select: {
                    id: true,
                    nombre: true,
                    usuario: true
                }
            }
        }
    })
}

//Get: Traemos una reserva
export async function obtenerReservaPorId(id){
    const reserva = await prisma.reserva.findUnique({
        where: { id },
        include: {
            cliente: true,
            cabana: true,
            administrador: {
                select: {
                    id: true,
                    nombre: true,
                    usuario: true
                }
            }
        }
    })

    if(!reserva) throw new Error('RESERVA_NO_ENCONTRADA')

    return reserva
}

//Put: Actualizamos una reserva
export async function actualizarReserva(id, data){
    const reservaExiste = await prisma.reserva.findUnique({ where: {id} })

    if(!reservaExiste) throw new Error('RESERVA_NO_ENCONTRADA')

    const { cabanaId, fechaInicio, fechaFin } = data

    // Si se cambia fecha validar el solapamiento
    if (cabanaId && fechaInicio){
        const inicio = convertirFechaUTC(fechaInicio)
        const fin = fechaFin? convertirFechaUTC(fechaFin): new Date(inicio)

        const conflicto = await prisma.reserva.findFirst({
            where: {
                cabanaId,
                id: { not: id }, // se excluye a si mismo
                AND: [
                    {fechaInicio: { lte: fin }},
                    {fechaFin: { gte: inicio }}
                ]
            }
        })

        if(conflicto) throw new Error('RESERVA_SUPERPUESTA')

        data.fechaInicio = inicio
        data.fechaFin = fin
    }
    return await prisma.reserva.update({
        where: { id },
        data, 
        include: {
            cliente: true,
            cabana: true,
            administrador: true
        }
    })
}

//Delete
export async function eliminarReserva(id){
    const reserva = await prisma.reserva.findUnique({ where: { id }})

    if(!reserva) throw new Error('RESERVA_NO_ENCONTRADA')
    
    await prisma.reserva.delete({ where: { id }})

    return reserva
}