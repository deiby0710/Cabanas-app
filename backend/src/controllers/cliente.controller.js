import {
    createCustomerService,
    listCustomersService,
    getCustomerByIdService,
    updateCustomerService,
    deleteCustomerService
} from '../services/cliente.service.js'

export async function createCustomer(req, res) {
    try {
        const adminId = req.admin.id;
        const { organizacionId, nombre, celular } = req.body;

        if (!organizacionId || !nombre || !celular) {
            return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
        }

        const newCustomer = await createCustomerService(adminId, organizacionId, { nombre, celular });

        if (!newCustomer) {
            return res.status(403).json({ error: 'No tienes acceso a esta organización.' });
        }

        res.status(201).json({
            message: 'Cliente creado correctamente.',
            customer: newCustomer,
        });
    } catch (error) {
        console.error('Error al crear cliente:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function listCustomers(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);

        const customers = await listCustomersService(adminId, orgId);

        if (!customers) {
            return res.status(403).json({ error: 'No tienes acceso a esta organización.' });
        }

        res.status(200).json({
            message: 'Clientes obtenidos correctamente.',
            customers,
        });
    } catch (error) {
        console.error('Error al listar clientes:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function getCustomerById(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const clienteId = parseInt(req.params.clienteId);

        const customer = await getCustomerByIdService(adminId, orgId, clienteId);

        if (!customer) {
            return res.status(403).json({ error: 'No tienes acceso o el cliente no existe.' });
        }

        res.status(200).json({
            message: 'Cliente obtenido correctamente.',
            customer,
        });
    } catch (error) {
        console.error('Error al obtener cliente:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function updateCustomer(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const clienteId = parseInt(req.params.clienteId);
        const { nombre, celular } = req.body;

        if (!nombre && !celular) {
            return res.status(400).json({ error: 'Debe proporcionar al menos un campo para actualizar.' });
        }

        const updatedCustomer = await updateCustomerService(adminId, orgId, clienteId, { nombre, celular });

        if (!updatedCustomer) {
            return res.status(403).json({ error: 'No tienes acceso o el cliente no existe.' });
        }

        res.status(200).json({
            message: 'Cliente actualizado correctamente.',
            customer: updatedCustomer,
        });
    } catch (error) {
        console.error('Error al actualizar cliente:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function deleteCustomer(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);
        const clienteId = parseInt(req.params.clienteId);

        const deleted = await deleteCustomerService(adminId, orgId, clienteId);

        if (deleted === 'RESERVAS_ACTIVAS') {
            return res.status(400).json({ error: 'El cliente tiene reservas activas y no puede eliminarse.' });
        }

        if (!deleted) {
            return res.status(403).json({ error: 'No tienes permisos o el cliente no existe.' });
        }

        res.status(200).json({ message: 'Cliente eliminado correctamente.' });
    } catch (error) {
        console.error('Error al eliminar cliente:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}