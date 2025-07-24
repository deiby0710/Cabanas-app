import {
    obtenerCabanas,
    crearCabana,
    actualizarCabana,
    eliminarCabana
} from '../services/cabana.service.js'

export async function getCabana(req, res) {
    try{
        const cabanas = await obtenerCabanas()
        res.json(cabanas)
    } catch (error) {
        res.status(500).json({ error: 'Error al obtener las cabañas.'})
    }    
}

export async function postCabana(req, res){
    const { nombre } = req.body
    if (!nombre) {
        return res.status(400).json({ error: 'El nombre de la cabaña es obligatorio.'})
    }

    try{
        const cabana = await crearCabana({ nombre })
        res.status(201).json({ message: "Cabaña creada exitosamente", cabana})
    } catch (error) {
        res.status(500).json({ error: 'Error al crear la cabaña.'})
    }
}

export async function putCabana(req, res){
    const { id } = req.params
    const { nombre } = req.body

    if (!nombre) {
        return res.status(400).json({ error: 'El nombre es obligatorio.'})
    }

    try {
        const cabana = await actualizarCabana(Number(id), {nombre})
        res.json({message: 'Cabaña actualizada exitosamente', cabana})
    } catch (error) {
        if(error.message === 'CABANA_NO_ENCONTRADA') {
            return res.status(404).json({ error: 'Cabaña no encontrada.'})
        }
        res.status(500).json({ error: 'Error al actualizar la cabaña.'})
    }
}

export async function deleteCabana(req, res){
    const { id } = req.params

    try {
        await eliminarCabana(Number(id))
        res.json({ message: 'Cabaña eliminada existosamente.'})
    } catch (error) {
        if(error.message === 'CABANA_NO_ENCONTRADA') {
            return res.status(404).json({ error: 'Cabaña no encontrada.'})
        }
        res.status(500).json({ error: 'Error al eliminar la cabaña.'})
    }
}