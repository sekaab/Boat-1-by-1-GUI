--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section LB_SIMULATOR_ONLY
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "1x1")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)

        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0
page = 1
function onTick()
    RTFl = 1700.0--input.getNumber(7)
    RTFc = 1700--input.getNumber(8)
    LTFl = 987.01--input.getNumber(9)
    LTFc = 1700--input.getNumber(10)
    FCon = 0.532--input.getNumber(11)
    WSpe = input.getNumber(12)
    WDir = input.getNumber(13)
    iX = input.getNumber(3)
    iY = input.getNumber(4)
    PrBu = input.getBool(1)
    PumpButtonLeftTank = input.getBool(5)
    PumpButtonRightTank = input.getBool(6)

    isPrPgSw = PrBu and isPointInRectangle(iX, iY, 0, 29, 32, 2)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

function onDraw()
    if isPrPgSw and page==2 then
        page = 1
    elseif isPrPgSw then
        page = page + 1
    end
    if page == 1 then
        FuelDraw()
    end
    if page == 2 then
        WindDraw()
    end
end

function FuelDraw()
    DrawBackground()
    screen.drawTextBox(1, 1, 32, 5, Round(3, math.abs(FCon)), -1, 0)
    --Draw the Bar Frames
    Color(22, 22, 22, 131)
    screen.drawRect(2, 14, 3, 14)
    screen.drawRect(26, 10, 3, 14)
    --draw the Arrows for the Pump Direction in the same Grey Shade
    Uline = 17
    Bline = 21
    screen.drawLine(8, Uline, 24, Uline); screen.drawLine(22, Uline - 1, 22, Uline + 2)
    screen.drawLine(8, Bline, 24, Bline); screen.drawLine(9, Bline - 1, 9, Bline + 2)
    --Draw the ActivationRects
    Color(0, 5, 250)
    Centerline = 28/2
    Displacement = 2
        --register Buttonpress
        output.setBool(7, PrBu and isPointInRectangle(iX, iY, Centerline-Displacement, Uline - 1, 4, 3))
        output.setBool(9, PrBu and isPointInRectangle(iX, iY, Centerline+Displacement, Bline - 1, 4, 3))
    screen.drawRectF(Centerline-Displacement, Uline - 1, 4, 3)
    screen.drawRectF(Centerline+Displacement, Bline - 1, 4, 3)
    --Draw (fill) the Bars
    Color(0, 255, 33, 131)
    screen.drawRectF(3, 28, 2, -13*LTFl/LTFc)
    screen.drawRectF(27, 24, 2, -13*RTFl/RTFc)
    Color(255, 255, 255, 160)
    BoxSize = 20
    screen.drawTextBox(3, 10, BoxSize, 5, Round(0, math.abs(LTFl)), -1, 0)
    Alteration = -3 + (BoxSize / 5 - string.len(Round(0, RTFl))) * 5
    screen.drawTextBox(Alteration, 24, BoxSize, 5, Round(0, math.abs(RTFl)), 1, 0)
end

function WindDraw()
    DrawBackground()
    --Draw Informations
    Color(255, 255, 255)
    rad = 7.5
    screen.drawTextBox(1, 1, 32, 5, Round(2, WSpe), -1, 0)
    screen.drawCircle(15, 19, rad)
    Color(255, 0, 0)
    screen.drawLine(15, 19, 15+math.sin(WDir*math.pi*2)*rad, 19+math.cos(WDir*math.pi*2)*rad)
end

function DrawBackground()
    --Draw Background
    Color(8, 8, 8)
    screen.drawClear()
    Color(0, 0, 0)
    screen.drawRectF(0, 0, 32, 8)
    Color(0, 33, 33)
    screen.drawRectF(0, 9, 32, 24)
    Color(0, 5, 250)
    screen.drawRectF(0, 30, 32, 2)
    Color(255, 255, 255)
end

function Color(r, g, b, a)
    a = a or 255
    screen.setColor(r, g, b, a)
end

function Round(i, s)
    return string.format("%."..i.."f", s)
end