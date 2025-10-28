/'******************************************************************************************
*
*   raylib [shapes] example - bullet hell
*
*   Example complexity rating: [★☆☆☆] 1/4
*
*   Example originally created with raylib 5.6, last time updated with raylib 5.6
*
*   Example contributed by Zero (@zerohorsepower) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2025 Zero (@zerohorsepower)
*   Translated to FreeBASIC by Ebben Feagan 2025
*
*******************************************************************************************'/

#include "raylib.bi"

#include "crt/stdlib.bi"         ' Required for: calloc(), free()
#include "crt/math.bi"           ' Required for: cosf(), sinf()

#define MAX_BULLETS 500000      ' Max bullets to be processed

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------
type Bullet 
    as Vector2 position       ' Bullet position on screen
    as Vector2 acceleration   ' Amount of pixels to be incremented to position every frame
    as boolean disabled          ' Skip processing and draw case out of screen
    as RayColor color_            ' Bullet color_
end type


' Initialization
'--------------------------------------------------------------------------------------
const screenWidth = 800
const screenHeight = 450

InitWindow(screenWidth, screenHeight, "raylib [shapes] example - bullet hell")

' Bullets definition
var bullets = new Bullet[MAX_BULLETS] ' Bullets array
var bulletCount = 0
var bulletDisabledCount = 0 ' Used to calculate how many bullets are on screen
var bulletRadius = 10
var bulletSpeed = 3.0f
var bulletRows = 6
dim bulletColor(0 to 1) as RayColor 
bulletColor(0) = RED
bulletColor(1) = BLUE

' Spawner variables
var baseDirection = 0
var angleIncrement = 5 ' After spawn all bullet rows, increment this value on the baseDirection for next the frame
var spawnCooldown = 2
var spawnCooldownTimer = spawnCooldown

' Magic circle
var magicCircleRotation = 0

' Used on performance drawing
var bulletTexture = LoadRenderTexture(24, 24)

' Draw circle to bullet texture, then draw bullet using DrawTexture()
' NOTE: This is done to improve the performance, since DrawCircle() is very slow
BeginTextureMode(bulletTexture)
    DrawCircle(12, 12, csng(bulletRadius), WHITE)
    DrawCircleLines(12, 12, csng(bulletRadius), BLACK)
EndTextureMode()

var drawInPerformanceMode = true ' Switch between DrawCircle() and DrawTexture()

SetTargetFPS(60)
'--------------------------------------------------------------------------------------

