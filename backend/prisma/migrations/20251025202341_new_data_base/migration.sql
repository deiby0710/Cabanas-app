/*
  Warnings:

  - The values [reservada,finalizada] on the enum `EstadoReserva` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `usuario` on the `Administrador` table. All the data in the column will be lost.
  - You are about to drop the column `horaRegistro` on the `Reserva` table. All the data in the column will be lost.
  - You are about to alter the column `abono` on the `Reserva` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Decimal(65,30)`.
  - A unique constraint covering the columns `[email]` on the table `Administrador` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[googleId]` on the table `Administrador` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[organizacionId,nombre]` on the table `Cabana` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,organizacionId]` on the table `Cabana` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[id,organizacionId]` on the table `Cliente` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `Administrador` table without a default value. This is not possible if the table is not empty.
  - Added the required column `capacidad` to the `Cabana` table without a default value. This is not possible if the table is not empty.
  - Added the required column `organizacionId` to the `Cabana` table without a default value. This is not possible if the table is not empty.
  - Added the required column `organizacionId` to the `Cliente` table without a default value. This is not possible if the table is not empty.
  - Added the required column `organizacionId` to the `Reserva` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updateAt` to the `Reserva` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MEMBER');

-- AlterEnum
BEGIN;
CREATE TYPE "EstadoReserva_new" AS ENUM ('PENDIENTE', 'CONFIRMADA', 'CANCELADA', 'COMPLETADA');
ALTER TABLE "Reserva" ALTER COLUMN "estado" TYPE "EstadoReserva_new" USING ("estado"::text::"EstadoReserva_new");
ALTER TYPE "EstadoReserva" RENAME TO "EstadoReserva_old";
ALTER TYPE "EstadoReserva_new" RENAME TO "EstadoReserva";
DROP TYPE "EstadoReserva_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "Reserva" DROP CONSTRAINT "Reserva_adminId_fkey";

-- DropForeignKey
ALTER TABLE "Reserva" DROP CONSTRAINT "Reserva_cabanaId_fkey";

-- DropForeignKey
ALTER TABLE "Reserva" DROP CONSTRAINT "Reserva_clienteId_fkey";

-- DropIndex
DROP INDEX "Administrador_usuario_key";

-- AlterTable
ALTER TABLE "Administrador" DROP COLUMN "usuario",
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "googleId" TEXT,
ALTER COLUMN "password" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Cabana" ADD COLUMN     "capacidad" INTEGER NOT NULL,
ADD COLUMN     "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "organizacionId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Cliente" ADD COLUMN     "fechaRegistro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "organizacionId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Reserva" DROP COLUMN "horaRegistro",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "organizacionId" INTEGER NOT NULL,
ADD COLUMN     "updateAt" TIMESTAMP(3) NOT NULL,
ALTER COLUMN "abono" SET DATA TYPE DECIMAL(65,30);

-- CreateTable
CREATE TABLE "Organizacion" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "codigoInvitacion" TEXT NOT NULL,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Organizacion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdministradorOrganizacion" (
    "id" SERIAL NOT NULL,
    "adminId" INTEGER NOT NULL,
    "organizacionId" INTEGER NOT NULL,
    "rol" "Role" NOT NULL,
    "fechaUnion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdministradorOrganizacion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Organizacion_codigoInvitacion_key" ON "Organizacion"("codigoInvitacion");

-- CreateIndex
CREATE INDEX "AdministradorOrganizacion_organizacionId_rol_idx" ON "AdministradorOrganizacion"("organizacionId", "rol");

-- CreateIndex
CREATE UNIQUE INDEX "AdministradorOrganizacion_adminId_organizacionId_key" ON "AdministradorOrganizacion"("adminId", "organizacionId");

-- CreateIndex
CREATE UNIQUE INDEX "Administrador_email_key" ON "Administrador"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Administrador_googleId_key" ON "Administrador"("googleId");

-- CreateIndex
CREATE INDEX "Cabana_organizacionId_idx" ON "Cabana"("organizacionId");

-- CreateIndex
CREATE UNIQUE INDEX "Cabana_organizacionId_nombre_key" ON "Cabana"("organizacionId", "nombre");

-- CreateIndex
CREATE UNIQUE INDEX "Cabana_id_organizacionId_key" ON "Cabana"("id", "organizacionId");

-- CreateIndex
CREATE INDEX "Cliente_organizacionId_idx" ON "Cliente"("organizacionId");

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_id_organizacionId_key" ON "Cliente"("id", "organizacionId");

-- CreateIndex
CREATE INDEX "Reserva_organizacionId_fechaInicio_idx" ON "Reserva"("organizacionId", "fechaInicio");

-- CreateIndex
CREATE INDEX "Reserva_cabanaId_fechaInicio_idx" ON "Reserva"("cabanaId", "fechaInicio");

-- AddForeignKey
ALTER TABLE "AdministradorOrganizacion" ADD CONSTRAINT "AdministradorOrganizacion_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "Administrador"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AdministradorOrganizacion" ADD CONSTRAINT "AdministradorOrganizacion_organizacionId_fkey" FOREIGN KEY ("organizacionId") REFERENCES "Organizacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cabana" ADD CONSTRAINT "Cabana_organizacionId_fkey" FOREIGN KEY ("organizacionId") REFERENCES "Organizacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cliente" ADD CONSTRAINT "Cliente_organizacionId_fkey" FOREIGN KEY ("organizacionId") REFERENCES "Organizacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_cabanaId_organizacionId_fkey" FOREIGN KEY ("cabanaId", "organizacionId") REFERENCES "Cabana"("id", "organizacionId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_clienteId_organizacionId_fkey" FOREIGN KEY ("clienteId", "organizacionId") REFERENCES "Cliente"("id", "organizacionId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_adminId_organizacionId_fkey" FOREIGN KEY ("adminId", "organizacionId") REFERENCES "AdministradorOrganizacion"("adminId", "organizacionId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reserva" ADD CONSTRAINT "Reserva_organizacionId_fkey" FOREIGN KEY ("organizacionId") REFERENCES "Organizacion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
