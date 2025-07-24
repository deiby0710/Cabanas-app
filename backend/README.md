# 🏕 Software de Gestión de Cabañas

Aplicación móvil (actualmente backend en desarrollo) para la gestión de cabañas. Permite a múltiples administradores registrar reservas, gestionar la disponibilidad y asociar clientes con sus reservas.

---

## 🚀 Tecnologías utilizadas

- **Backend:** Node.js + Express
- **ORM:** Prisma
- **Base de Datos:** PostgreSQL
- **Autenticación:** bcrypt + JWT
- **Variables de entorno:** dotenv

---

## 📁 Estructura del proyecto

```
/backend
├── .env                     # Variables de entorno (no versionar)
├── package.json             # Dependencias y scripts
└── /src
    ├── index.js             # Entrypoint principal de Express
    ├── /routes
    │   └── auth.routes.js   # Ruta de login
```

---

## 📦 Instalación

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tuusuario/software-cabanas.git
   cd software-cabanas/backend
   ```

2. Instalar dependencias:
   ```bash
   npm install
   ```

3. Configurar el archivo `.env` con tus valores:

   ```env
   DATABASE_URL=postgresql://usuario:password@localhost:5432/cabanas
   JWT_SECRET=tu_clave_super_secreta
   ```

4. Ejecutar migraciones de Prisma:
   ```bash
   npx prisma migrate dev --name init
   ```

5. Iniciar el servidor:
   ```bash
   npm run dev
   ```

---

## 🔐 Autenticación

Actualmente existe una única ruta:

```
POST /login
```

- Body esperado:
  ```json
  {
    "usuario": "admin1",
    "password": "123456"
  }
  ```

- Respuesta exitosa:
  ```json
  {
    "token": "JWT_TOKEN",
    "admin": {
      "id": 1,
      "nombre": "Deiby",
      "usuario": "admin1"
    }
  }
  ```

---

## 🧩 Modelo de Base de Datos

Incluye 4 modelos principales: `Administrador`, `Cliente`, `Cabana`, `Reserva`, y un enum `EstadoReserva`.

> Ver archivo `prisma/schema.prisma` para más detalles.

---

## 📌 Próximas funcionalidades

- [ ] Protección de rutas con JWT
- [ ] Rutas para CRUD de:
  - Clientes
  - Cabañas
  - Reservas
- [ ] Validaciones y middlewares
- [ ] Integración con aplicación móvil (probablemente React Native)

---

## 📄 Licencia

MIT © Deiby Alejandro Delgado Estrada
