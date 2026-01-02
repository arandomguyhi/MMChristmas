-- this codes ass, dont take this as n example :broken_heart:

local stageDir = 'mario/salami/'

local selected_character = ''
local selecting_char = false
local somariPlays = false

local bgFlash = 0
local cameosRandom = 0

local pause = false -- i hate this engine sm

local totalElapsed = 0

local function lerp(a,b,t)
    return a+(b-a)*t
end
local function bound(v,min,max)
    return math.max(min,math.min(max,v))
end

setProperty('skipCountdown', true)
setVar('allowOwner', false)

function onCreate()
    setPropertyFromClass('states.PlayState', 'SONG.arrowSkin', 'Salami_Noteskin')
    setProperty('grpNoteSplashes.visible', false)

    makeLuaSprite('bg', stageDir..'bg', -10, -120)
    addLuaSprite('bg')

    makeLuaSprite('moon', stageDir..'moon', getProperty('bg.x') + 290, getProperty('bg.y'))
    setScrollFactor('moon', 0.4, 1)
    addLuaSprite('moon')

    createInstance('cloud', 'flixel.addons.display.FlxBackdrop', {nil, 0x01, 0})
    loadGraphic('cloud', stageDir..'cloud')
    setScrollFactor('cloud', 0.45, 1)
    setProperty('cloud.y', getProperty('moon.y') - 10)
    addLuaSprite('cloud')

    makeLuaSprite('skyfade') makeGraphic('skyfade', screenWidth*1, screenHeight*1, 'ffffff')
    screenCenter('skyfade')
    setProperty('skyfade.y', -200)
    setBlendMode('skyfade', 'add')
    addLuaSprite('skyfade')

    makeLuaSprite('castle', stageDir..'castle', getProperty('moon.x') - 70, getProperty('moon.y'))
    setScrollFactor('castle', 0.5, 1)
    addLuaSprite('castle')

    makeLuaSprite('mountain', stageDir..'mountain', 70, -140)
    setScrollFactor('mountain', 0.8, 1)
    addLuaSprite('mountain')

    makeLuaSprite('snow2', stageDir..'snow2', -10, -120)
    setScrollFactor('snow2', 0.98, 1)
    addLuaSprite('snow2')

    makeLuaSprite('house', stageDir..'house', getProperty('snow2.x'), getProperty('snow2.y'))
    addLuaSprite('house')

    makeLuaSprite('crisp_rat', stageDir..'pratt', getProperty('snow2.x'), getProperty('snow2.y'))
    addLuaSprite('crisp_rat')

    makeLuaSprite('tree', stageDir..'tree', 20, -10)
    addLuaSprite('tree')

    makeLuaSprite('snow', stageDir..'snow', getProperty('snow2.x'), getProperty('snow2.y'))
    addLuaSprite('snow', true)

    makeLuaSprite('fg', stageDir..'fg', getProperty('snow.x'), getProperty('snow.y'))
    addLuaSprite('fg', true)
end

local salami_camera_offsets = {0, 20}

