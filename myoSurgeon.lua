scriptId = 'com.myosurgeon'  
scriptTitle = "MyoSurgeon"  
scriptDetailsUrl = ""  

leftMouseDown = false
rightMouseDown = false
grasping = false

function onForegroundWindowChange(app, title)
    local uppercaseApp = string.upper(app)
    return platform == "Windows" and uppercaseApp == "SS2013.EXE"
end

function onPoseEdge(pose, edge)
    myo.debug(pose)
    if pose == "fist" and edge == "on" then grabOrRelease()
    elseif pose == "waveIn" and edge == "on" then dropOrRaiseHand()
    elseif pose == "waveOut" and edge == "on" then toggleRoll()
    end
end

function onPeriodic()
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

function dropOrRaiseHand()
    if leftMouseDown == false
        then myo.mouse("left", "down")
             leftMouseDown = true
    elseif leftMouseDown == true
        then myo.mouse("left","up")
             leftMouseDown = false
    end
   
end

function startRoll()
    myo.mouse("right", "down")
    rolling = true
end

function endRoll()
    myo.mouse("right", "up") 
    rolling = false
end

function doGrab()
    myo.keyboard("a","down")
    myo.keyboard("w","down")
    myo.keyboard("e","down")
    myo.keyboard("r","down")
    myo.keyboard("space","down")
    grasping = true
end

function doRelease()
    myo.keyboard("a","up")
    myo.keyboard("w","up")
    myo.keyboard("e","up")
    myo.keyboard("r","up")
    myo.keyboard("space","up")
    grasping = false
end

function toggleRoll()
    if rolling == false then startRoll()
    else endRoll()
    end
end

function grabOrRelease()
    if grasping == false then doGrab()
    else doRelease()
    end
end