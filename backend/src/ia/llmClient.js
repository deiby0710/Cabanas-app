// Groq permite crear clientes, hacer request, obtener respuestas. 
import Groq from "groq-sdk";

// Creamos una instancia del cliente de IA
export const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

/**
 * Envía mensajes simples al modelo DeepSeek-R1 (gratis).
 * Este es el modo más básico, sin tools.
 */
export async function askLLM(messages) {
    // Aquí le decimos a Groq:
    // 🧠 Qué modelo queremos usar (llama-3.3-70b-versatile)
    // 💬 Qué mensajes queremos enviar (messages)
    // 🎛️ Temperatura: define si la IA responde más creativa (1.0) o más precisa (0.2)
    
  const response = await groq.chat.completions.create({
    model: "llama-3.3-70b-versatile",
    messages,
    temperature: 0.2
  });

  return response;
}