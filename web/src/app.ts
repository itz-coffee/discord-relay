import { WebSocketServer, WebSocket, RawData } from "ws";
import { WSS_SECRET, BOT_TOKEN, CHANNEL_ID, WEBHOOK, PORT } from "./config.json";
import { Client, Intents, Message } from "discord.js";
import { Webhook } from "discord-webhook-node";
import { IncomingMessage } from "http";

type Response = {
  user: string,
  avatar?: `https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/avatars/${number}_full.jpg`,
  text: string
}

const wss = new WebSocketServer({ port: PORT });
const webhook = new Webhook(WEBHOOK);

wss.on("connection", async (socket: WebSocket, req: IncomingMessage): Promise<void> => {
  if (req.headers.authorization == WSS_SECRET) {
    socket.on("message", async (data: RawData) => {
      const message: Response = JSON.parse(data.toString());

      webhook.setUsername(message.user);
      webhook.setAvatar(message.avatar ? message.avatar : "");
      await webhook.send(message.text);
    });
  } else {
    socket.send("HTTP/1.1 401 Unauthorized\r\n\r\n");
    socket.close();
    return;
  }
});

const bot = new Client({ intents: [
  Intents.FLAGS.GUILD_MESSAGES,
  Intents.FLAGS.GUILDS,
] });

bot.on("messageCreate", (message: Message): void => {
  if (message.author.bot || message.webhookId) return;
  if (message.channelId != CHANNEL_ID) return;

  wss.clients.forEach((socket: WebSocket): void => {
    if (socket.readyState === WebSocket.OPEN) {
      socket.send(`${message.author.username}: ${message.content}`);
    }
  });
});

bot.login(BOT_TOKEN);
