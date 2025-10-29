/'******************************************************************************************
*
*   rcamera - Basic camera system with support for multiple camera modes
*
*   CONFIGURATION:
*       #define RCAMERA_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RCAMERA_STANDALONE
*           If defined, the library can be used as standalone as a camera system but some
*           functions must be redefined to manage inputs accordingly.
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, update and maintenance
*       Christoph Wagner:   Complete redesign, using raymath (2022)
*       Marc Palau:         Initial implementation (2014)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2022-2024 Christoph Wagner (@Crydsch) & Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
*********************************************************************************************'/

#ifndef RCAMERA_BI
#define RCAMERA_BI

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------

#define CAMERA_CULL_DISTANCE_NEAR   RL_CULL_DISTANCE_NEAR
#define CAMERA_CULL_DISTANCE_FAR    RL_CULL_DISTANCE_FAR

'----------------------------------------------------------------------------------
' Module Functions Declaration
'----------------------------------------------------------------------------------
extern "C"
declare function GetCameraForward(byval camera as Camera3D ptr) as Vector3
declare function GetCameraUp(byval camera as Camera3D ptr) as Vector3
declare function GetCameraRight(byval camera as Camera3D ptr) as Vector3

' Camera movement
declare sub CameraMoveForward(byval camera as Camera3D ptr, byval distance as single, byval moveInWorldPlane as boolean)
declare sub CameraMoveUp(byval camera as Camera3D ptr, byval distance as single)
declare sub CameraMoveRight(byval camera as Camera3D ptr, byval distance as single, byval moveInWorldPlane as boolean)
declare sub CameraMoveToTarget(byval camera as Camera3D ptr, byval delta as single)

' Camera rotation
declare sub CameraYaw(byval camera as Camera3D ptr, byval angle as single, byval rotateAroundTarget as boolean)
declare sub CameraPitch(byval camera as Camera3D ptr, byval angle as single, byval lockView as boolean, byval rotateAroundTarget as boolean, byval rotateUp as boolean)
declare sub CameraRoll(byval camera as Camera3D ptr, byval angle as single)

declare function GetCameraViewMatrix(byval camera as Camera3D ptr) as Matrix
declare function GetCameraProjectionMatrix(byval camera as Camera3D ptr, byval aspect as single) as Matrix

end extern

#endif ' RCAMERA_BI

/'**********************************************************************************
*
*   CAMERA IMPLEMENTATION
*
***********************************************************************************'/

#ifdef RCAMERA_IMPLEMENTATION

#include once "raymath.bi"  ' Required for vector maths:
                            ' Vector3Add()
                            ' Vector3Subtract()
                            ' Vector3Scale()
                            ' Vector3Normalize()
                            ' Vector3Distance()
                            ' Vector3CrossProduct()
                            ' Vector3RotateByAxisAngle()
                            ' Vector3Angle()
                            ' Vector3Negate()
                            ' MatrixLookAt()
                            ' MatrixPerspective()
                            ' MatrixOrtho()
                            ' MatrixIdentity()

' raylib required functionality:
                            ' GetMouseDelta()
                            ' GetMouseWheelMove()
                            ' IsKeyDown()
                            ' IsKeyPressed()
                            ' GetFrameTime()

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------
#define CAMERA_MOVE_SPEED                               5.4f       ' Units per second
#define CAMERA_ROTATION_SPEED                           0.03f
#define CAMERA_PAN_SPEED                                0.2f

' Camera mouse movement sensitivity
#define CAMERA_MOUSE_MOVE_SENSITIVITY                   0.003f

' Camera orbital speed in CAMERA_ORBITAL mode
#define CAMERA_ORBITAL_SPEED                            0.5f       ' Radians per second

#ifndef RL_CULL_DISTANCE_NEAR
    #define CAMERA_CULL_DISTANCE_NEAR      0.01f
#else
    #define CAMERA_CULL_DISTANCE_NEAR   RL_CULL_DISTANCE_NEAR
#endif

#ifndef RL_CULL_DISTANCE_FAR
    #define CAMERA_CULL_DISTANCE_FAR    1000.0f
#else
    #define CAMERA_CULL_DISTANCE_FAR    RL_CULL_DISTANCE_FAR
#endif

'----------------------------------------------------------------------------------
' Module Functions Definition
'----------------------------------------------------------------------------------
' Returns the cameras forward vector (normalized)
function GetCameraForward(byval camera as Camera3D ptr) as Vector3

    return Vector3Normalize(Vector3Subtract(camera->target, camera->position))
end function

' Returns the cameras up vector (normalized)
' Note: The up vector might not be perpendicular to the forward vector
function GetCameraUp(byval camera as Camera3D ptr) as Vector3

    return Vector3Normalize(camera->up)
end function

' Returns the cameras right vector (normalized)
function GetCameraRight(byval camera as Camera3D ptr) as Vector3

    var forward = GetCameraForward(camera)
    var up = GetCameraUp(camera)

    return Vector3Normalize(Vector3CrossProduct(forward, up))
end function

' Moves the camera in its forward direction
sub CameraMoveForward(byval camera as Camera3D ptr, byval distance as single, byval moveInWorldPlane as boolean)

    var forward = GetCameraForward(camera)

    if (moveInWorldPlane) then
    
        ' Project vector onto world plane
        forward.y = 0
        forward = Vector3Normalize(forward)
    end if

    ' Scale by distance
    forward = Vector3Scale(forward, distance)

    ' Move position and target
    camera->position = Vector3Add(camera->position, forward)
    camera->target = Vector3Add(camera->target, forward)
end sub

