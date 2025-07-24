/*
  Warnings:

  - You are about to drop the column `correo` on the `Cliente` table. All the data in the column will be lost.
  - You are about to drop the column `direccion` on the `Cliente` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "Cliente_correo_key";

-- AlterTable
ALTER TABLE "Cliente" DROP COLUMN "correo",
DROP COLUMN "direccion";
