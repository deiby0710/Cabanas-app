import { askLLM } from "./llmClient.js";
import { SYSTEM_PROMPT } from "./promptTemplates.js";
import { routeIntent } from "./intentRouter.js";

function cleanJSON(text) {
  return text
    .replace(/```json/gi, "")
    .replace(/```/g, "")
    .trim();
}


/**
 * 1. Detecta intención con Llama (JSON obligatorio)
 */
async function detectIntent(message, adminId, orgId) {
  const response = await askLLM([
    {
      role: "system",
      content: SYSTEM_PROMPT + `
IMPORTANTE:

1. Detecta automáticamente el idioma del mensaje del usuario.
2. Devuelve SIEMPRE el JSON en ese mismo idioma si el intent lo permite.
3. Si el intent requiere español (por ejemplo datos del backend), puedes usar español para las claves, pero el contenido de texto que venga del usuario NO lo traduzcas.
4. El JSON debe ser estrictamente válido:

{
  "intent": "nombre_del_intent",
  "params": { ... }
}
NO escribas texto fuera del JSON.
NO explicaciones.
`
        },
        { role: "user", content: message }
    ]);

    const content = response.choices[0].message.content;
    console.log("content bruto:", content);

    try {
        const cleaned = cleanJSON(content);

        console.log("content cleaned:", cleaned);

        const parsed = JSON.parse(cleaned);

        // Insertamos adminId y orgId del backend, ignoramos lo que devuelva la IA.
        parsed.params.adminId = adminId;
        parsed.params.orgId = orgId;

        return { success: true, intent: parsed.intent, params: parsed.params };

    } catch (err) {
        return { success: false, message: "La IA no devolvió un JSON válido.", raw: content };
    }
}

/**
 * Genera un mensaje natural usando los datos reales devueltos por routeIntent.
 * La IA NO puede inventar nada porque solo usa los datos que le enviamos aquí.
 */
async function generateNaturalResponse(intent, params, data, message) {
  const prompt = `
Eres un asistente útil de CabinApp.
basada SOLO en los datos proporcionados a continuación.

Nunca inventes nombres, fechas o datos que no estén en la sección "DATOS".
Si no hay datos suficientes, explica qué falta.

---
INTENT: ${intent}

PARAMS:
${JSON.stringify(params, null, 2)}

DATOS (respuesta del backend):
${JSON.stringify(data, null, 2)}
---

Genera una explicación natural, breve y clara para el usuario.
Puedes usar emojis si ayudan, pero no abuses.
`;

  if (intent === "small_talk") {

    const smalltalkPrompt = `
  Eres CabinAI, un asistente amable y conversacional.
  Tu objetivo es conversar naturalmente con el usuario.

  Debes detectar automáticamente el idioma del usuario a partir de este mensaje:
  "${message}"

  Reglas de idioma:
  - Si el usuario habla en español → responde en español.
  - Si el usuario habla en inglés → responde en inglés.
  - Si mezcla idiomas, responde en el idioma dominante.
  - No traduzcas el contenido del usuario.

  Reglas de contenido:
  - NO inventes datos del sistema.
  - NO menciones IDs.
  - Responde breve, cálido y humano.

  Información fija:
  - Creadores: Deiby Alejandro Delgado y David Santiago Enríquez.
  - CabinApp: sistema para gestionar cabañas, clientes y reservas.
  - Puedes ayudar consultando disponibilidad, listar cabañas, buscar clientes, ver reservas, etc.

  REGLAS:
  - NO inventes datos del sistema (reservas, clientes, cabañas).
  - Para preguntas personales o casuales, responde como un asistente cálido.
  - No menciones IDs.
  - No uses tecnicismos.
  - Mantén respuestas breves y naturales.

  Mensaje del usuario:
  "${message}"

  Responde de manera natural y humana.
    `;

    const response = await askLLM([
      { role: "system", content: smalltalkPrompt },
      { role: "user", content: message }
    ]);

    return response.choices[0].message.content;
  }

  const response = await askLLM([
    { role: "system", content: `
Eres un generador de respuestas para CabinApp.
DEBES DETECTAR AUTOMÁTICAMENTE EL IDIOMA DEL USUARIO según el texto:
"${message}"
Reglas para idioma:
- Si el usuario escribe en español → responde en español.
- Si el usuario escribe en inglés → responde en inglés.
- Si el usuario cambia de idioma, tú también cambias.
- Nunca mezcles idiomas en la misma respuesta.
- No traduzcas datos que vienen de la base de datos, a menos que sean los estados de la reserva como pendiente, confirmada, cancelado y completada. 

Convierte los datos del backend en mensajes naturales y útiles para el usuario final.

REGLAS OBLIGATORIAS:

1. **NUNCA menciones IDs.**
   - Ignora cualquier campo cuyo nombre sea "id" o termine en "Id" o contenga "id".
   - Ejemplos prohibidos: "id", "clienteId", "cabanaId", "reservaId", "adminId".
   - No incluyas números internos de base de datos.

2. **Usa siempre los nombres reales de los objetos.**
   - cliente.nombre
   - cabana.nombre
   - admin.nombre
   - ocupante.nombre
   - creadoPor.nombre
   - Si no hay nombre: di “no tengo el nombre disponible”.

3. **Nunca inventes información.**
   - No inventes nombres de clientes, cabañas, fechas o estados.
   - Usa únicamente lo que aparece en la sección "DATOS".

4. **Nunca muestres estructuras técnicas o internas.**
   - No muestres JSON, objetos, listas técnicas, claves internas, ni campos del backend.
   - No uses palabras como “registro”, “objeto”, “nodo”, “propiedad”, “backend”.

5. **Transforma los datos en lenguaje natural.**
   - Si hay varias reservas, haz un resumen humano.
   - Si solo hay una, descríbela de manera amable.
   - Si no hay resultados, dilo claramente.

6. **Tono: cálido, profesional, amable, claro y breve.**
   - Puedes usar emojis, pero no abuses.

Estas reglas son obligatorias. Si un dato falta o está incompleto, dilo de forma natural sin inventar nada.
`
  },
    { role: "user", content: prompt }
  ]);

  return response.choices[0].message.content;
}


/**
 * Chatbot principal:
 * Detecta intención → Ejecuta lógica → Genera respuesta bonita
 */
export async function chatbotHandleMessage(message, adminId, orgId) {

  // 1. Detectamos la intención
  const detection = await detectIntent(message, adminId, orgId);

  if (!detection.success) {
    return detection;
  }

  // 2. Ejecutamos la lógica real
  const rawData = await routeIntent(detection.intent, detection.params);

  // 3. Generamos una respuesta natural
  const natural = await generateNaturalResponse(
    detection.intent,
    detection.params,
    rawData,
    message
  );

  return {
    intent: detection.intent,
    params: detection.params,
    data: rawData,
    respuesta: natural
  };
}