' Moves the camera in its up direction
sub CameraMoveUp(byval camera as Camera3D ptr, byval distance as single)

    var up = GetCameraUp(camera)

    ' Scale by distance
    up = Vector3Scale(up, distance)

    ' Move position and target
    camera->position = Vector3Add(camera->position, up)
    camera->target = Vector3Add(camera->target, up)
end sub

' Moves the camera target in its current right direction
sub CameraMoveRight(byval camera as Camera3D ptr, byval distance as single, byval moveInWorldPlane as boolean)

    var right_ = GetCameraRight(camera)

    if (moveInWorldPlane) then
    
        ' Project vector onto world plane
        right_.y = 0
        right_ = Vector3Normalize(right_)
    end if

    ' Scale by distance
    right_ = Vector3Scale(right_, distance)

    ' Move position and target
    camera->position = Vector3Add(camera->position, right_)
    camera->target = Vector3Add(camera->target, right_)
end sub

' Moves the camera position closer/farther to/from the camera target
sub CameraMoveToTarget(byval camera as Camera3D ptr, byval delta as single)

    var distance = Vector3Distance(camera->position, camera->target)

    ' Apply delta
    distance += delta

    ' Distance must be greater than 0
    if (distance <= 0) then
        distance = 0.001f
    end if

    ' Set new distance by moving the position along the forward vector
    var forward = GetCameraForward(camera)
    camera->position = Vector3Add(camera->target, Vector3Scale(forward, -distance))
end sub

' Rotates the camera around its up vector
' Yaw is "looking left and right"
' If rotateAroundTarget is false, the camera rotates around its position
' Note: angle must be provided in radians
sub CameraYaw(byval camera as Camera3D ptr, byval angle as single, byval rotateAroundTarget as boolean)

    ' Rotation axis
    var up = GetCameraUp(camera)

    ' View vector
    var targetPosition = Vector3Subtract(camera->target, camera->position)

    ' Rotate view vector around up axis
    targetPosition = Vector3RotateByAxisAngle(targetPosition, up, angle)

    if (rotateAroundTarget) then
    
        ' Move position relative to target
        camera->position = Vector3Subtract(camera->target, targetPosition)
    
    else ' rotate around camera.position
    
        ' Move target relative to position
        camera->target = Vector3Add(camera->position, targetPosition)
    end if
end sub

' Rotates the camera around its right vector, pitch is "looking up and down"
'  - lockView prevents camera overrotation (aka "somersaults")
'  - rotateAroundTarget defines if rotation is around target or around its position
'  - rotateUp rotates the up direction as well (typically only usefull in CAMERA_FREE)
' NOTE: angle must be provided in radians
sub CameraPitch(byval camera as Camera3D ptr, byval angle as single, byval lockView as boolean, byval rotateAroundTarget as boolean, byval rotateUp as boolean)

    ' Up direction
    var up = GetCameraUp(camera)

    ' View vector
    var targetPosition = Vector3Subtract(camera->target, camera->position)

    if (lockView) then
    
        ' In these camera modes we clamp the Pitch angle
        ' to allow only viewing straight up or down.

        ' Clamp view up
        var maxAngleUp = Vector3Angle(up, targetPosition)
        maxAngleUp -= 0.001f ' avoid numerical errors
        if (angle > maxAngleUp) then
             angle = maxAngleUp
        end if

        ' Clamp view down
        var maxAngleDown = Vector3Angle(Vector3Negate(up), targetPosition)
        maxAngleDown *= -1.0f ' downwards angle is negative
        maxAngleDown += 0.001f ' avoid numerical errors
        if (angle < maxAngleDown) then
             angle = maxAngleDown
        end if
    end if

    ' Rotation axis
    var right_ = GetCameraRight(camera)

    ' Rotate view vector around right axis
    targetPosition = Vector3RotateByAxisAngle(targetPosition, right_, angle)

    if (rotateAroundTarget) then
    
        ' Move position relative to target
        camera->position = Vector3Subtract(camera->target, targetPosition)
    
    else ' rotate around camera.position
    
        ' Move target relative to position
        camera->target = Vector3Add(camera->position, targetPosition)
    end if

    if (rotateUp) then

        ' Rotate up direction around right axis
        camera->up = Vector3RotateByAxisAngle(camera->up, right_, angle)
    end if
end sub

' Rotates the camera around its forward vector
' Roll is "turning your head sideways to the left or right"
' Note: angle must be provided in radians
sub CameraRoll(byval camera as Camera3D ptr, byval angle as single)

    ' Rotation axis
    var forward = GetCameraForward(camera)

    ' Rotate up direction around forward axis
    camera->up = Vector3RotateByAxisAngle(camera->up, forward, angle)
end sub

' Returns the camera view matrix
function GetCameraViewMatrix(byval camera as Camera3D ptr) as Matrix

    return MatrixLookAt(camera->position, camera->target, camera->up)
end function

' Returns the camera projection matrix
function GetCameraProjectionMatrix(byval camera as Camera3D ptr, byval aspect as single) as Matrix

    if (camera->projection == CAMERA_PERSPECTIVE) then
    
        return MatrixPerspective(camera->fovy*DEG2RAD, aspect, CAMERA_CULL_DISTANCE_NEAR, CAMERA_CULL_DISTANCE_FAR)
    
    elseif (camera->projection == CAMERA_ORTHOGRAPHIC) then
    
        var top = camera->fovy/2.0
        var right_ = top*aspect

        return MatrixOrtho(-right_, right_, -top, top, CAMERA_CULL_DISTANCE_NEAR, CAMERA_CULL_DISTANCE_FAR)
    end if

    return MatrixIdentity()
end function

#endif ' RCAMERA_IMPLEMENTATION