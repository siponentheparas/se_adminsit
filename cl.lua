RegisterNetEvent('se_adminsit:msg', function(msg)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Serveri", msg}
    })
end)

TriggerEvent('chat:addSuggestion', '/adminkeissi', 'Luo admin keissin', {
    { name="Id", help="Pelaajan id" }
})

TriggerEvent('chat:addSuggestion', '/adminkeissi_lisää', 'Lisää pelaaja admin keissiin', {
    { name="Id", help="Pelaajan id" },
    { name="Id", help="Admin keissin id"}
})

TriggerEvent('chat:addSuggestion', '/adminkeissi_poista', 'Poista pelaaja admin keissistä', {
    { name="Id", help="Pelaajan id" }
})

TriggerEvent('chat:addSuggestion', '/epäadminkeissi', 'Poista admin keissi', {
    { name="Id", help="Admin keissin id" }
})

TriggerEvent('chat:addSuggestion', '/keissinumero', 'Näytä nykyinen admin keissi numero', {})
