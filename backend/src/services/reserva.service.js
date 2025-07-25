import { PrismaClient } from "@prisma/client";

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