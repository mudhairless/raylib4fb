/'*********************************************************************************************
*
*   raylib.lights - Some useful functions to deal with lights data
*
*   CONFIGURATION:
*
*   #define RLIGHTS_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers 
*       or source files without problems. But only ONE file should hold the implementation.
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2017-2024 Victor Fisac (@victorfisac) and Ramon Santamaria (@raysan5)
*   Translated to FreeBASIC by Ebben Feagan 2025
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

#ifndef RLIGHTS_BI
#define RLIGHTS_BI

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------
#define MAX_LIGHTS  4         ' Max dynamic lights supported by shader_

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------
' Light type
enum LightType
    LIGHT_DIRECTIONAL = 0
    LIGHT_POINT
end enum

' Light data
type Light   
    as LightType type_
    as boolean enabled
    as Vector3 position
    as Vector3 target
    as RayColor color_
    as single attenuation
    
    ' Shader locations
    as long enabledLoc
    as long typeLoc
    as long positionLoc
    as long targetLoc
    as long colorLoc
    as long attenuationLoc
end type


'----------------------------------------------------------------------------------
' Module Functions Declaration
'----------------------------------------------------------------------------------
declare function CreateLight(byval type_ as LightType, byval position as Vector3, byval target as Vector3, byval color_ as RayColor, byval shader_ as Shader) as Light  ' Create a light_ and get shader_ locations
declare sub UpdateLightValues(byval shader_ as Shader, byval light_ as Light)         ' Send light_ properties to shader_


#endif ' RLIGHTS_BI


/'**********************************************************************************
*
*   RLIGHTS IMPLEMENTATION
*
***********************************************************************************'/

#ifdef RLIGHTS_IMPLEMENTATION

#include once "raylib.bi"

'----------------------------------------------------------------------------------
' Defines and Macros
'----------------------------------------------------------------------------------
' ...

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------
' ...

'----------------------------------------------------------------------------------
' Global Variables Definition
'----------------------------------------------------------------------------------
dim shared lightsCount as long = 0    ' Current amount of created lights

'----------------------------------------------------------------------------------
' Module specific Functions Declaration
'----------------------------------------------------------------------------------
' ...

'----------------------------------------------------------------------------------
' Module Functions Definition
'----------------------------------------------------------------------------------

' Create a light_ and get shader_ locations
function CreateLight(byval type_ as LightType, byval position as Vector3, byval target as Vector3, byval color_ as RayColor, byval shader_ as Shader) as Light

    dim as Light light_

    if (lightsCount < MAX_LIGHTS) then
    
        light_.enabled = true
        light_.type_ = type_
        light_.position = position
        light_.target = target
        light_.color_ = color_

        ' NOTE: Lighting shader_ naming must be the provided ones
        light_.enabledLoc = GetShaderLocation(shader_, TextFormat("lights[%i].enabled", lightsCount))
        light_.typeLoc = GetShaderLocation(shader_, TextFormat("lights[%i].type", lightsCount))
        light_.positionLoc = GetShaderLocation(shader_, TextFormat("lights[%i].position", lightsCount))
        light_.targetLoc = GetShaderLocation(shader_, TextFormat("lights[%i].target", lightsCount))
        light_.colorLoc = GetShaderLocation(shader_, TextFormat("lights[%i].color", lightsCount))

        UpdateLightValues(shader_, light_)
        
        lightsCount += 1
    end if

    return light_
end function

' Send light_ properties to shader_
' NOTE: Light shader_ locations should be available 
sub UpdateLightValues(byval shader_ as Shader, byval light_ as Light)

    ' Send to shader_ light_ enabled state and type
    SetShaderValue(shader_, light_.enabledLoc, @light_.enabled, SHADER_UNIFORM_INT)
    SetShaderValue(shader_, light_.typeLoc, @light_.type_, SHADER_UNIFORM_INT)

    ' Send to shader_ light_ position values
    dim position(0 to 2) as single
    position(0) = light_.position.x
    position(1) = light_.position.y
    position(2) = light_.position.z
    
    SetShaderValue(shader_, light_.positionLoc, @position(0), SHADER_UNIFORM_VEC3)

    ' Send to shader_ light_ target position values
    dim target(0 to 2) as single
    target(0) = light_.target.x
    target(1) = light_.target.y
    target(2) = light_.target.z
    SetShaderValue(shader_, light_.targetLoc, @target(0), SHADER_UNIFORM_VEC3)

    ' Send to shader_ light_ color values
    dim color_(0 to 3) as single
    color_(0) = light_.color_.r/255
    color_(1) = light_.color_.g/255
    color_(2) = light_.color_.b/255
    color_(2) = light_.color_.a/255
    SetShaderValue(shader_, light_.colorLoc, @color_(0), SHADER_UNIFORM_VEC4)
end sub

#endif ' RLIGHTS_IMPLEMENTATION