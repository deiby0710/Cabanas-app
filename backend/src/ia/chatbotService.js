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
Debes responder SIEMPRE con un JSON estricto:
{
  "intent": "nombre_del_intent",
  "params": { ... }
}
NO escribas texto fuera del JSON.
NO escribas explicaciones.
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
async function generateNaturalResponse(intent, params, data) {
  const prompt = `
Eres un asistente útil de CabinApp.
Debes generar una respuesta clara, amable, en ESPAÑOL,
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
    const text = params?.originalMessage?.toLowerCase() ?? "";

    if (text.includes("gracias") || text.includes("thank")) {
      return "¡Con gusto! 😊 ¿Necesitas algo más?";
    }

    if (text.includes("quien eres") || text.includes("who are you")) {
      return "Soy el asistente inteligente de CabinApp 🤖. Puedo ayudarte con reservas, clientes y cabañas. ¿Qué necesitas?";
    }

    if (text.includes("que puedes hacer") || text.includes("what can you do")) {
      return "Puedo ayudarte a consultar disponibilidad de cabañas, revisar reservas, listar clientes y responder preguntas del sistema. ¿Qué deseas hacer?";
    }

    if (text.includes("buenos días")) {
      return "¡Buenos días! ☀️ ¿En qué puedo ayudarte hoy?";
    }

    if (text.includes("buenas noches")) {
      return "¡Buenas noches! 🌙 ¿Necesitas revisar alguna reserva o cabaña?";
    }

    // respuesta general
    return "¡Hola! 😊 ¿En qué puedo ayudarte hoy?";
  }

  const response = await askLLM([
    { role: "system", content: "Eres un generador de respuestas para CabinApp. Solo usa los datos dados." },
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
    rawData
  );

  return {
    intent: detection.intent,
    params: detection.params,
    data: rawData,
    respuesta: natural
  };
}