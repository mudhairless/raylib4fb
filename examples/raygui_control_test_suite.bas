/'******************************************************************************************
*
*   raygui - controls test suite
*
*   TEST CONTROLS:
*       - GuiDropdownBox()
*       - GuiCheckBox()
*       - GuiSpinner()
*       - GuiValueBox()
*       - GuiTextBox()
*       - GuiButton()
*       - GuiComboBox()
*       - GuiListView()
*       - GuiToggleGroup()
*       - GuiColorPicker()
*       - GuiSlider()
*       - GuiSliderBar()
*       - GuiProgressBar()
*       - GuiColorBarAlpha()
*       - GuiScrollPanel()
*
*
*   DEPENDENCIES:
*       raylib 4.5          - Windowing/input management and drawing
*       raygui 3.5          - Immediate-mode GUI controls with custom styling and icons
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -I../../src -lraylib -lopengl32 -lgdi32 -std=c99
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
*
*********************************************************************************************'/

#include once "raylib.bi"

#define RAYGUI_IMPLEMENTATION
#include once "raygui.bi"


' Initialization
'---------------------------------------------------------------------------------------
const screenWidth = 960
const screenHeight = 560

InitWindow(screenWidth, screenHeight, "raygui - controls test suite")
SetExitKey(0)

' GUI controls initialization
'----------------------------------------------------------------------------------
var dropdownBox000Active = 0l
var dropDown000EditMode = false

var dropdownBox001Active = 0l
var dropDown001EditMode = false

var spinner001Value = 0l
var spinnerEditMode = false

var valueBox002Value = 0l
var valueBoxEditMode = false

dim as zstring * 64 textBoxText = "Text box"
var textBoxEditMode = false

dim as zstring * 1024 textBoxMultiText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
var textBoxMultiEditMode = false

var listViewScrollIndex = 0l
dim as long listViewActive = -1l

var listViewExScrollIndex = 0l
var listViewExActive = 2l
dim as long listViewExFocus = -1l
dim as zstring ptr listViewExList(0 to 7) = { @"This", @"is", @"a", @"list view_", @"with", @"disable", @"elements", @"amazingnot " }

dim as zstring * 256 multiTextBoxText = "Multi text box"
var multiTextBoxEditMode = false
var colorPickerValue = RED

var sliderValue = 50.0f
var sliderBarValue = 60f
var progressValue = 0.1f

var forceSquaredChecked = false

var alphaValue = 0.5f

'int comboBoxActive = 1
var visualStyleActive = 0l
var prevVisualStyleActive = 0l

var toggleGroupActive = 0l
var toggleSliderActive = 0l

var viewScroll = type<Vector2>( 0, 0 )
'----------------------------------------------------------------------------------

var exitWindow = false
var showMessageBox = false

dim as zstring * 256 textInput
dim as zstring * 256 textInputFileName
var showTextInputBox = false

var alpha = 1.0f

' DEBUG: Testing how those two properties affect all controlsnot 
'GuiSetStyle(DEFAULT, TEXT_PADDING, 0)
'GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

SetTargetFPS(60)
'--------------------------------------------------------------------------------------

