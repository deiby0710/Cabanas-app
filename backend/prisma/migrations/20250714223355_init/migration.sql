-- CreateTable
CREATE TABLE "Administrador" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "usuario" TEXT NOT NULL,
    "password" TEXT NOT NULL,

    CONSTRAINT "Administrador_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Administrador_usuario_key" ON "Administrador"("usuario");
