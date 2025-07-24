import { loginAdministrador } from "../services/auth.service.js";

export async function login(req, res) {
    const { usuario, password } = req.body

    if(!usuario||!password){
        return res.status(400).json({ error: 'Usuario y contraseña son obligatorios'})
    }

    try {
        const { token, admin } = await loginAdministrador({usuario, password})
        res.json({
            message: 'Inicio de sesión exitoso',
            token,
            admin
        })
    } catch (error) {
        if (error.message === 'USUARIO_NO_ENCONTRADO') {
            return res.status(400).json({ error: 'Usuario no encontrado'})
        }
        if (error.message === 'CONTRASENA_INVALIDA') {
            return res.status(401).json({error: 'Contraseña incorrecta'})
        }
        console.error('Error en el login: ', error)
        res.status(500).json({ error: 'Error en el servidor.'})
    }
}