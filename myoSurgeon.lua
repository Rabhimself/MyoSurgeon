scriptId = 'com.myosurgeon'  
scriptTitle = "MyoSurgeon"  
scriptDetailsUrl = ""  



function onForegroundWindowChange(app, title)
    local uppercaseApp = string.upper(app)
    myo.debug(uppercaseApp)
    return platform == "Windows" and uppercaseApp == "SS2013.EXE"
end

function onPoseEdge(pose, edge)
    if pose == "fist" and edge == "on" then doGrab()
    elseif pose == "fist" and edge == "off" then doRelease()
    end
end

function onPeriodic()
end


function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
    if isActive == true
       then myo.controlMouse(true)
    else
        myo.controlMouse(false)
    end
end


function doGrab()
    myo.keyboard("a","down")
    myo.keyboard("w","down")
    myo.keyboard("e","down")
    myo.keyboard("r","down")
    myo.keyboard("spacebar","down")
end

function doRelease()
    myo.keyboard("a","up")
    myo.keyboard("w","up")
    myo.keyboard("e","up")
    myo.keyboard("r","up")
    myo.keyboard("spacebar","up")
end