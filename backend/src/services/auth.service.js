import { PrismaClient } from "@prisma/client";
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

const prisma = new PrismaClient()

export async function loginAdministrador ({ email, password }) {
    // Validamos si el usuario existe
    const admin = await prisma.administrador.findUnique({
        where: { email }, 
        // Include: Traer relaciones asociadas al registro.
        include: {
            organizaciones: {
                include: { organizacion: true}
            }
        }
    })

    if (!admin) {
        throw new Error('USUARIO_NO_ENCONTRADO')
    }
    if (!admin.password){
        throw new Error('USA_GOOGLE_SIGNIN')
    }
    // Comparamos la contraseña con la hasheada en la DB
    const validPassword = await bcrypt.compare(password, admin.password)
    if(!validPassword){
        throw new Error('CONTRASENA_INVALIDA')
    }

    // Lista de organizaciones a las que pertenece el admin
    // Esto es gracias a: organizaciones AdministradorOrganizacion[] en el modelo
    const organizations = admin.organizaciones.map(m => ({
        id: m.organizacionId,
        nombre: m.organizacion.nombre,
        rol: m.rol,
    }))
    // Tomamos la primera organizacion como activa.
    const activeOrgId = organizations[0]?.id || null;

    // jwt.sign() crea un token JWT -> Este token es envia al front end y viaja en cada peticion
    const token = jwt.sign(
        { 
            id: admin.id, 
            nombre: admin.nombre, 
            orgaId: activeOrgId,
            role: admin.organizaciones.find(o => o.organizacionId === activeOrgId)?.rol,
         }, 
        process.env.JWT_SECRET,
        { expiresIn: '8h'},
    )

    return {
        token,
        admin: {
            id: admin.id,
            nombre: admin.nombre,
            email: admin.email
        },
        organizations,
        activeOrgId,
    }
}


export async function registerAdministrador({ nombre, email, password }) {
    // Validar si ya existe
    const existe = await prisma.administrador.findUnique({ where: { email }})
    if (existe) throw new Error('EMAIL_YA_REGISTRADO')
    
    // Hasheamos contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Creamos admin
    const admin = await prisma.administrador.create({
        data: {
            nombre,
            email,
            password: hashedPassword,
        }, 
        select: {
            id: true,
            nombre: true,
            email: true,
            fechaCreacion: true,
        }
    });

    // token
    const token = jwt.sign(
        {
            id: admin.id,
            nombre: admin.nombre,
            orgId: null,
            role: null,
        },
        process.env.JWT_SECRET,
        { expiresIn: '8h'}
    );

    return {
        token,
        admin: {
            id: admin.id,
            nombre: admin.nombre,
            email: admin.email,
        }
    }

}