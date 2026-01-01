luaDebugMode = true

function onCreate()
    setPropertyFromClass('states.PlayState', 'SONG.disableNoteRGB', true)
    if songName:find('salami') then return end -- not using exceptions atp

    setPropertyFromClass('states.PlayState', 'SONG.arrowSkin', 'Mario_NOTE_assets')
    setPropertyFromClass('states.PlayState', 'SONG.splashSkin', 'noteSplashes')

    local ratings_strings = {'epic', 'sick', 'good', 'bad', 'shit'}

    makeLuaSprite('rating_box', 'ratings/ratings_box')
    updateHitbox('rating_box')
    setProperty('rating_box.x', screenWidth)
    setProperty('rating_box.y', downScroll and 20 or screenHeight - 150)
    setObjectCamera('rating_box', 'camHUD')
    addLuaSprite('rating_box')

    makeLuaSprite('ratings',nil,0,0) loadGraphic('ratings', 'ratings/ratings', 315, 56)
    updateHitbox('ratings')
    setObjectCamera('ratings', 'camHUD')
    addLuaSprite('ratings')
    for i = 0, #ratings_strings do
        addAnimation('ratings', ratings_strings[i+1], {i}, 24, true)
    end

    makeLuaText('comboTxt', '999', screenWidth, 0, 20)
    setTextSize('comboTxt', 24)
    setTextFont('comboTxt', 'mariones.ttf')
    setTextColor('comboTxt', 'ffffcc')
    setProperty('comboTxt.antialiasing', false)
    addLuaText('comboTxt')
end

function onCountdownStarted()
    setProperty('comboGroup.visible', false)
    setProperty('botplayTxt.visible', false)

    if songName:find('salami') then return end

    makeLuaSprite('luigi_icon', 'modstuff/luigi/luigi')
    setGraphicSize('luigi_icon', 90)
    setProperty('luigi_icon.x', screenWidth/2 - getProperty('luigi_icon.width')/2)
    setProperty('luigi_icon.y', downScroll and screenHeight - getProperty('luigi_icon.height')-60 or 60)
    setObjectCamera('luigi_icon', 'camHUD')
    addLuaSprite('luigi_icon')

    loadGraphic('healthBar.bg', 'healthBarNEW')
    screenCenter('healthBar.bg', 'X')
    setProperty('healthBar.bg.offset.x', 45)
    setProperty('healthBar.bg.offset.y', 6.25)

    setTextFont('scoreTxt', 'mario2.ttf')
    setTextColor('scoreTxt', 'F42626')

    setTextFont('timeTxt', 'mario2.ttf')
    setTextSize('timeTxt', 22)
    setTextColor('timeTxt', 'F42626')
    setProperty('timeTxt.borderSize', 2)
    setProperty('timeBar.leftBar.color', 0xFF0000)
end

local rating_dropped = false

function onPopUpScore(rate)
    if songName:find('salami') then return end

    playAnim('ratings', rate)

    rate_time_amt = stepCrochet / 70
    cancelTimer('rating_timer')
    cancelTween('rating_tween_out')

    if not rating_dropped then
        rating_dropped = true
        cancelTween('rating_tween')

        local target_x = screenWidth - getProperty('rating_box.width') + 20
        doTweenX('rating_tween', 'rating_box', target_x, 0.8, 'expoOut')
    end

    runTimer('rating_timer', rate_time_amt) onTimerCompleted = function(tag) if tag == 'rating_timer' then
        move_box_back() end
    end
end

function move_box_back()
    rating_dropped = false
    doTweenX('rating_tween_out', 'rating_box', screenWidth, 1.1, 'smoothStepInOut')
end

function onUpdate(elapsed)
    if songName:find('salami') then return end

    setProperty('luigi_icon.visible', botPlay)

    setProperty('ratings.x', getProperty('rating_box.x') + 67)
    setProperty('ratings.y', getProperty('rating_box.y') + 35)

    setTextSize('scoreTxt', 16)

    setTextString('comboTxt', combo)
    setProperty('comboTxt.x', getProperty('ratings.x') + getProperty('ratings.width') / 2 - getProperty('comboTxt.width') / 2)
    setProperty('comboTxt.y', getProperty('ratings.y') + getProperty('ratings.height') - 2)
end

function goodNoteHit(id)
    onPopUpScore(getPropertyFromGroup('notes', id, 'rating'))
end

function onEvent(eventName, value1, value2)
    if eventName == 'Ocultar HUD' then
        local bruhHUD = tonumber(value1)
        if type(bruhHUD) ~= 'number' then
            bruhHUD = 0
        end

        if bruhHUD == 0 then
            doTweenAlpha('OCHUDTween', 'camHUD', 0, 0.5, 'quadInOut')
        elseif bruhHUD == 1 then
            doTweenAlpha('OCHUDTween', 'camHUD', 1, 0.001, 'quadInOut')
        elseif bruhHUD == 2 then
            doTweenAlpha('OCHUDTween', 'camHUD', 1, 0.5, 'quadInOut')
        end
    end
end