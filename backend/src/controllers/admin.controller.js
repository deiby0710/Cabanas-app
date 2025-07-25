import { crearAdministrador } from "../services/admin.service.js";

export async function postAdmin(req, res) {
    const { nombre, usuario, password } = req.body

    if(!nombre || !usuario || !password) {
        return res.status(400).json({ error: 'Datos incompletos para crear un administrador.'})
    }

    try {
        const admin = await crearAdministrador(req.body)
        res.status(201).json({
            message: 'Administrador creado exitosamente',
            admin: {
                id: admin.id,
                nombre: admin.nombre,
                usuario: admin.usuario
            }
        })
    } catch (error) {
        if(error.message === 'USUARIO_YA_EXISTE'){
            return res.status(400).json({ error: 'El usuario ya existe.'})
        }
        console.error('Error al crear el administrador: ',error)
        res.status(500).json({ error: 'Error interno en el servidor'})
    }
}