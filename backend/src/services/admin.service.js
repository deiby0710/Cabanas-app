import { PrismaClient } from "@prisma/client";
import bcrypt from 'bcrypt'

const prisma = new PrismaClient()

export async function crearAdministrador(data) {
    const { nombre, usuario, password } = data

    // Verificar que el usuario no este duplicado
    const existe = await prisma.administrador.findUnique({ where: { usuario }})
    if (existe) throw new Error('USUARIO_YA_EXISTE')
    
    // Encriptar la contraseña
    const hash = await bcrypt.hash(password, 10)

    // Crear el administrador
    return await prisma.administrador.create({
        data: {
            nombre, 
            usuario,
            password: hash
        }
    })
}