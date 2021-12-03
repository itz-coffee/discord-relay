local PLUGIN = PLUGIN
require("gwsockets")

local config = ix.yaml.Read("gamemodes/helix/discord_relay.yml")
local WSS_SECRET = config.WSS_SECRET
local WSS_PORT = config.WSS_PORT

local socket = GWSockets.createWebSocket("ws://localhost:" .. WSS_PORT)
socket:setHeader("Authorization", WSS_SECRET)

util.AddNetworkString("DiscordChat")

function socket:onMessage(message)
    MsgC(Color(114, 137, 218), "[Discord] ", color_white, message, "\n")

    net.Start("DiscordChat")
        net.WriteString(message)
    net.Broadcast()
end

function socket:onError(message)
    ErrorNoHalt("Websocket error: ", message, "\n")
end

function socket:onConnected()
    print("Connected to websocket server")
end

function socket:onDisconnected()
    print("Websocket disconnected, retrying...")

    timer.Create("DiscordReconnect", 5, 0, function()
        if socket:isConnected() then
            timer.Remove("DiscordReconnect")
        else
            socket:closeNow()
            socket:open()
        end
    end)
end

local fetchedavatars = {}

local function fetchAvatarURL(steamID64)
    if fetchedavatars[steamID64] then return fetchedavatars[steamID64] end

    http.Fetch("http://steamcommunity.com/profiles/" .. steamID64 .. "/?xml=1", function(body)
        local link = body:match("https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/avatars/.-jpg")
        if not link then return end
        fetchedavatars[steamID64] = link:Replace(".jpg", "_full.jpg")
    end)
end

function PLUGIN:PlayerAuthed(client, steamid)
    fetchAvatarURL(util.SteamIDTo64(steamid))
end

function PLUGIN:PlayerDisconnected(client)
    fetchedavatars[client:SteamID64()] = nil
end

function PLUGIN:PlayerSay(client, chatType, message)
    if chatType ~= "ooc" then return end

    local data = {
        user = client:SteamName(),
        avatar = fetchAvatarURL(client:SteamID64()),
        text = message
    }
    socket:write(util.TableToJSON(data))
end

socket:open()
