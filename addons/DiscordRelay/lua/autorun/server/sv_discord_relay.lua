require("gwsockets")

local config = util.JSONToTable(file.Read("addons/discord_relay.json", "MOD"))

local socket = GWSockets.createWebSocket("ws://" .. config.WSS_HOST .. ":" .. config.WSS_PORT)
socket:setHeader("Authorization", config.WSS_SECRET)

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
        local link = body:match("https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/.-jpg")
        if not link then return end
        fetchedavatars[steamID64] = link:Replace(".jpg", "_full.jpg")
    end)
end

hook.Add("PlayerAuthed", "DiscordFetchAvatar", function(client, steamid)
    fetchAvatarURL(util.SteamIDTo64(steamid))
end)

hook.Add("PlayerDisconnected", "DiscordClearAvatar", function(client)
    fetchedavatars[client:SteamID64()] = nil
end)

hook.Add("PlayerSay", "DiscordRelay", function(client, text)
    local data = {
        user = client.SteamName and client:SteamName() or client:Name(),
        avatar = fetchAvatarURL(client:SteamID64()),
        text = text
    }
    socket:write(util.TableToJSON(data))
end)

socket:open()
