#include once "raylib.bi"

InitWindow(800, 450, "raylib [core] example - basic window")

while (not WindowShouldClose())

    BeginDrawing()
        ClearBackground(RAYWHITE)
        DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY)
    EndDrawing()

wend

CloseWindow()

