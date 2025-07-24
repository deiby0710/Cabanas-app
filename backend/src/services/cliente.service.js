import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// Obtenemos todos los clientes
export async function obtenerClientes(){
    return await prisma.cliente.findMany()
}

// Creamos un cliente
export async function crearCliente(data){
    return await prisma.cliente.create({
        data
    })
}

// Actualizar cliente
export async function actualizarCliente(id, data){
    const clienteExistente = await prisma.cliente.findUnique({ where: { id }})
    if (!clienteExistente) {
        throw new Error('Cliente no encontrado.')
    }
    return await prisma.cliente.update({
        where: { id },
        data
    })
}

// Eliminar cliente
export async function eliminarCliente(id){
    const clienteExistente = await prisma.cliente.findUnique({ where: { id }})
    if (!clienteExistente) {
        throw new Error('Cliente no encontrado.')
    }
    return await prisma.cliente.delete({
        where: { id }
    }) 
}