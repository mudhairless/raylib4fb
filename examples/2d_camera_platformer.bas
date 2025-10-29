/'******************************************************************************************
*
*   raylib [core] example - 2D Camera platformer
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*
*   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2024 arvyy (@arvyy)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include once "raylib.bi"
#define RAYMATH_IMPLEMENTATION
#include once "raymath.bi"

#define G 400
#define PLAYER_JUMP_SPD 350.0f
#define PLAYER_HOR_SPD 200.0f

type Player 
    as Vector2 position
    as single speed
    as boolean canJump
end type

type EnvItem 
    as Rectangle rect
    as long blocking
    as RayColor _color
end type

type CameraUpdateFunc as sub(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

'----------------------------------------------------------------------------------
' Module functions declaration
'----------------------------------------------------------------------------------
declare sub UpdatePlayer(byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single)
declare sub UpdateCameraCenter(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)
declare sub UpdateCameraCenterInsideMap(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)
declare sub UpdateCameraCenterSmoothFollow(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)
declare sub UpdateCameraEvenOutOnLanding(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)
declare sub UpdateCameraPlayerBoundsPush(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

'------------------------------------------------------------------------------------
' Program main entry point
'------------------------------------------------------------------------------------

' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera_")

dim as Player player_
player_.position = type<Vector2>( 400, 280 )
player_.speed = 0
player_.canJump = false
dim as EnvItem envItems(0 to 4) 

envItems(0) = type<EnvItem>(type<Rectangle>( 0, 0, 1000, 400 ), 0, LIGHTGRAY )
envItems(1) = type<EnvItem>(type<Rectangle>( 0, 400, 1000, 200 ), 1, GRAY )
envItems(2) = type<EnvItem>(type<Rectangle>( 300, 200, 400, 10 ), 1, GRAY )
envItems(3) = type<EnvItem>(type<Rectangle>( 250, 300, 100, 10 ), 1, GRAY )
envItems(4) = type<EnvItem>(type<Rectangle>( 650, 300, 100, 10 ), 1, GRAY )


dim envItemsLength as long = 5

dim as Camera2D camera_
camera_.target = player_.position
camera_.offset = type<Vector2>( screenWidth/2.0f, screenHeight/2.0f )
camera_.rotation = 0.0f
camera_.zoom = 1.0f

' Store pointers to the multiple update camera_ functions
dim cameraUpdaters(0 to 4) as cameraUpdateFunc
cameraUpdaters(0) = @UpdateCameraCenter
cameraUpdaters(1) = @UpdateCameraCenterInsideMap
cameraUpdaters(2) = @UpdateCameraCenterSmoothFollow
cameraUpdaters(3) = @UpdateCameraEvenOutOnLanding
cameraUpdaters(4) = @UpdateCameraPlayerBoundsPush


var cameraOption = 0
var cameraUpdatersLength = 5

dim cameraDescriptions(0 to 4) as string
cameraDescriptions(0) = "Follow player_ center"
cameraDescriptions(1) = "Follow player_ center, but clamp to map edges"
cameraDescriptions(2) = "Follow player_ center smoothed"
cameraDescriptions(3) = "Follow player_ center horizontally update player_ center vertically after landing"
cameraDescriptions(4) = "Player push camera_ on getting too close to screen edge"


SetTargetFPS(60)
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())

    ' Update
    '----------------------------------------------------------------------------------
    var deltaTime = GetFrameTime()

    UpdatePlayer(@player_, @envItems(0), envItemsLength, deltaTime)

    camera_.zoom += (GetMouseWheelMove()*0.05f)

    if (camera_.zoom > 3.0f) then
        camera_.zoom = 3.0f
    elseif (camera_.zoom < 0.25f) then
        camera_.zoom = 0.25f
    end if

    if (IsKeyPressed(KEY_R)) then
        camera_.zoom = 1.0f
        player_.position = type<Vector2>( 400, 280 )
    end if

    if (IsKeyPressed(KEY_C)) then
        cameraOption = (cameraOption + 1) mod cameraUpdatersLength
    end if

    
    ' Call update camera_ function by its pointer
    cameraUpdaters(cameraOption)(@camera_, @player_, @envItems(0), envItemsLength, deltaTime, screenWidth, screenHeight)
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()

        ClearBackground(LIGHTGRAY)

        BeginMode2D(camera_)

            for i as integer = 0 to envItemsLength - 1
                DrawRectangleRec(envItems(i).rect, envItems(i)._color)
            next

            var playerRect = type<Rectangle>( player_.position.x - 20, player_.position.y - 40, 40.0f, 40.0f )
            DrawRectangleRec(playerRect, RED)
            
            DrawCircleV(player_.position, 5.0f, GOLD)

        EndMode2D()

        DrawText("Controls:", 20, 20, 10, BLACK)
        DrawText("- A/D to move", 40, 40, 10, DARKGRAY)
        DrawText("- Space to jump", 40, 60, 10, DARKGRAY)
        DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY)
        DrawText("- C to change camera_ mode", 40, 100, 10, DARKGRAY)
        DrawText("Current camera_ mode:", 20, 120, 10, BLACK)
        DrawText(cameraDescriptions(cameraOption), 40, 140, 10, DARKGRAY)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------