' Main game loop
while (not exitWindow)    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    exitWindow = WindowShouldClose()

    if (IsKeyPressed(KEY_ESCAPE)) then
        showMessageBox = not showMessageBox
    end if

    if (IsKeyDown(KEY_LEFT_CONTROL) AND IsKeyPressed(KEY_S)) then
        showTextInputBox = true
    end if

    if (IsFileDropped()) then
    
        var droppedFiles = LoadDroppedFiles()

        if ((droppedFiles.count > 0) AND IsFileExtension(droppedFiles.paths[0], ".rgs")) then
            GuiLoadStyle(droppedFiles.paths[0])
        end if

        UnloadDroppedFiles(droppedFiles)    ' Clear internal buffers
    end if

    'alpha -= 0.002f
    if (alpha < 0.0f) then
        alpha = 0.0f
    end if
    if (IsKeyPressed(KEY_SPACE)) then
        alpha = 1.0f
    end if

    GuiSetAlpha(alpha)

    'progressValue += 0.002f
    if (IsKeyPressed(KEY_LEFT)) then
        progressValue -= 0.1f
    elseif (IsKeyPressed(KEY_RIGHT)) then
        progressValue += 0.1f
    end if
    if (progressValue > 1.0f) then
        progressValue = 1.0f
    elseif (progressValue < 0.0f) then
        progressValue = 0.0f
    end if

    /'if (visualStyleActive <> prevVisualStyleActive) then
    
        GuiLoadStyleDefault()

        select case (visualStyleActive)
            case 1
                GuiLoadStyleJungle() 
            case 2 
                GuiLoadStyleLavanda() 
            case 3 
                GuiLoadStyleDark() 
            case 4 
                GuiLoadStyleBluish() 
            case 5 
                GuiLoadStyleCyber() 
            case 6 
                GuiLoadStyleTerminal() 
            
        end select

        GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)

        prevVisualStyleActive = visualStyleActive
    end if'/
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))

        ' raygui: controls drawing
        '----------------------------------------------------------------------------------
        ' Check all possible events that require GuiLock
        if (dropDown000EditMode OR dropDown001EditMode) then
            GuiLock()
        end if

        ' First GUI column
        'GuiSetStyle(CHECKBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
        GuiCheckBox(type<Rectangle>( 25, 108, 15, 15 ), "FORCE CHECKnot ", @forceSquaredChecked)

        GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
        'GuiSetStyle(VALUEBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
        if (GuiSpinner(type<Rectangle>( 25, 135, 125, 30 ), NULL, @spinner001Value, 0, 100, spinnerEditMode)) then
            spinnerEditMode = not spinnerEditMode
        end if
        if (GuiValueBox(type<Rectangle>( 25, 175, 125, 30 ), NULL, @valueBox002Value, 0, 100, valueBoxEditMode)) then
            valueBoxEditMode = not valueBoxEditMode
        end if
        GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
        if (GuiTextBox(type<Rectangle>( 25, 215, 125, 30 ), @textBoxText, 64, textBoxEditMode)) then
            textBoxEditMode = not textBoxEditMode
        end if

        GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

        if (GuiButton(type<Rectangle>( 25, 255, 125, 30 ), GuiIconText(ICON_FILE_SAVE, "Save File"))) then
            showTextInputBox = true
        end if

        GuiGroupBox(type<Rectangle>( 25, 310, 125, 150 ), "STATES")
        'GuiLock()
        GuiSetState(STATE_NORMAL) 
        if (GuiButton(type<Rectangle>( 30, 320, 115, 30 ), "NORMAL")) then
            '
        end if
        
        GuiSetState(STATE_FOCUSED)
        if (GuiButton(type<Rectangle>( 30, 355, 115, 30 ), "FOCUSED")) then
            '
        end if
        
        GuiSetState(STATE_PRESSED)
        if (GuiButton(type<Rectangle>( 30, 390, 115, 30 ), "#15#PRESSED")) then
            '
        end if
        
        GuiSetState(STATE_DISABLED)
        if (GuiButton(type<Rectangle>( 30, 425, 115, 30 ), "DISABLED")) then
            '
        end if
        GuiSetState(STATE_NORMAL)
        'GuiUnlock()

        GuiComboBox(type<Rectangle>( 25, 480, 125, 30 ), "defaultJungleLavandaDarkBluishCyberTerminal", @visualStyleActive)

        ' NOTE: GuiDropdownBox must draw after any other control that can be covered on unfolding
        GuiUnlock()
        GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 4)
        GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
        if (GuiDropdownBox(type<Rectangle>( 25, 65, 125, 30 ), "#01#ONE#02#TWO#03#THREE#04#FOUR", @dropdownBox001Active, dropDown001EditMode)) then
            dropDown001EditMode = not dropDown001EditMode
        end if
        GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
        GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 0)

        if (GuiDropdownBox(type<Rectangle>( 25, 25, 125, 30 ), "ONETWOTHREE", @dropdownBox000Active, dropDown000EditMode)) then
            dropDown000EditMode = not dropDown000EditMode
        end if

        ' Second GUI column
        GuiListView(type<Rectangle>( 165, 25, 140, 124 ), "CharmanderBulbasaur#18#SquirtelPikachuEeveePidgey", @listViewScrollIndex, @listViewActive)
        GuiListViewEx(type<Rectangle>( 165, 162, 140, 184 ), @listViewExList(0), 8, @listViewExScrollIndex, @listViewExActive, @listViewExFocus)

        'GuiToggle(type<Rectangle>( 165, 400, 140, 25 ), "#1#ONE", @toggleGroupActive)
        GuiToggleGroup(type<Rectangle>( 165, 360, 140, 24 ), "#1#ONE\n#3#TWO\n#8#THREE\n#23#", @toggleGroupActive)
        'GuiDisable()
        GuiSetStyle(SLIDER_, SLIDER_PADDING, 2)
        GuiToggleSlider(type<Rectangle>( 165, 480, 140, 30 ), "ONOFF", @toggleSliderActive)
        GuiSetStyle(SLIDER_, SLIDER_PADDING, 0)

        ' Third GUI column
        GuiPanel(type<Rectangle>( 320, 25, 225, 140 ), "Panel Info")
        GuiColorPicker(type<Rectangle>( 320, 185, 196, 192 ), NULL, @colorPickerValue)

        'GuiDisable()
        GuiSlider(type<Rectangle>( 355, 400, 165, 20 ), "TEST", TextFormat("%2.2f", sliderValue), @sliderValue, -50, 100)
        GuiSliderBar(type<Rectangle>( 320, 430, 200, 20 ), NULL, TextFormat("%i", sliderBarValue), @sliderBarValue, 0, 100)
        
        GuiProgressBar(type<Rectangle>( 320, 460, 200, 20 ), NULL, TextFormat("%i%%", (progressValue*100)), @progressValue, 0.0f, 1.0f)
        GuiEnable()

        ' NOTE: View rectangle could be used to perform some scissor test
        dim as Rectangle view_
        GuiScrollPanel(type<Rectangle>( 560, 25, 102, 354 ), NULL, type<Rectangle>( 560, 25, 300, 1200 ), @viewScroll, @view_)

        dim as Vector2 mouseCell 
        GuiGrid(type<Rectangle> ( 560, 25 + 180 + 195, 100, 120 ), NULL, 20, 3, @mouseCell)

        GuiColorBarAlpha(type<Rectangle>( 320, 490, 200, 30 ), NULL, @alphaValue)

        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP)   ' WARNING: Word-wrap does not work as expected in case of no-top alignment
        GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD)            ' WARNING: If wrap mode enabled, text editing is not supported
        if (GuiTextBox(type<Rectangle>( 678, 25, 258, 492 ), @textBoxMultiText, 1024, textBoxMultiEditMode)) then
            textBoxMultiEditMode = not textBoxMultiEditMode
        end if
        GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE)
        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE)

        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
        GuiStatusBar(type<Rectangle>( 0, GetScreenHeight() - 20, GetScreenWidth(), 20 ), "This is a status bar")
        GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
        'GuiSetStyle(STATUSBAR, TEXT_INDENTATION, 20)

        if (showMessageBox) then
            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(RAYWHITE, 0.8f))
            var result = GuiMessageBox(type<Rectangle>( GetScreenWidth()/2 - 125, GetScreenHeight()/2 - 50, 250, 100 ), GuiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "YesNo")

            if ((result = 0) OR (result = 2)) then
                showMessageBox = false
            elseif (result = 1) then
                exitWindow = true
            end if
        end if

        if (showTextInputBox) then
        
            DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(RAYWHITE, 0.8f))
            var result = GuiTextInputBox(type<Rectangle>( GetScreenWidth()/2 - 120, GetScreenHeight()/2 - 60, 240, 140 ), GuiIconText(ICON_FILE_SAVE, "Save file as..."), "Introduce output file name:", "OkCancel", textInput, 255, NULL)

            if (result = 1) then
            
                ' TODO: Validate textInput value and save

                TextCopy(textInputFileName, textInput)
            end if

            if ((result = 0) OR (result = 1) OR (result = 2)) then
            
                showTextInputBox = false
                TextCopy(textInput, "\0")
            end if
        end if
        '----------------------------------------------------------------------------------

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
