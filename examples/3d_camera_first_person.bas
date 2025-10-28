/'******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2015-2025 Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"
#include once "raymath.bi"
#include once "rcamera.bi"

#define MAX_COLUMNS 19 ' account for FreeBASIC difference

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person")

' Define the camera to look into our 3d world (position, target, up vector)
dim as Camera3D camera
camera.position = type<Vector3>( 0.0f, 2.0f, 4.0f )    ' Camera position
camera.target = type<Vector3>( 0.0f, 2.0f, 0.0f )      ' Camera looking at point
camera.up = type<Vector3>( 0.0f, 1.0f, 0.0f )          ' Camera up vector (rotation towards target)
camera.fovy = 60.0f                                ' Camera field-of-view Y
camera.projection = CAMERA_PERSPECTIVE             ' Camera projection type

var camera_mode = CAMERA_FIRST_PERSON

' Generates some random columns
dim heights(0 to MAX_COLUMNS) as single
dim positions(0 to MAX_COLUMNS) as Vector3
dim colors(0 to MAX_COLUMNS) as RayColor

for i as integer = 0 to MAX_COLUMNS

    heights(i) = csng(GetRandomValue(1, 12))
    positions(i) = type<Vector3>( csng(GetRandomValue(-15, 15)), heights(i)/2.0f, csng(GetRandomValue(-15, 15)) )
    colors(i) = type<RayColor>( csng(GetRandomValue(20, 255)), csng(GetRandomValue(10, 55)), 30, 255 )
next i

DisableCursor()                    ' Limit cursor to relative movement inside the window

SetTargetFPS(60)                   ' Set our game to run at 60 frames-per-second
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())        ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    ' Switch camera mode
    if (IsKeyPressed(KEY_ONE)) then
    
        camera_mode = CAMERA_FREE
        camera.up = Vector3UnitY ' Reset roll
    end if

    if (IsKeyPressed(KEY_TWO)) then
    
        camera_mode = CAMERA_FIRST_PERSON
        camera.up = Vector3UnitY ' Reset roll
    end if

    if (IsKeyPressed(KEY_THREE)) then
    
        camera_mode = CAMERA_THIRD_PERSON
        camera.up = Vector3UnitY ' Reset roll
    end if

    if (IsKeyPressed(KEY_FOUR)) then
    
        camera_mode = CAMERA_ORBITAL
        camera.up = Vector3UnitY ' Reset roll
    end if

    ' Switch camera projection
    if (IsKeyPressed(KEY_P)) then
    
        if (camera.projection = CAMERA_PERSPECTIVE) then
        
            ' Create isometric view
            camera_mode = CAMERA_THIRD_PERSON
            ' Note: The target distance is related to the render distance in the orthographic projection
            camera.position = type<Vector3>( 0.0f, 2.0f, -100.0f )
            camera.target = type<Vector3>( 0.0f, 2.0f, 0.0f )
            camera.up = Vector3UnitY
            camera.projection = CAMERA_ORTHOGRAPHIC
            camera.fovy = 20.0f ' near plane width in CAMERA_ORTHOGRAPHIC
            CameraYaw(@camera, -135*(DEG2RAD), true)
            CameraPitch(@camera, -45*(DEG2RAD), true, true, false)
        
        elseif (camera.projection = CAMERA_ORTHOGRAPHIC) then
        
            ' Reset to default view
            camera_mode = CAMERA_THIRD_PERSON
            camera.position = type<Vector3>( 0.0f, 2.0f, 10.0f )
            camera.target = type<Vector3>( 0.0f, 2.0f, 0.0f )
            camera.up = Vector3UnitY
            camera.projection = CAMERA_PERSPECTIVE
            camera.fovy = 60.0f
        end if
    end if

    ' Update camera computes movement internally depending on the camera mode
    ' Some default standard keyboard/mouse inputs are hardcoded to simplify use
    ' For advanced camera controls, it's recommended to compute camera movement manually
    UpdateCamera(@camera, camera_mode)                  ' Update camera

    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(RAYWHITE)

        BeginMode3D(camera)

            DrawPlane(Vector3Zero, type<Vector2>( 32.0f, 32.0f ), LIGHTGRAY) ' Draw ground
            DrawCube(type<Vector3>( -16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, BLUE)     ' Draw a blue wall
            DrawCube(type<Vector3>( 16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, LIME)      ' Draw a green wall
            DrawCube(type<Vector3>( 0.0f, 2.5f, 16.0f ), 32.0f, 5.0f, 1.0f, GOLD)      ' Draw a yellow wall

            ' Draw some cubes around
            for i as integer = 0 to MAX_COLUMNS
            
                DrawCube(positions(i), 2.0f, heights(i), 2.0f, colors(i))
                DrawCubeWires(positions(i), 2.0f, heights(i), 2.0f, MAROON)
            next i

            ' Draw player cube
            if (camera_mode = CAMERA_THIRD_PERSON) then
            
                DrawCube(camera.target, 0.5f, 0.5f, 0.5f, PURPLE)
                DrawCubeWires(camera.target, 0.5f, 0.5f, 0.5f, DARKPURPLE)
            end if
        EndMode3D()

        ' Draw info boxes
        DrawRectangle(5, 5, 330, 100, Fade(SKYBLUE, 0.5f))
        DrawRectangleLines(5, 5, 330, 100, BLUE)

        DrawText("Camera controls:", 15, 15, 10, BLACK)
        DrawText("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, BLACK)
        DrawText("- Look around: arrow keys or mouse", 15, 45, 10, BLACK)
        DrawText("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, BLACK)
        DrawText("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, BLACK)
        DrawText("- Camera projection key: P", 15, 90, 10, BLACK)

        DrawRectangle(600, 5, 195, 100, Fade(SKYBLUE, 0.5f))
        DrawRectangleLines(600, 5, 195, 100, BLUE)

        DrawText("Camera status:", 610, 15, 10, BLACK)
        DrawText(TextFormat("- Mode: %s", iif((camera_mode = CAMERA_FREE), "FREE", _
                                            iif((camera_mode = CAMERA_FIRST_PERSON), "FIRST_PERSON", _
                                            iif((camera_mode = CAMERA_THIRD_PERSON), "THIRD_PERSON", _
                                            iif((camera_mode = CAMERA_ORBITAL), "ORBITAL", "CUSTOM"))))), 610, 30, 10, BLACK)
        DrawText(TextFormat("- Projection: %s", iif((camera.projection = CAMERA_PERSPECTIVE), "PERSPECTIVE", _
                                                iif((camera.projection = CAMERA_ORTHOGRAPHIC), "ORTHOGRAPHIC", "CUSTOM"))), 610, 45, 10, BLACK)
        DrawText(TextFormat("- Position: (%06.3f, %06.3f, %06.3f)", camera.position.x, camera.position.y, camera.position.z), 610, 60, 10, BLACK)
        DrawText(TextFormat("- Target: (%06.3f, %06.3f, %06.3f)", camera.target.x, camera.target.y, camera.target.z), 610, 75, 10, BLACK)
        DrawText(TextFormat("- Up: (%06.3f, %06.3f, %06.3f)", camera.up.x, camera.up.y, camera.up.z), 610, 90, 10, BLACK)
        

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------