sub UpdatePlayer(byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single)

    if (IsKeyDown(KEY_A)) then
        player_->position.x -= PLAYER_HOR_SPD*delta
    end if
    if (IsKeyDown(KEY_D)) then
        player_->position.x += PLAYER_HOR_SPD*delta
    end if
    if (IsKeyDown(KEY_SPACE) AND player_->canJump) then
    
        player_->speed = -PLAYER_JUMP_SPD
        player_->canJump = false
    
    end if

    var hitObstacle = false
    for i as integer = 0 to envItemsLength - 1
    
        var ei = envItems + i
        var p = @(player_->position)
        if (ei->blocking AND _
            ei->rect.x <= p->x AND _
            ei->rect.x + ei->rect.width_ >= p->x AND _
            ei->rect.y >= p->y AND _
            ei->rect.y <= p->y + player_->speed*delta) then
        
            hitObstacle = true
            player_->speed = 0.0f
            p->y = ei->rect.y
            exit for
        end if
    next

    if (not hitObstacle) then
    
        player_->position.y += player_->speed*delta
        player_->speed += G*delta
        player_->canJump = false
    
    else 
        player_->canJump = true
    end if

end sub

sub UpdateCameraCenter(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

    camera_->offset = type<Vector2>( width_/2.0f, height/2.0f )
    camera_->target = player_->position

end sub

sub UpdateCameraCenterInsideMap(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

    camera_->target = player_->position
    camera_->offset = type<Vector2>( width_/2.0f, height/2.0f )
    dim as single minX = 1000, minY = 1000, maxX = -1000, maxY = -1000

    for i as integer = 0 to envItemsLength - 1
    
        var ei = envItems + i
        minX = fminf(ei->rect.x, minX)
        maxX = fmaxf(ei->rect.x + ei->rect.width_, maxX)
        minY = fminf(ei->rect.y, minY)
        maxY = fmaxf(ei->rect.y + ei->rect.height, maxY)
    next

    var max = GetWorldToScreen2D(type<Vector2>( maxX, maxY ), *camera_)
    var min = GetWorldToScreen2D(type<Vector2>( minX, minY ), *camera_)

    if (max.x < width_) then
         camera_->offset.x = width_ - (max.x - width_/2)
    end if
    if (max.y < height) then 
        camera_->offset.y = height - (max.y - height/2)
    end if
    if (min.x > 0) then 
        camera_->offset.x = width_/2 - min.x
    end if
    if (min.y > 0) then 
        camera_->offset.y = height/2 - min.y
    end if

end sub

sub UpdateCameraCenterSmoothFollow(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

    static as single minSpeed = 30f
    static as single minEffectLength = 10f
    static as single fractionSpeed = 0.8f

    camera_->offset = type<Vector2>( width_/2.0f, height/2.0f )
    var diff = Vector2Subtract(player_->position, camera_->target)
    var length = Vector2Length(diff)

    if (length > minEffectLength) then
    
        var speed = fmaxf(fractionSpeed*length, minSpeed)
        camera_->target = Vector2Add(camera_->target, Vector2Scale(diff, speed*delta/length))
    end if

end sub

sub UpdateCameraEvenOutOnLanding(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

    static as single evenOutSpeed = 700f
    static as boolean eveningOut = false
    static as single evenOutTarget

    camera_->offset = type<Vector2>( width_/2.0f, height/2.0f )
    camera_->target.x = player_->position.x

    if (eveningOut) then
    
        if (evenOutTarget > camera_->target.y) then
        
            camera_->target.y += evenOutSpeed*delta

            if (camera_->target.y > evenOutTarget) then
            
                camera_->target.y = evenOutTarget
                eveningOut = false
            end if
        
        else
        
            camera_->target.y -= evenOutSpeed*delta

            if (camera_->target.y < evenOutTarget) then
            
                camera_->target.y = evenOutTarget
                eveningOut = false
            end if
        end if
    
    else
    
        if (player_->canJump AND (player_->speed = 0) AND (player_->position.y <> camera_->target.y)) then
        
            eveningOut = true
            evenOutTarget = player_->position.y
        end if
    end if

end sub

sub UpdateCameraPlayerBoundsPush(byval camera_ as Camera2D ptr, byval player_ as Player ptr, byval envItems as EnvItem ptr, byval envItemsLength as long, byval delta as single, byval width_ as long, byval height as long)

    static as Vector2 bbox = type<Vector2>( 0.2f, 0.2f )

    var bboxWorldMin = GetScreenToWorld2D(type<Vector2>( (1 - bbox.x)*0.5f*width_, (1 - bbox.y)*0.5f*height ), *camera_)
    var bboxWorldMax = GetScreenToWorld2D(type<Vector2>( (1 + bbox.x)*0.5f*width_, (1 + bbox.y)*0.5f*height ), *camera_)
    camera_->offset = type<Vector2> ((1 - bbox.x)*0.5f * width_, (1 - bbox.y)*0.5f*height )

    if (player_->position.x < bboxWorldMin.x) then
        camera_->target.x = player_->position.x
    end if
    if (player_->position.y < bboxWorldMin.y) then
        camera_->target.y = player_->position.y
    end if
    if (player_->position.x > bboxWorldMax.x) then
        camera_->target.x = bboxWorldMin.x + (player_->position.x - bboxWorldMax.x)
    end if
    if (player_->position.y > bboxWorldMax.y) then
        camera_->target.y = bboxWorldMin.y + (player_->position.y - bboxWorldMax.y)
    end if

end sub