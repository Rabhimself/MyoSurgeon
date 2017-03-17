scriptId = 'com.myosurgeon'  
scriptTitle = "MyoSurgeon"  
scriptDetailsUrl = ""  

mouseDown = false

function onForegroundWindowChange(app, title)
    local uppercaseApp = string.upper(app)
    return platform == "Windows" and uppercaseApp == "SS2013.EXE"
end

function onPoseEdge(pose, edge)
    if pose == "fist" and edge == "on" then doGrab()
    elseif pose == "fist" and edge == "off" then doRelease()
    elseif pose == "fingersSpread" and edge == "on" then dropHand()
    elseif pose == "fingersSpread" and edge == "off" then raiseHand()
    end
end

function onPeriodic()
    local r = myo.getRoll()
    if r < -1 or r > 1 then startRoll()
    else endRoll()
    end

end


function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
    if isActive == true
      then activate()
    else
        deactivate()
    end
end

function activate()
    myo.controlMouse(true)
    myo.setLockingPolicy("none")
end

function deactivate()
    myo.controlMouse(false)
    myo.setLockingPolicy("standard")
end

function dropHand()
    myo.mouse("left", "down")
    mouseDown = true
end

function raiseHand()
    myo.mouse("left", "up")
    mouseDown = false
end

function startRoll()
    if mouseDown == false 
        then myo.mouse("right", "down")
        mouseDown = true
    end
end

function endRoll()
    if mouseDown == true 
        then 
        myo.mouse("right", "up") 
        mouseDown = false
    end
end


function doGrab()
    myo.keyboard("a","down")
    myo.keyboard("w","down")
    myo.keyboard("e","down")
    myo.keyboard("r","down")
    myo.keyboard("space","down")
end

function doRelease()
    myo.keyboard("a","up")
    myo.keyboard("w","up")
    myo.keyboard("e","up")
    myo.keyboard("r","up")
    myo.keyboard("space","up")
end