cfg = {}

-- ustaw na true jezeli chcesz logi o /odbierz

cfg.Logs = true
cfg.Webhook = 'https://discord.com/api/webhooks/'

-- dajcie na true jezeli macie bronie pod item (jesli nie macie to nie musicie zmieniac w weapon = 'weapon_pistol', skrypt to robi za was.)
cfg.weaponsync = true

-- Co ile dni mozna odbierac starter-pack
cfg.days = 1

cfg.Itemy = {

    list = {
        -- jezeli nie ustawisz amount w itemie to graczowi da po prostu 1 sztuke danego itemu
        { item = "bread", amount=25},
        { item = "water", amount=25},
        { item = "redbull", amount=25},
        { item = "pistol_ammo", amount=250},
        { item = "phone"},
        { weapon = 'pistol', amount = 1}
    }
    

}