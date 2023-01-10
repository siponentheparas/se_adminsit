-- Tallentaa jokaisen admin keissin tiedot: admin keissin id ja sijainti indeksi
local adminSits = {}
-- Tallentaa admin keissi id:t
local sitIds = {}
-- Tallentaa käytetyt sijainti indeksit
local takenLocations = {}
-- Tallentaa admin keissiin liittyneiden: id, adminkeissi id ja alkuperäinen sijainti
local players = {}

-- Aloittaa admin keissin
RegisterCommand('adminkeissi', function(source, args, rawCommand)
    -- add_ace group.admin "se_adminsit" allow
    if IsPlayerAceAllowed(source, 'se_adminsit') then
        if not args[1] then msg(source, 'Sinä et syöttänyt pelaajan id:tä') return end
        if not isNumber(args[1]) then msg(source, 'Pelaajan id pitää olla numero') return end

        local id = args[1]
        if not playerExists(id) then msg(source, 'Pelaaja (' .. id ..') ei ole serverillä') return end

        addAdminSit(source, id)
    end
end)

-- Lisää pelaaja admin keissiin
RegisterCommand('adminkeissi_lisää', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, 'se_adminsit') then
        if not args[1] then msg(source, 'Sinä et syöttänyt pelaajan id:tä') return end
        if not args[2] then msg(source, 'Sinä et syöttänyt keissi numeroa') return end
        if not isNumber(args[1]) then msg(source, 'Pelaajan id pitää olla numero') return end
        if not isNumber(args[2]) then msg(source, 'Keissi numero pitää olla numero') return end

        local id = args[1]
        if not playerExists(id) then msg(source, 'Pelaaja (' .. id .. ') ei ole serverillä') return end

        addToAdminSit(source, id, args[2])
    end
end)

-- Poistaa pelaajan admin keissistä
RegisterCommand('adminkeissi_poista', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, 'se_adminsit') then
        if not args[1] then msg(source, 'Sinä et syöttänyt pelaajan id:tä') return end
        if not isNumber(args[1]) then msg(source, 'Pelaajan id pitää olla numero') return end

        local id = args[1]
        if not playerExists(id) then msg(source, 'Pelaaja (' .. id ..') ei ole serverillä') return end

        removeFromAdminSit(source, id)
    end
end)

-- Poistaa admin keissin
RegisterCommand('epäadminkeissi', function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, 'se_adminsit') then
        if not args[1] then msg(source, 'Sinä et syöttänyt keissi numeroa') return end
        if not isNumber(args[1]) then msg(source, 'Keissi numero pitää olla numero') return end

        local id = args[1]

        removeAdminSit(source, id)
    end
end)

RegisterCommand('keissinumero', function(source, args, rawCommand)
    if not isInAdminSit(source) then msg(source, 'Sinä et ole admin keississä') return end

    for k, v in pairs(players) do
        if v[2] == source then
            msg(source, 'Sinä olet keississä numero ' .. v[1])
            break
        end
    end
end)

-- Tarkistaa on syöte numero
-- Palauttaa true jos on
-- Palauttaa false jos ei ole
function isNumber(number)
    if tonumber(number) == nil then return false else return true end
end

-- Tarkistaa onko pelaaja admin keississä
-- Palauttaa true jos pelaaja on admin keississä
-- Palauttaa false jos pelaaja ei ole admin keississä
function isInAdminSit(id)
    local found = false
    for k, v in pairs(players) do
        if v[2] == id then found = true break end
    end

    return found
end

-- Tarkistaa onko pelaaja serverillä
-- Palauttaa true jos pelaaja on serverillä
-- Palauttaa false jos pelaaja ei ole serverillä
function playerExists(id)
    local ids = GetPlayers()
    local found = false

    for k, v in pairs(ids) do
        if tonumber(v) == tonumber(id) then
            found = true
            break
        end
    end

    return found
end

-- Tarkistaa onko admin keissi id numero olemassa
-- Palauttaa true jos on
-- Palauttaa false jos ei ole
function sitIdExists(id)
    local found = false

    for k, v in pairs(sitIds) do
        if v == tonumber(id) then found = true break end
    end
    return found
end

-- Tarkistaa onko sijainti käytetty
-- Palauttaa true jos on
-- Palauttaa false jos ei ole
function isLocationTaken(locationIndex)
    local found = false
    
    for k, v in pairs(takenLocations) do
        if locationIndex == v then found = true break end
    end
    return found
