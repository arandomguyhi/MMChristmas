setVar('opponentStrumOwner', 'dad')
setVar('playerStrumOwner', 'boyfriend')

function onUpdatePost()
    for i = 0, getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', i, 'mustPress') then
            setPropertyFromGroup('notes', i, 'noAnimation', getVar('playerStrumOwner') ~= 'boyfriend')
        else
            setPropertyFromGroup('notes', i, 'noAnimation', getVar('opponentStrumOwner') ~= 'dad')
        end
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if getVar('opponentStrumOwner') == 'dad' then return end

    playAnim(getVar('opponentStrumOwner'), getProperty('singAnimations')[noteData+1], true)
    setProperty(getVar('opponentStrumOwner')..'.holdTimer', 0)
end

function onEvent(eventName, value1, value2)
    if eventName == 'Set Cam Zoom' then
        setProperty('defaultCamZoom', tonumber(value1))
    end

    if eventName == 'HUD Fade' then
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {intanceArg('camHUD'), {'alpha'}})

        local leAlpha = tonumber(value1)
        if type(leAlpha) ~= 'number' then leAlpha = 1 end

        local duration = tonumber(value2)
        if type(duration) ~= 'number' then duration = 1 end

        if duration > 0 then
            doTweenAlpha('camHUDAlp', 'camHUD', leAlpha, duration)
        else
            setProperty('camHUD.alpha', leAlpha)
        end
    end
end