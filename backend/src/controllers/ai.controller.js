import { chatbotHandleMessage } from "../ia/chatbotService.js";
export async function handleChat(req, res) {
  try {
    const adminId = req.admin.id;
    const { message, orgId } = req.body;

    if (!message) {
      return res.status(400).json({ error: "message es obligatorio" });
    }

    const result = await chatbotHandleMessage(message, adminId, orgId);

    return res.status(200).json(result);

  } catch (error) {
    console.error("Error en AI Chat:", error);
    return res.status(500).json({ error: "Error interno en el módulo IA." });
  }
}