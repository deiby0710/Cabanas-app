-- CreateEnum
CREATE TYPE "EstadoReserva" AS ENUM ('reservada', 'finalizada');

-- CreateTable
CREATE TABLE "Cabana" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "Cabana_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cliente" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "celular" TEXT NOT NULL,
    "correo" TEXT,
    "direccion" TEXT,

    CONSTRAINT "Cliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reserva" (
    "id" SERIAL NOT NULL,
    "cabanaId" INTEGER NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "adminId" INTEGER NOT NULL,
    "fechaReserva" TIMESTAMP(3) NOT NULL,
    "abono" DOUBLE PRECISION NOT NULL,
    "numPersonas" INTEGER NOT NULL,
    "horaRegistro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "estado" "EstadoReserva" NOT NULL,

    CONSTRAINT "Reserva_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_correo_key" ON "Cliente"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "Reserva_cabanaId_fechaReserva_key" ON "Reserva"("cabanaId", "fechaReserva");

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_cabanaId_fkey" FOREIGN KEY ("cabanaId") REFERENCES "Cabana"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Administrador"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