end

-- Luo uuden admin keissin ja lisää sinut ja valitsemasi pelaajan siihen
function addAdminSit(admin, player)
    if isInAdminSit(admin) then msg(admin, 'Sinä olet jo admin keississä') return end
    local location = findEmptyLocation()
    if not location then msg(admin, 'Tyhjiä paikkoja ei löytynyt') return end

    local x, y, z = table.unpack(Config.locations[location])

    local id = nil

    if #sitIds == 0 then 
        id = 0
    else
        id = math.max(unpack(sitIds)) + 1
    end

    SetEntityCoords(GetPlayerPed(admin), x, y, z, true, true, true, true)

    table.insert(players, {id, admin, GetEntityCoords(GetPlayerPed(admin))})
    table.insert(adminSits, {id, location})
    table.insert(sitIds, id)
    table.insert(takenLocations, location)

    addToAdminSit(admin, player, id)
end

-- Etsii käyttämättömän sijainnin configista
-- Palauttaa sijainnin indeksin jos se on käyttämätön
-- Palauttaa false jos käyttämättömiä sijainteja ei löytynyt
function findEmptyLocation()
    local found = false
    local location = nil

    for k, v in pairs(Config.locations) do
        if not isLocationTaken(k) then 
            found = true 
            location = k
            break
        end
    end

    if found then
        return location
    else
        return false
    end
end



-- Lisää pelaajan admin keissiin
function addToAdminSit(admin, player, id)
    if not sitIdExists(id) then msg(admin, 'Admin keissiä id (' .. id .. ') ei ole olemassa') return end
    if not playerExists(player) then msg(admin, 'Pelaaja (' .. player .. ') ei ole serverillä') return end
    if isInAdminSit(player) then msg(admin, 'Pelaaja (' .. player .. ') on jo admin keississä') return end

    local location = nil

    for k, v in pairs(adminSits) do
        if v[1] == id then
            location = v[2]
            break
        end
    end

    local x, y, z = table.unpack(Config.locations[location])

    table.insert(players, {id, player, GetEntityCoords(GetPlayerPed(player))})
    SetEntityCoords(GetPlayerPed(player), x, y, z, true, true, true, true)
end

-- Poistaa pelaajan admin keissistä ja palauttaa sen entiselle paikalleen
function removeFromAdminSit(admin, player)
    if not playerExists(player) then msg(admin, 'Pelaaja (' .. player ..') ei ole serverillä') return end
    if not isInAdminSit(player) then msg(admin, 'Pelaaja (' .. player .. ') ei ole admin keississä') return end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(player)))
    SetEntityCoords(GetPlayerPed(player), x, y, z, true, true, true, true)

    local playerIndex = nil

    for k, v in pairs(players) do
        if v[2] == player then playerIndex = k break end
    end

    table.remove(players, playerIndex)
end

-- Poistaa admin keissin ja palauttaa kaikki pelaajat entisille paikoilleen
function removeAdminSit(admin, id)
    if not sitIdExists(id) then msg(admin, 'Admin keissiä id (' .. id .. ') ei ole olemassa') return end

    local players_ = {}

    for k, v in pairs(players) do
        table.insert(players_, v)
    end

    for k, v in pairs(players_) do
        if v[1] == tonumber(id) then
            removeFromAdminSit(admin, v[2])
        end
    end

    local sitIdIndex = nil
    for k, v in pairs(sitIds) do
        if v == id then sitIdIndex = k break end
    end

    local adminSitIndex = nil
    for k, v in pairs(adminSits) do
        if tonumber(v[1]) == tonumber(id) then adminSitIndex = k break end
    end

    local location = adminSits[adminSitIndex][2]

    local locationIndex = nil
    for k, v in pairs(takenLocations) do
        if v == location then locationIndex = k break end
    end

    table.remove(takenLocations, locationIndex)
    table.remove(sitIds, sitIdIndex)
    table.remove(adminSits, adminSitIndex)
end

-- Chat viesti pelaajalle
function msg(id, msg)
    TriggerClientEvent('se_adminsit:msg', id, msg)
end

-- Jos pelaaja lähtee ja se on admin keississä niin se poistaa tiedon players pöydästä
AddEventHandler('playerDropped', function(reason)
    if isInAdminSit(source) then
        for k, v in pairs(players) do
            if v[1] == source then
                table.remove(players, k)
            end
        end
    end
end)
