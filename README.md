# Images 

## FOV 1st person Car
Driver:
![image](https://github.com/user-attachments/assets/a1d41139-0131-4b20-85ab-d97034338c0d)

Passenger:
![image](https://github.com/user-attachments/assets/39bd59f7-9372-4dd9-9441-dc5e16ad7cbb)


## Blur on your back

![image](https://github.com/user-attachments/assets/509ea5f4-d853-4780-ac6e-de4ab7db0e04)

## Myopia 

without Glasses:
![image](https://github.com/user-attachments/assets/9d66003e-bf49-42fc-ac18-6a7fc61f39a7)

With Glasses:

![image](https://github.com/user-attachments/assets/b435f3f7-9d3a-4a12-b76d-ea4283fd0b24)

## Resmon 

![image](https://github.com/user-attachments/assets/c4359860-61c1-445e-a96a-f2ce204a02fc)


## Important 

EN: If you use qb-radialmenu, you must make the following change for the glasses to work properly
ESP: Si usas qb-radialmenu, debes realizar el siguiente cambio para que funcione bien las gafas

Line/Linea [908] - qb-radialmenu/client/clothing.lua

```
function ToggleProps(whic)
    local which = whic
    if type(whic) == 'table' then
        which = tostring(whic.id)
    end
    Wait(50)
    if Cooldown then return end

    local Prop = Props[which]
    local Ped = PlayerPedId()
    local Cur = {
        Id = Prop.Prop,
        Ped = Ped,
        Prop = GetPedPropIndex(Ped, Prop.Prop),
        Texture = GetPedPropTextureIndex(Ped, Prop.Prop),
    }

    local isGlasses = Prop.Prop == 1

    if not Prop.Variants then
        if Cur.Prop ~= -1 then
            PlayToggleEmote(Prop.Emote.Off, function()
                LastEquipped[which] = Cur
                ClearPedProp(Ped, Prop.Prop)

                if isGlasses then
                    TriggerServerEvent("fzt_fov:updateGlasses", 0, 0)
                end
            end)
            return true
        else
            local Last = LastEquipped[which] -- Si el jugador ya quitó el prop, vuélvelo a equipar
            if Last then
                PlayToggleEmote(Prop.Emote.On, function()
                    SetPedPropIndex(Ped, Prop.Prop, Last.Prop, Last.Texture, true)

                    if isGlasses then
                        TriggerServerEvent("fzt_fov:updateGlasses", Last.Prop, Last.Texture)
                    end
                end)
                LastEquipped[which] = false
                return true
            end
        end
        Notify(Lang:t('info.nothing_to_remove'))
        return false
    else
        local Gender = IsMpPed(Ped)
        if not Gender then
            Notify(Lang:t('info.wrong_ped'))
            return false
        end
        variations = Prop.Variants[Gender]
        for k, v in pairs(variations) do
            if Cur.Prop == k then
                PlayToggleEmote(Prop.Emote.On, function()
                    SetPedPropIndex(Ped, Prop.Prop, v, Cur.Texture, true)

                    -- Actualizar metadatos y notificar al cliente si son lentes
                    if isGlasses then
                        TriggerServerEvent("fzt_fov:updateGlasses", v, Cur.Texture)
                    end
                end)
                return true
            end
        end
        Notify(Lang:t('info.no_variants'))
        return false
    end
end

```


## License/Licencia
EN:
This project is protected under the [Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0) License](LICENSE).  
It is strictly prohibited to sell or monetize this software.  
For more details, see the [LICENSE](LICENSE) file.

ESP:
Este proyecto está protegido bajo la [Licencia Creative Commons Attribution-NonCommercial 4.0 International (CC-BY-NC-4.0)](LICENSE).  
Está estrictamente prohibido vender o monetizar este software.  
Para más detalles, consulta el archivo [LICENSE](LICENSE).
