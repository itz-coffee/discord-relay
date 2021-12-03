net.Receive("DiscordChat", function()
    local text = net.ReadString()

    chat.AddText(Color(114, 137, 218), "[Discord] ", color_white, text)
end)