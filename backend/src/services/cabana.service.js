import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

export async function obtenerCabanas() {
    return await prisma.cabana.findMany()
}

export async function crearCabana(data) {
    return await prisma.cabana.create({ data })
}

export async function actualizarCabana(id, data){
    const cabana = await prisma.cabana.findUnique({ where: {id} })
    if (!cabana) throw new Error('CABANA_NO_ENCONTRADA')
    return await prisma.cabana.update({
        where: { id },
        data
    })
}

export async function eliminarCabana(id){
    const cabana = await prisma.cabana.findUnique({ where: {id} })
    if (!cabana) throw new Error('CABANA_NO_ENCONTRADA')

    return await prisma.cabana.delete({ where: { id }})
}