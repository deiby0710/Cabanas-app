import { PrismaClient } from "@prisma/client";
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

const prisma = new PrismaClient()

export async function loginAdministrador ({ usuario, password }) {
    // Validamos si el usuario existe
    const admin = await prisma.administrador.findUnique({
        where: { usuario }
    })

    if (!admin) {
        throw new Error('USUARIO_NO_ENCONTRADO')
    }
    // Comparamos la contraseña con la hasheada en la DB
    const validPassword = await bcrypt.compare(password, admin.password)
    if(!validPassword){
        throw new Error('CONTRASENA_INVALIDA')
    }

    const token = jwt.sign(
        { id: admin.id, nombre: admin.nombre }, 
        process.env.JWT_SECRET,
        { expiresIn: '8h'}
    )

    return {
        token,
        admin: {
            id: admin.id,
            nombre: admin.nombre,
            usuario: admin.usuario
        }
    }
}