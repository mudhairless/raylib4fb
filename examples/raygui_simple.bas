#include once "raylib.bi"
#include once "raygui.bi"


' Initialization
'---------------------------------------------------------------------------------------
const screenWidth = 960
const screenHeight = 560

var exitWindow = false
var showMessageBox = false
InitWindow(screenWidth, screenHeight, "raygui - controls test suite")
while (not exitWindow)
    BeginDrawing()

        ClearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))

        if (showMessageBox) then
            DrawRectangle(0, 0, ScreenWidth, GetScreenHeight, Fade(RAYWHITE, 0.8f))
            var result = GuiMessageBox(type<Rectangle>( ScreenWidth/2 - 125, ScreenHeight/2 - 50, 250, 100 ), GuiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "Yes;No")

            if ((result = 0) OR (result = 2)) then
                showMessageBox = false
            elseif (result = 1) then
                exitWindow = true
            
            end if

        else
            if (GuiButton(type<Rectangle>( 25, 255, 125, 30 ), GuiIconText(ICON_FILE_SAVE, "Save File"))) then
                showMessageBox = true
            end if
        end if

    EndDrawing()

wend