function onCreatePost()
    setProperty('camGame.pixelPerfectRender', true)

    setProperty('camHUD.height', 880)
    setProperty('camHUD.zoom', (screenHeight/880))
    setProperty('camHUD.y', (screenHeight-880)/2)

    setProperty('camGame.zoom', (screenHeight/880)*6)

    salami_camera_offsets[1] = getProperty('snow.width') / 2 - 18

    setProperty('isCameraOnForcedPos', true)
    callMethod('camFollow.setPosition', {salami_camera_offsets[1], salami_camera_offsets[2]})
    callMethod('camGame.snapToTarget', {''})

    runHaxeCode([[
        for (member in game.members) {
            if (Std.isOfType(member, FlxSprite) && member.camera == game.camGame)
                member.antialiasing = false;
        }
    ]])

    setVar('camDisplacement', 0)

    makeAnimatedLuaSprite('gb', stageDir..'cameos/GB', 20, 33)
    addAnimationByPrefix('gb', 'idle', 'fat_gif', 24, true)
    playAnim('gb', 'idle')
    setProperty('gb.antialiasing', false)
    addLuaSprite('gb', true)

    makeAnimatedLuaSprite('omega', stageDir..'cameos/OmegaFake', 20, 33)
    addAnimationByPrefix('omega', 'idle', 'omega_gif', 24, true)
    playAnim('omega', 'idle')
    setProperty('omega.antialiasing', false)
    addLuaSprite('omega', true)

    makeAnimatedLuaSprite('mrV', stageDir..'cameos/Mr V', 20, 45)
    addAnimationByPrefix('mrV', 'idle', 'bald_gif', 24, true)
    playAnim('mrV', 'idle')
    setProperty('mrV.antialiasing', false)
    addLuaSprite('mrV', true)

    makeAnimatedLuaSprite('jammer', stageDir..'cameos/jammer', 20, 45)
    addAnimationByPrefix('jammer', 'idle', 'jammer_gif', 24, true)
    playAnim('jammer', 'idle')
    setProperty('jammer.antialiasing', false)
    addLuaSprite('jammer', true)

    makeAnimatedLuaSprite('joel', stageDir..'cameos/Joel', 20, 29)
    addAnimationByPrefix('joel', 'idle', 'joel_gif', 24, true)
    playAnim('joel', 'idle')
    setProperty('joel.antialiasing', false)
    addLuaSprite('joel', true)

    makeLuaSprite('skyfadeLine') makeGraphic('skyfadeLine', screenWidth*2, 100, '000000')
    setObjectCamera('skyfadeLine', 'camHUD') screenCenter('skyfadeLine', 'X')
    addLuaSprite('skyfadeLine')

    makeLuaText('select_character_text', 'SELECT CHARACTER:', screenWidth, 0, 20)
    setTextFont('select_character_text', 'mariones.ttf')
    setTextSize('select_character_text', 50) setTextAlignment('select_character_text', 'center')
    setProperty('select_character_text.antialiasing', false)
    setObjectCamera('select_character_text', 'camHUD')
    addLuaText('select_character_text')
    setProperty('select_character_text.x', screenWidth / 2 - getProperty('select_character_text.width') / 2)

    makeLuaSprite('skyfadeLine2', nil, 0, 775) makeGraphic('skyfadeLine2', screenWidth*2, 190, '000000')
    setObjectCamera('skyfadeLine2', 'camHUD') screenCenter('skyfadeLine2', 'X')
    addLuaSprite('skyfadeLine2')

    makeLuaText('character_text', 'SOMARI', screenWidth, 0, getProperty('skyfadeLine2.y')+10)
    setTextFont('character_text', 'mariones.ttf') setTextSize('character_text', 67)
    setTextAlignment('character_text', 'center')
    setProperty('character_text.antialiasing', false)
    setObjectCamera('character_text', 'camHUD')
    addLuaText('character_text')
    setProperty('character_text.x', screenWidth / 2 - getProperty('character_text.width') / 2)

    makeLuaSprite('miss_icon', stageDir..'miss_icon', 1020-20, 795)
    scaleObject('miss_icon', 9, 9)
    setProperty('miss_icon.antialiasing', false)
    setObjectCamera('miss_icon', 'camHUD')
    addLuaSprite('miss_icon')
    if downScroll then setProperty('miss_icon.y', 18) end

    makeLuaText('miss_amt', '00', 0, getProperty('miss_icon.x') + 80, getProperty('miss_icon.y')-10)
    setTextFont('miss_amt', 'mariones.ttf') setTextSize('miss_amt', 70)
    setProperty('miss_amt.antialiasing', false)
    setObjectCamera('miss_amt', 'camHUD')
    addLuaText('miss_amt')

    makeLuaText('scoreText', '', 0, 30, getProperty('miss_amt.y'))
    setTextFont('scoreText', 'mariones.ttf') setTextSize('scoreText', 70)
    setProperty('scoreText.antialiasing', false)
    setObjectCamera('scoreText', 'camHUD')
    addLuaText('scoreText')

    setObjectOrder('miss_amt', getObjectOrder('noteGroup')-1)
    setObjectOrder('scoreText', getObjectOrder('noteGroup')-1)

    for _,item in pairs({'scoreTxt', 'timeTxt', 'timeBar', 'iconP2', 'iconP1', 'healthBar',
        'miss_icon', 'miss_amt', 'scoreText'}) do
             setProperty(item..'.visible', false)
    end

    makeLuaSprite('cu') makeGraphic('cu', 115, screenHeight, '000000')
    setObjectCamera('cu', 'camOther')
    addLuaSprite('cu')

    makeLuaSprite('cu2',nil,screenWidth-115,0) makeGraphic('cu2', 115, screenHeight, '000000')
    setObjectCamera('cu2', 'camOther')
    addLuaSprite('cu2')

    change_char_selection_text()
