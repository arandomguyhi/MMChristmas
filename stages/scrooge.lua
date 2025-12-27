luaDebugMode = true

local iconColore
local fadeActive = 0
local shit = false

local function fastCos(value)
    return callMethodFromClass('flixel.math.FlxMath', 'fastCos', {value})
end

setProperty('skipCountdown', true)

function onCreate()
    makeLuaSprite('bg', 'mario/scrooge/wahooo', -710, -250)
    addLuaSprite('bg')

    makeLuaSprite('bgColor') makeGraphic('bgColor', screenWidth*2.5, screenHeight*4, 'ffffff')
    screenCenter('bgColor')
    setProperty('bgColor.y', getProperty('bgColor.y') + 600)
    setBlendMode('bgColor', 'multiply')
    addLuaSprite('bgColor')

    makeLuaSprite('light', 'mario/scrooge/wahooollight', getProperty('bg.x'), getProperty('bg.y'))
    addLuaSprite('light')

    makeLuaSprite('vignette', 'mario/scrooge/vignette', getProperty('bg.x'), getProperty('bg.y'))
    screenCenter('vignette')
    scaleObject('vignette', 2, 2, false)
    setScrollFactor('vignette', 0, 0)
    addLuaSprite('vignette', true)

    makeLuaSprite('backboard', 'mario/scrooge/bed', getProperty('bg.x') + (getProperty('bg.width') / 2) - 325, getProperty('bg.y') + (getProperty('bg.height') / 2))
    addLuaSprite('backboard')

    createInstance('mx', 'objects.Character', {getProperty('boyfriend.x') + 500, getProperty('boyfriend.y') - 40, 'mx_christmas', false})
    setProperty('mx.danceEveryNumBeats', 4)
    addInstance('mx', true)

    createInstance('bed', 'objects.Character', {getProperty('boyfriend.x') - 370, getProperty('boyfriend.y') + 350, 'mario_christmas_bed', false})
    setProperty('bed.flipX', false)
    addInstance('bed', true)

    makeLuaSprite('awesome', 'mario/scrooge/fade')
    setScrollFactor('awesome', 0.1, 0.1)
    scaleObject('awesome', 2.2, 2.2, false)
    setBlendMode('awesome', 'add')
    setProperty('awesome.alpha', 0)
    addLuaSprite('awesome', true)

    makeLuaSprite('blue') makeGraphic('blue', screenWidth*2, screenHeight*2, '424B85')
    screenCenter('blue')
    setProperty('blue.y', getProperty('blue.y') + 600)
    setBlendMode('blue', 'multiply')
    addLuaSprite('blue', true)

    makeLuaSprite('window', 'mario/scrooge/window')
    setScrollFactor('window', 0, 0)
    scaleObject('window', 1.6, 1.6, false)
    addLuaSprite('window', true)

    makeLuaSprite('black') makeGraphic('black', screenWidth*2.5, screenHeight*4, '0D0529')
    screenCenter('black')
    setProperty('black.y', getProperty('black.y') + 600)
    setProperty('black.alpha', 0)
    addLuaSprite('black', true)
end

function onCreatePost()
    for _, fuck in pairs({'dad', 'boyfriend', 'gf', 'bed', 'mx'}) do
        setProperty(fuck..'.danceEveryNumBeats', 1)
        setProperty(fuck..'.skipDance', false)
    end

    setObjectOrder('backboard', getObjectOrder('gfGroup')+1)

    if shadersEnabled then
        initLuaShader('ColorSwap')
        setSpriteShader('gf', 'ColorSwap')
        setShaderFloat('gf', 'u_saturation', -50)
        setShaderFloat('gf', 'u_brightness', -50)
        setShaderFloat('gf', 'u_alpha', 0)

        initLuaShader('snowfall')
        makeLuaSprite('snow') setSpriteShader('snow', 'snowfall')
        setShaderFloat('snow', 'intensity', 500)
        runHaxeCode("camGame.setFilters([new ShaderFilter(game.getLuaObject('snow').shader)]);")
    end

    iconColore = getIconColor('dad')

    local skipcutscenes = false
    if not skipcutscenes then
        setProperty('isCameraOnForcedPos', true)

        setProperty('dad.y', getProperty('dad.y') + 1100)
        setProperty('gf.y', getProperty('gf.y') + 800)
        setProperty('mx.x', getProperty('mx.x') + 1000)
        setProperty('dad.alpha', 0)
    end
end

local fuck, lol = 0, 0

