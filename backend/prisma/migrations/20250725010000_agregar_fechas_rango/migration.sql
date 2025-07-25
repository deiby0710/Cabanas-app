/*
  Warnings:

  - You are about to drop the column `fechaReserva` on the `Reserva` table. All the data in the column will be lost.
  - Added the required column `fechaFin` to the `Reserva` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fechaInicio` to the `Reserva` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Reserva_cabanaId_fechaReserva_key";

-- AlterTable
ALTER TABLE "Reserva" DROP COLUMN "fechaReserva",
ADD COLUMN     "fechaFin" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "fechaInicio" TIMESTAMP(3) NOT NULL;