end

local cameo_speed = 35
local canMove = true

local extrazero = ''
function onUpdate(elapsed)
    setProperty('camZooming', false)

    setProperty('camGame.zoom', lerp((screenHeight/880)*6, getProperty('camGame.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))
    setProperty('camHUD.zoom', lerp((screenHeight/880), getProperty('camHUD.zoom'), bound(1 - (elapsed * 3.125 * 1 * playbackRate), 0, 1)))

    setProperty('cloud.x', getProperty('cloud.x') + 0.05)

    if misses < 10 then
        extrazero = '0'
    else
        extrazero = ''
    end
    setTextString('miss_amt', extrazero..getProperty('songMisses'))

    if selecting_char then
        if keyJustPressed('LEFT') then selected_character = 'somari' end
        if keyJustPressed('RIGHT') then selected_character = 'granddad' end
        if keyJustPressed('RIGHT') or keyJustPressed('LEFT') then change_char_selection_text() end
        if keyboardJustPressed('ENTER') and selected_chararacter ~= '' then start_song()
        elseif selected_character == '' then onMoveCamera('') end
    end

    if curSection > 1 and not selecting_char and canMove then
       setProperty('isCameraOnForcedPos', true)
       onMoveCamera(mustHitSection and 'bf' or 'dad')
    end

    if cameosRandom == 0 then
        for _,chars in pairs({'gb', 'omega', 'mrV', 'jammer', 'joel'}) do
            setProperty(chars..'.x', -50)
            setProperty(chars..'.velocity.x', 0)
        end
    elseif cameosRandom == 1 then
        setProperty('gb.velocity.x', cameo_speed)
    elseif cameosRandom == 2 then
        setProperty('omega.velocity.x', cameo_speed)
    elseif cameosRandom == 3 then
        setProperty('mrV.velocity.x', cameo_speed)
    elseif cameosRandom == 4 then
        setProperty('joel.velocity.x', cameo_speed)
    elseif cameosRandom == 5 then
        setProperty('jammer.velocity.x', cameo_speed)
    end

    for _,chars in pairs({'gb', 'omega', 'mrV', 'jammer', 'joel'}) do
        if getProperty(chars..'.x') > 250 then
            cameosRandom = 0
        end
    end

    totalElapsed = totalElapsed + elapsed*-1
    setProperty('jammer.y', 40 + (2 * math.sin(totalElapsed*1.5)))

    if bgFlash == 0 then
        setProperty('skyfade.color', 0x000000)
    elseif bgFlash == 1 then
        setProperty('skyfade.color', 0x130921)
    elseif bgFlash == 2 then
        setProperty('skyfade.color', 0x331B3D)
    elseif bgFlash == 3 then
        setProperty('skyfade.color', 0x9180BD)
    elseif bgFlash == 4 then
        setProperty('skyfade.color', 0xBFB1DE)
    elseif bgFlash == 5 then
        setProperty('skyfade.color', 0xD8DEF2)
    elseif bgFlash == 6 then
        setProperty('skyfade.color', 0xE3E4FF)
    elseif bgFlash == 7 then
        setProperty('skyfade.color', 0xE3E4FF)
    end
end

function start_song()
    selecting_char = false
    runTimer('starta', 0.01)

    for _,item in pairs({'miss_icon', 'miss_amt', 'scoreText'}) do
        setProperty(item..'.visible', true)
    end
    for _,item in pairs({'select_character_text', 'character_text'}) do
        setProperty(item..'.visible', false)
    end

    onTimerCompleted = function(tag) if tag == 'starta' then
        startCountdown()
        if selected_character == 'somari' then
            somariPlays = true
            for i = 0, 3 do
                setProperty('opponentStrums.members['..i..'].x', _G['defaultPlayerStrumX'..i])
                setProperty('playerStrums.members['..i..'].x', _G['defaultOpponentStrumX'..i])
            end
        end end
    end
end

function onUpdatePost()
    setTextString('scoreText', formatMario(getProperty('songScore'), 6))
    setProperty('health', 2)

    for i = 0, getProperty('notes.length')-1 do
        if getProperty('notes.members['..i..'].isSustainNote') or somariPlays then
            setProperty('notes.members['..i..'].noAnimation', true)
        end
    end
end

function formatMario(num, size)
    if 0 > num then num = 0 end
    local finalVal = ''
    local stringNum = tostring(math.floor(num))

    for i = 0, size-#stringNum do
        finalVal = finalVal..'0'
    end

    finalVal = finalVal..stringNum
    return finalVal
end

local focused_on = ''
function onMoveCamera(focus)
    if focus == 'dad' then
        setProperty('camFollow.x', salami_camera_offsets[1]-20)
    elseif focus == 'bf' then
        setProperty('camFollow.x', salami_camera_offsets[1]+20)
    else
        setProperty('camFollow.x', salami_camera_offsets[1])
    end

    setProperty('camFollow.y', salami_camera_offsets[2])

    focused_on = focus
end

allowCountdown = false
function onStartCountdown()
    if not allowCountdown then allowCountdown = true
        selecting_char = true
        selected_char = ''

        return Function_Stop
    end
    return Function_Continue
end

function change_char_selection_text()
    onMoveCamera(selected_character == 'somari' and 'dad' or 'bf')

    setTextString('character_text', selected_character:upper())
    setProperty('character_text.x', screenWidth / 2 - getProperty('character_text.width') / 2)
end

function onSpawnNote(id, noteData, noteType, isSustainNote)
    if not somariPlays then return end
    setPropertyFromGroup('notes', id, 'noAnimation', true)
    if getPropertyFromGroup('notes', id, 'mustPress') then
        setPropertyFromGroup('notes', id, 'mustPress', false)
    else
        setPropertyFromGroup('notes', id, 'mustPress', true)
    end
end

function opponentNoteHit(id,data,type,sus)
    if sus then setProperty('dad.holdTimer', 0) end
    if not somariPlays then return end
    playAnim('boyfriend', getProperty('singAnimations')[data+1], true)
    setProperty('boyfriend.holdTimer', 0)
end

function goodNoteHit(id,data,type,sus)
    if sus then setProperty('boyfriend.holdTimer', 0) end
    if not somariPlays then return end
    playAnim('dad', getProperty('singAnimations')[data+1], true)
    setProperty('dad.holdTimer', 0)
end

function noteMiss(id,data,type,sus)
    playAnim('boyfriend', 'idle')
    if not somariPlays then return end
    playAnim('dad', getProperty('singAnimations')[data+1]..'miss', true)
    setProperty('dad.holdTimer', 0)
end

local seenGB = false
local seenOmega = false
local seenV = false

function onEvent(eventName, value1, value2)
    if eventName == 'Triggers Universal' then
        if value1 == 'cameos salami' then
            local random_num = getRandomInt(1, 115)
            if 1 >= random_num then
                cameosRandom = 5
            elseif 15 >= random_num then
                cameosRandom = 4
            else
                if seenGB and seenOmega and seenV then
                    cameosRandom = getRandomInt(1, 3)
                    return
                end

                if seenGB and seenOmega then cameosRandom = 3
                elseif seenGB and seenV then cameosRandom = 2
                elseif seenOmega and seenV then cameosRandom = 1
                elseif seenGB then cameosRandom = getRandomInt(2, 3)
                elseif seenOmega then cameosRandom = getRandomBool(50) and 1 or 3
                elseif seenV then cameosRandom = getRandomInt(1, 2)
                else cameosRandom = getRandomInt(1, 3) end

                if cameosRandom == 1 then
                    seenGB = true
                elseif cameosRandom == 2 then
                    seenOmega = true
                elseif cameosRandom == 3 then
                    seenV = true
                end
            end
        elseif value1 == 'bg flash' then
            bgFlash = 7
        end
    end

    if eventName == 'Camera Follow Pos' then
        if value1 == '' and value2 == '' then
            canMove = true
            setProperty('isCameraOnForcedPos', true)
            onMoveCamera(focused_on)
        else canMove = false
        end
    end
end

function onStepHit()
    if bgFlash >= 1 then
        bgFlash = bgFlash - 1
    end
end