function onUpdate(elapsed)
    fuck = getSongPosition() / 1000
    lol = lol + 1

    if shadersEnabled then
        setShaderFloat('snow', 'time', fuck)
        setShaderInt('snow', 'amount', 25)
        setShaderFloat('snow', 'intensity', 0.25)
    end

    -- how i hate this modchart modifiers bruh
    for i = 0, 3 do
        local currentTarget = 'opponentStrums.members['..i..']'
        local songPos = (getSongPosition() / 1000)

        local swagWidth = getPropertyFromClass('objects.Note', 'swagWidth')
        local halfWidth = getPropertyFromClass('objects.Note', 'swagWidth') / 2

        local angle = songPos * (1 + 0.5)+i*((0*0.2)+0.2) + 1 * ((1*10)+10) / screenHeight
        drunk = poses[i+1] + 0.5 * (fastCos(angle) * halfWidth)
        tipsy = _G['defaultOpponentStrumY'..i] + 0.5 * (fastCos((songPos * ((0.5 * 1.2) + 1.2) + i*((0*1.8)+1.8)))*swagWidth*.4)

        setProperty(currentTarget..'.x', drunk)
        setProperty(currentTarget..'.y', tipsy)
    end
end

function onSpawnNote(id, noteData, noteType, isSustainNote)
    if noteType == 'MX Note' then end
    if noteType == 'Peach + MX' or noteType == 'MX + Luigi' or noteType == 'Luigi + Peach' then setPropertyFromGroup('notes', id, 'noAnimation', true) end
end

function goodNoteHit(_,noteData)
    playAnim('bed', getProperty('singAnimations')[noteData+1], true)
    setProperty('bed.holdTimer', 0)
end

function opponentNoteHit(_, noteData, noteType)
    if noteType == 'No Animation' then
        for _, c in pairs({'dad', 'gf', 'mx'}) do
            playAnim(c, getProperty('singAnimations')[noteData+1], true)
            setProperty(c..'.holdTimer', 0)
        end
    end

    if noteType == 'Peach + MX' or noteType == 'MX + Luigi' or noteType == 'Luigi + Peach' then
        local characters = {'dad', 'gf', 'mx'}
        if noteType == 'Peach + MX' then
            characters = {'dad', 'mx'}
        elseif noteType == 'MX + Luigi' then
            characters = {'gf', 'mx'}
        elseif noteType == 'Luigi + Peach' then
            characters = {'dad', 'gf'}
        end
        for _, c in pairs(characters) do
            playAnim(c, getProperty('singAnimations')[noteData+1], true)
            setProperty(c..'.holdTimer', 0)
        end
    end
end

function onBeatHit()
    for _, fuck in pairs({'bed', 'mx'}) do
        local anim = getProperty(fuck..'.animation.curAnim.name')
        if not anim:find('sing') then playAnim(fuck, 'idle', true) end
    end

    if fadeActive == 0 then
        -- nothing ig
    elseif fadeActive == 1 then
        setProperty('awesome.color', getColorFromHex(iconColore))
        callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('awesome')})
        setProperty('awesome.alpha', 0.6)
        doTweenAlpha('aweAlp', 'awesome', 0, 1, 'quadOut')
    end
end

function onStepHit()
    if curStep == 57 then
        runTimer('noforce', 0.3)
        onTimerCompleted = function(tag) if tag == 'noforce' then
            setProperty('isCameraOnForcedPos', false) end
        end
        startTween('hiPeach', 'dad', {y = getProperty('dad.y') - 1100, alpha = 1}, 1, {ease = 'quartOut'})
    end

    if curStep == 631 then
        startTween('mxX', 'mx', {x = getProperty('mx.x') - 1000}, 1, {ease = 'elasticOut'})
    end

    if curStep == 1024 then
        setProperty('isCameraOnForcedPos', true)
        setProperty('camZooming', false)
        callMethod('camFollow.setPosition', {780, 1044})
        startTween('camZooom', 'game', {defaultCamZoom = 0.7}, 4, {ease = 'quadInOut'})
        doTweenAlpha('blackie', 'black', 0.325, 5, 'quadInOut')
    end

    if curStep == 1056 then
        startTween('camZom', 'game', {defaultCamZoom = 0.6}, 4, {ease = 'quadInOut'})
        startTween('camY', 'camFollow', {y = getProperty('camFollow.y') - 300}, 9, {ease = 'quadOut', onComplete = 'unblack'})
        unblack = function()
            setProperty('isCameraOnForcedPos', false)
            doTweenAlpha('unblackie', 'black', 0, 1)
        end

        runHaxeCode([[
            FlxTween.num(0, 1, 9, {ease: FlxEase.quadInOut, onUpdate: (fuck)->{ callOnLuas('setShaderFloat', ['gf', 'u_alpha', fuck.value]); }});
            FlxTween.num(-50, 0, 9, {ease: FlxEase.quadInOut, onUpdate: (fuck)->{ callOnLuas('setShaderFloat', ['gf', 'u_saturation', fuck.value]); }});
            FlxTween.num(-50, 0, 9, {ease: FlxEase.quadInOut, onUpdate: (fuck)->{ callOnLuas('setShaderFloat', ['gf', 'u_brightness', fuck.value]); }});
        ]])

        startTween('IHYL', 'gf', {y = getProperty('gf.y') - 800}, 9, {ease = 'quadOut'})
    end
end

