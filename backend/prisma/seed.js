// prisma/seed.js
import { PrismaClient, Role, EstadoReserva } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // --- ORGS ---
  const org1 = await prisma.organizacion.create({
    data: {
      nombre: 'Cabin Dreams',
      codigoInvitacion: 'CABIN123',
    },
  });

  const org2 = await prisma.organizacion.create({
    data: {
      nombre: 'Mountain Stay',
      codigoInvitacion: 'MOUNT456',
    },
  });

  // --- ADMINS ---
  const admin1 = await prisma.administrador.create({
    data: {
      nombre: 'Deiby Delgado',
      email: 'deiby@example.com',
      password: '123456',
    },
  });

  const admin2 = await prisma.administrador.create({
    data: {
      nombre: 'Ana Torres',
      email: 'ana@gmail.com',
      googleId: 'google-ana-001',
    },
  });

  const admin3 = await prisma.administrador.create({
    data: {
      nombre: 'Carlos Ruiz',
      email: 'carlos@example.com',
      password: '123456',
    },
  });

  // --- RELACIONES ADMIN ↔ ORG ---
  await prisma.administradorOrganizacion.createMany({
    data: [
      { adminId: admin1.id, organizacionId: org1.id, rol: Role.ADMIN },
      { adminId: admin2.id, organizacionId: org1.id, rol: Role.MEMBER },
      { adminId: admin3.id, organizacionId: org2.id, rol: Role.ADMIN },
    ],
  });

  // --- CABANAS ---
  const cabana1 = await prisma.cabana.create({
    data: {
      nombre: 'Cabaña El Refugio',
      capacidad: 5,
      organizacionId: org1.id,
    },
  });

  const cabana2 = await prisma.cabana.create({
    data: {
      nombre: 'Vista al Lago',
      capacidad: 8,
      organizacionId: org1.id,
    },
  });

  // --- CLIENTES ---
  const cliente1 = await prisma.cliente.create({
    data: {
      nombre: 'Laura Gómez',
      celular: '3001112222',
      organizacionId: org1.id,
    },
  });

  const cliente2 = await prisma.cliente.create({
    data: {
      nombre: 'Juan Pérez',
      celular: '3003334444',
      organizacionId: org1.id,
    },
  });

  // --- RESERVAS ---
  const adminOrg1 = await prisma.administradorOrganizacion.findFirstOrThrow({
    where: { adminId: admin1.id, organizacionId: org1.id },
  });

  await prisma.reserva.create({
    data: {
      organizacionId: org1.id,
      cabanaId: cabana1.id,
      clienteId: cliente1.id,
      adminId: adminOrg1.adminId,
      estado: EstadoReserva.CONFIRMADA,
      fechaInicio: new Date('2025-10-28T14:00:00Z'),
      fechaFin: new Date('2025-10-30T11:00:00Z'),
      abono: 300000,
      numPersonas: 4,
    },
  });

  console.log('✅ Seed completado correctamente');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