' Main game loop
while (not WindowShouldClose())    ' Detect window close button or ESC key

    ' Update
    '----------------------------------------------------------------------------------
    ' Reset the bullet index
    ' New bullets will replace the old ones that are already disabled due to out-of-screen
    if (bulletCount >= MAX_BULLETS) then
    
        bulletCount = 0
        bulletDisabledCount = 0
    end if

    spawnCooldownTimer -= 1
    if (spawnCooldownTimer < 0) then
    
        spawnCooldownTimer = spawnCooldown

        ' Spawn bullets
        var degreesPerRow = 360.0f/bulletRows
        for row as integer = 0 to bulletRows - 1
        
            if (bulletCount < MAX_BULLETS) then
            
                bullets[bulletCount].position = type<Vector2>(csng(screenWidth/2), csng(screenHeight/2))
                bullets[bulletCount].disabled = false
                bullets[bulletCount].color_ = bulletColor(row mod 2)

                var bulletDirection = baseDirection + (degreesPerRow*row)

                ' Bullet speed * bullet direction, this will determine how much pixels will be incremented/decremented
                ' from the bullet position every frame. Since the bullets doesn't change its direction and speed,
                ' only need to calculate it at the spawning time
                ' 0 degrees = right, 90 degrees = down, 180 degrees = left and 270 degrees = up, basically clockwise
                ' Case you want it to be anti-clockwise, add "* -1" at the y acceleration
                bullets[bulletCount].acceleration = type<Vector2>( _
                    bulletSpeed*cosf(bulletDirection*DEG2RAD), _
                    bulletSpeed*sinf(bulletDirection*DEG2RAD) _
                )

                bulletCount += 1
            end if
        next row

        baseDirection += angleIncrement
    end if

    ' Update bullets position based on its acceleration
    for i as integer = 0 to bulletCount - 1
        ' Only update bullet if inside the screen
        if (not bullets[i].disabled) then
        
            bullets[i].position.x += bullets[i].acceleration.x
            bullets[i].position.y += bullets[i].acceleration.y

            ' Disable bullet if out of screen
            if ((bullets[i].position.x < -bulletRadius*2) OR _
                (bullets[i].position.x > screenWidth + bulletRadius*2) OR _
                (bullets[i].position.y < -bulletRadius*2) OR _
                (bullets[i].position.y > screenHeight + bulletRadius*2)) then
            
                bullets[i].disabled = true
                bulletDisabledCount += 1
            end if
        end if
    next i

    ' Input logic
    if ((IsKeyPressed(KEY_RIGHT) OR IsKeyPressed(KEY_D)) AND (bulletRows < 359)) then
        bulletRows += 1
    end if
    if ((IsKeyPressed(KEY_LEFT) OR IsKeyPressed(KEY_A)) AND (bulletRows > 1)) then
        bulletRows -= 1
    end if
    if (IsKeyPressed(KEY_UP) OR IsKeyPressed(KEY_W)) then
        bulletSpeed += 0.25f
    end if
    if ((IsKeyPressed(KEY_DOWN) OR IsKeyPressed(KEY_S)) AND (bulletSpeed > 0.50f)) then 
        bulletSpeed -= 0.25f
    end if
    if (IsKeyPressed(KEY_Z) AND (spawnCooldown > 1)) then 
        spawnCooldown -= 1
    end if
    if (IsKeyPressed(KEY_X)) then 
        spawnCooldown += 1
    end if
    if (IsKeyPressed(KEY_ENTER)) then 
        drawInPerformanceMode = not drawInPerformanceMode
    end if

    if (IsKeyDown(KEY_SPACE)) then
    
        angleIncrement += 1
        angleIncrement =  angleIncrement mod 360
    end if

    if (IsKeyPressed(KEY_C)) then
    
        bulletCount = 0
        bulletDisabledCount = 0
    end if
    '----------------------------------------------------------------------------------

    ' Draw
    '----------------------------------------------------------------------------------
    BeginDrawing()
        ClearBackground(RAYWHITE)

        ' Draw magic circle
        magicCircleRotation += 1
        DrawRectanglePro(type<Rectangle>( screenWidth/2, screenHeight/2, 120, 120 ), _
            type<Vector2>( 60.0f, 60.0f ), magicCircleRotation, PURPLE)
        DrawRectanglePro(type<Rectangle>( screenWidth/2, screenHeight/2, 120, 120 ), _
            type<Vector2>( 60.0f, 60.0f ), magicCircleRotation + 45, PURPLE)
        DrawCircleLines(screenWidth/2, screenHeight/2, 70, BLACK)
        DrawCircleLines(screenWidth/2, screenHeight/2, 50, BLACK)
        DrawCircleLines(screenWidth/2, screenHeight/2, 30, BLACK)

        ' Draw bullets
        if (drawInPerformanceMode) then
        
            ' Draw bullets using pre-rendered texture containing circle
            for i as integer = 0 to bulletCount - 1
            
            
                ' Do not draw disabled bullets (out of screen)
                if (not bullets[i].disabled) then
                
                    DrawTexture(bulletTexture.texture, _
                        (bullets[i].position.x - bulletTexture.texture.width_*0.5f), _
                        (bullets[i].position.y - bulletTexture.texture.height*0.5f), _
                        bullets[i].color_)
                end if
                
            next i
        
        else
        
            ' Draw bullets using DrawCircle(), less performant
            for i as integer = 0 to bulletCount - 1
            
            
                ' Do not draw disabled bullets (out of screen)
                if (not bullets[i].disabled) then
                
                    DrawCircleV(bullets[i].position, bulletRadius, bullets[i].color_)
                    DrawCircleLinesV(bullets[i].position, bulletRadius, BLACK)
                end if
            next i
        end if

        ' Draw UI
        DrawRectangle(10, 10, 280, 150, type<RayColor>(0,0, 0, 200 ))
        DrawText("Controls:", 20, 20, 10, LIGHTGRAY)
        DrawText("- Right/Left or A/D: Change rows number", 40, 40, 10, LIGHTGRAY)
        DrawText("- Up/Down or W/S: Change bullet speed", 40, 60, 10, LIGHTGRAY)
        DrawText("- Z or X: Change spawn cooldown", 40, 80, 10, LIGHTGRAY)
        DrawText("- Space (Hold): Change the angle increment", 40, 100, 10, LIGHTGRAY)
        DrawText("- Enter: Switch draw method (Performance)", 40, 120, 10, LIGHTGRAY)
        DrawText("- C: Clear bullets", 40, 140, 10, LIGHTGRAY)

        DrawRectangle(610, 10, 170, 30, type<RayColor>(0,0, 0, 200 ))
        if (drawInPerformanceMode) then
            DrawText("Draw method: DrawTexture(*)", 620, 20, 10, GREEN)
        
        else 
            DrawText("Draw method: DrawCircle(*)", 620, 20, 10, RED)
        end if

        DrawRectangle(135, 410, 530, 30, type<RayColor>(0,0, 0, 200 ))
        DrawText(TextFormat("[ FPS: %d, Bullets: %d, Rows: %d, Bullet speed: %.2f, Angle increment per frame: %d, Cooldown: %.0f ]", _
                GetFPS(), bulletCount - bulletDisabledCount, bulletRows, bulletSpeed,  angleIncrement, spawnCooldown), _
            155, 420, 10, GREEN)

    EndDrawing()
    '----------------------------------------------------------------------------------
wend

' De-Initialization
'--------------------------------------------------------------------------------------
UnloadRenderTexture(bulletTexture) ' Unload bullet texture

delete[] bullets     ' Free bullets array data

CloseWindow()        ' Close window and OpenGL context
'--------------------------------------------------------------------------------------