local lol = false
function onEvent(eventName, value1, value2)
    if eventName == 'Triggers Universal' then
        if value1 == 'evil' then
            shit = true
            setProperty('defaultCamZoom', 0.5)
            setProperty('isCameraOnForcedPos', true)
            callMethod('camFollow.setPosition', {getProperty('bg.x') + (getProperty('bg.width') / 2), getProperty('bg.y') + (getProperty('bg.height') / 2) - 150})
        elseif value1 == 'normal' then
            shit = false
            setProperty('isCameraOnForcedPos', false)
        elseif value1 == 'change owner' then
            if value2 == 'peach' then
                setVar('opponentStrumOwner', 'dad')
                iconColore = getIconColor('dad')
            elseif value2 == 'luigi' then
                setVar('opponentStrumOwner', 'gf')
                if not lol then setProperty('iconP2.shader', getProperty('gf.shader')) end
                lol = true
                iconColore = getIconColor('gf')
            elseif value2 == 'mx' then
                setVar('opponentStrumOwner', 'mx')
                iconColore = getIconColor('mx')
            end

            callMethod('iconP2.changeIcon', {getProperty(getVar('opponentStrumOwner')..'.healthIcon')})
            setHealthBarColors(
                getIconColor(getVar('opponentStrumOwner')),
                getIconColor('boyfriend')
            )
        elseif value1 == 'fade active' then
            fadeActive = 1
        elseif value1 == 'fade inactive' then
            fadeActive = 0
        elseif value1 == 'wahoo bg fade' then
            if value2 == 'peach entrance' then
                setProperty('bgColor.color', getColorFromHex('A17772'))
                doTweenAlpha('bgColAlp', 'bgColor', 1, 2, 'quadInOut')
            elseif value2 == 'peach gone' then
                callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('bgColor')})
                doTweenAlpha('bgColAlp', 'bgColor', 0, 4, 'expoOut')
            elseif value2 == 'mx entrance' then
                setProperty('bgColor.color', getColorFromHex('A84F77'))
                doTweenAlpha('bgColAlp', 'bgColor', 1, 2, 'quadInOut')
            elseif value2 == 'mx gone' then
                callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('bgColor')})
                doTweenAlpha('bgColAlp', 'bgColor', 0, 2, 'expoOut')
            elseif value2 == 'luigi entrance' then
                setProperty('bgColor.color', getColorFromHex('654FA8'))
                doTweenAlpha('bgColAlp', 'bgColor', 1, 6, 'quadInOut')
            elseif value2 == 'luigi gone' then
                callMethodFromClass('flixel.tweens.FlxTween', 'cancelTweensOf', {instanceArg('bgColor')})
                doTweenAlpha('bgColAlp', 'bgColor', 0, 3, 'expoOut')
            elseif value2 == 'finale' then
                setProperty('bgColor.color', getColorFromHex('594BAD'))
                doTweenAlpha('bgColAlp', 'bgColor', 1, 4, 'expoOut')
                runTimer('fadeFin', 1) onTimerCompleted = function(tag) if tag == 'fadeFin' then
                    cameraFade('camGame', '000000', 1.5) end
                end
            end
        end
    end
end

function onSongStart()
    callMethod('camGame.snapToTarget', {''})
    cameraFlash('camGame', '000000', 6, true, false)
    setProperty('camGame.zoom', 1)
    startTween('camZoom', 'camGame', {zoom = 0.65}, 6, {ease = 'quadOut'})

    startTween('winScale', 'window.scale', {x = 4, y = 4}, 6, {ease = 'expoIn'})
    startTween('winAlpha', 'window', {alpha = 0}, 2, {startDelay = 4, ease = 'quadIn'})
    startTween('bluAlpha', 'blue', {alpha = 0}, 2, {startDelay = 4, ease = 'quadIn'})
end

function onCountdownStarted()
    for i = 0,3 do
	setProperty('playerStrums.members['..i..'].x', 412 + (112 * i))
        setProperty('opponentStrums.members['..i..'].x', 412 + (112 * i))
        setProperty('opponentStrums.members['..i..'].alpha', 0.5)
    end
    setPropertyFromGroup('opponentStrums', 0, 'x', getPropertyFromGroup('opponentStrums', 0, 'x')-375)
    setPropertyFromGroup('opponentStrums', 1, 'x', getPropertyFromGroup('opponentStrums', 1, 'x')-350)
    setPropertyFromGroup('opponentStrums', 2, 'x', getPropertyFromGroup('opponentStrums', 2, 'x')+350)
    setPropertyFromGroup('opponentStrums', 3, 'x', getPropertyFromGroup('opponentStrums', 3, 'x')+375)

    poses = {getPropertyFromGroup('opponentStrums', 0, 'x'), getPropertyFromGroup('opponentStrums', 1, 'x'),
        getPropertyFromGroup('opponentStrums', 2, 'x'), getPropertyFromGroup('opponentStrums', 3, 'x')}
end

function getIconColor(chr)
    return rgbToHex(getProperty(chr..'.healthColorArray'))
end
function rgbToHex(array)
    return string.format('%.2x%.2x%.2x', array[1], array[2], array[3])
end