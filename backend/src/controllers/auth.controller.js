import { 
    loginAdministrador,
    registerAdministrador
 } from "../services/auth.service.js";

export async function login(req, res) {
    const { email, password } = req.body

    if(!email||!password){
        return res.status(400).json({ error: 'Email y contraseña son obligatorios'})
    }

    try {
        const { token, admin,organizations, activeOrgId } = await loginAdministrador({email, password})
        res.json({
            message: 'Inicio de sesión exitoso',
            token,
            admin,
            organizations,
            activeOrgId
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

export async function register(req, res) {
    const { nombre, email, password } = req.body;

    if(!nombre || !email || !password) {
        return res.status(400).json({error: 'Todos los campos son obligatorios.'})
    }

    try {
        const {token, admin} = await registerAdministrador({nombre, email, password})
        res.status(201).json({
            message: "Registro exitoso.",
            token,
            admin
        })
    } catch (error){
        if (error.message === 'EMAIL_YA_REGISTRADO') {
            return res.status(400).json({ error: 'El email ya está registrado.' });
        }
        console.error('Error en el registro: ', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}