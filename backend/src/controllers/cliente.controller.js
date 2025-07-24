import {
    obtenerClientes,
    crearCliente,
    actualizarCliente,
    eliminarCliente
} from '../services/cliente.service.js'

export async function getClientes(req, res) {
    try {
        const clientes = await obtenerClientes()
        res.json(clientes)
    } catch (error) {
        res.status(500).json({error: "Error al obtener los clientes."})
    }
}

export async function postCliente(req, res) {
    const { nombre, celular } = req.body
    if (!nombre || !celular) {
        return res.status(400).json({ error: 'Nombre y número celular son obligatorios' })
    }

    try {
        const cliente = await crearCliente({nombre, celular})
        res.status(201).json({
            message: 'Cliente creado exitosamente.',
            cliente
        })
    } catch (error) {
        res.status(500).json({error: 'Error al crear el cliente'})
    }
}

export async function putCliente(req, res){
    const { id } = req.params
    const { nombre, celular } = req.body

    try{
        const cliente = await actualizarCliente(Number(id), {nombre, celular})

        res.json({
            message: "Cliente actualizado exitosamente.",
            cliente
        })
    } catch (error) {
        res.status(500).json({ error: 'Error al actualizar el cliente' })
    }
}

export async function deleteCliente(req, res){
    const { id } = req.params

    try {
        await eliminarCliente(Number(id))
        res.json({message: 'Cliente eliminado exitosamente.'})
    } catch (error) {
        res.status(500).json({ error: "Error al eliminar cliente."})
    }
}