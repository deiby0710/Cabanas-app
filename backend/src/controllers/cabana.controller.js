import {
    createCabinService,
    listCabinsService,
    getCabinByIdService,
    updateCabinService,
    deleteCabinService
} from '../services/cabana.service.js'

export async function createCabin(req, res){
    try {
        const adminId = req.admin.id;
        const { organizacionId, nombre, capacidad } = req.body;

        if (!adminId) {
            return res.status(400).json({ error: 'El Id del administrador es requerido.'})
        }
        if (!organizacionId || !nombre || !capacidad) {
            return res.status(400).json({ error: 'Todos los campos son obligatorios.' });
        }

        const cabin = await createCabinService(adminId, organizacionId, nombre, capacidad);

        if (!cabin) {
            return res.status(403).json({ error: 'No tienes permisos para crear cabañas en esta organización.' });
        }

        res.status(201).json({
            message: 'Cabaña creada correctamente.',
            cabin,
        });
    } catch (error) {
        console.error('Error al crear cabaña:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function listCabins(req, res) {
    try {
        const adminId = req.admin.id;
        const orgId = parseInt(req.params.orgId);

        if (!adminId) {
            return res.status(400).json({ error: 'El Id del administrador es requerido.'})
        }
        if (!orgId) {
            return res.status(400).json({ error: 'El Id de la organizacion es requerido.'})
        }

        const cabins = await listCabinsService(adminId, orgId);

        if (!cabins) {
            return res.status(403).json({ error: 'No tienes acceso a esta organización.' });
        }

        res.status(200).json({
            message: 'Cabañas obtenidas correctamente.',
            cabins,
        });
    } catch (error) {
        console.error('Error al listar cabañas:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
}

export async function getCabinById(req, res) {
  try {
    const adminId = req.admin.id;
    const orgId = parseInt(req.params.orgId);
    const cabanaId = parseInt(req.params.cabanaId);

    if (!adminId) {
            return res.status(400).json({ error: 'El Id del administrador es requerido.'})
        }
    if (!orgId) {
        return res.status(400).json({ error: 'El Id de la organizacion es requerido.'})
    }
    if (!cabanaId) {
        return res.status(400).json({ error: 'El Id de la cabaña es requerido.'})
    }
    const cabin = await getCabinByIdService(adminId, orgId, cabanaId);

    if (!cabin) {
      return res.status(403).json({ error: 'No tienes acceso o la cabaña no existe.' });
    }

    res.status(200).json({
      message: 'Cabaña obtenida correctamente.',
      cabin,
    });
  } catch (error) {
    console.error('Error al obtener cabaña:', error);
    res.status(500).json({ error: 'Error en el servidor.' });
  }
}

export async function updateCabin(req, res) {
  try {
    const adminId = req.admin.id;
    const orgId = parseInt(req.params.orgId);
    const cabanaId = parseInt(req.params.cabanaId);
    const { nombre, capacidad } = req.body;

    if (!nombre || !capacidad) {
      return res.status(400).json({ error: 'Nombre y capacidad son obligatorios.' });
    }
    if (!adminId) {
            return res.status(400).json({ error: 'El Id del administrador es requerido.'})
        }
    if (!orgId) {
        return res.status(400).json({ error: 'El Id de la organizacion es requerido.'})
    }
    if (!cabanaId) {
        return res.status(400).json({ error: 'El Id de la cabaña es requerido.'})
    }

    const updatedCabin = await updateCabinService(adminId, orgId, cabanaId, { nombre, capacidad });

    if (!updatedCabin) {
        return res.status(403).json({ error: 'No tienes permisos o la cabaña no existe.' });
    }

    res.status(200).json({
      message: 'Cabaña actualizada correctamente.',
      cabin: updatedCabin,
    });
  } catch (error) {
    console.error('Error al actualizar cabaña:', error);
    res.status(500).json({ error: 'Error en el servidor.' });
  }
}

export async function deleteCabin(req, res) {
  try {
    const adminId = req.admin.id;
    const orgId = parseInt(req.params.orgId);
    const cabanaId = parseInt(req.params.cabanaId);

    const deleted = await deleteCabinService(adminId, orgId, cabanaId);

    if (!deleted) {
        return res.status(403).json({ error: 'No tienes permisos o la cabaña no existe.' });
    }

    res.status(200).json({ message: 'Cabaña eliminada correctamente.' });
  } catch (error) {
    console.error('Error al eliminar cabaña:', error);
    res.status(500).json({ error: 'Error en el servidor.' });
  }
}