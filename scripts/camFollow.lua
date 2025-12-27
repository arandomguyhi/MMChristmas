setVar('camMoveOffset', 15)
setVar('camFollowChars', true)

local function getCamPos(char)
    local _char = char

    if char == 'gf' then _char = 'girlfriend' end
    if char == 'dad' then _char = 'opponent' end

    -- gf logic not needed rn i guess
    -- charCameraOffset too

    local bro = getProperty(char..'.cameraPosition[0]')
    return {
        x = getMidpointX(char) + (char == 'boyfriend' and -100 or 150) + (char == 'boyfriend' and -bro or bro),
        y = getMidpointY(char) - 100 + getProperty(char..'.cameraPosition[1]')
    }
end

function onSectionHit() setVar('lastFocus', mustHitSection and getVar('playerStrumOwner') or getVar('opponentStrumOwner')) end
function onUpdate()
    if getProperty('isCameraOnForcedPos') then return end

    if getVar('camFollowChars') then
        if getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singLEFT' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x - getVar('camMoveOffset'), getCamPos(getVar('lastFocus')).y}) angle = -getVar('camAngleOffset')
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singDOWN' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y + getVar('camMoveOffset')})
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singUP' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y - getVar('camMoveOffset')})
        elseif getProperty(getVar('lastFocus')..'.animation.curAnim.name') == 'singRIGHT' then
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x + getVar('camMoveOffset'), getCamPos(getVar('lastFocus')).y}) angle = getVar('camAngleOffset')
        else
            callMethod('camFollow.setPosition', {getCamPos(getVar('lastFocus')).x, getCamPos(getVar('lastFocus')).y}) angle = 0
        end
    end
end