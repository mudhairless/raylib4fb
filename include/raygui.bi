/'******************************************************************************************
*
*   raygui v4.0 - A simple and easy-to-use immediate-mode gui library
*
*   DESCRIPTION:
*       raygui is a tools-dev-focused immediate-mode-gui library based on raylib but also
*       available as a standalone library, as long as input and drawing functions are provided.
*
*   FEATURES:
*       - Immediate-mode gui, minimal retained data
*       - +25 controls provided (basic and advanced)
*       - Styling system for colors, font_ and metrics
*       - Icons supported, embedded as a 1-bit icons pack
*       - Standalone mode option (custom input/graphics backend)
*       - Multiple support tools provided for raygui development
*
*   POSSIBLE IMPROVEMENTS:
*       - Better standalone mode API for easy plug of custom backends
*       - Externalize required inputs, allow user easier customization
*
*   LIMITATIONS:
*       - No editable multi-line word-wraped text box supported
*       - No auto-layout mechanism, up to the user to define controls position and size
*       - Standalone mode requires library modification and some user work to plug another backend
*
*   NOTES:
*       - WARNING: GuiLoadStyle() and GuiLoadStyle{Custom}() functions, allocate memory for
*         font_ atlas recs and glyphs, freeing that memory is (usually) up to the user,
*         no unload function is explicitly provided... but note that GuiLoadStyleDefaulf() unloads
*         by default any previously loaded font_ (texture, recs, glyphs).
*       - Global UI alpha (guiAlpha) is applied inside GuiDrawRectangle() and GuiDrawText() functions
*
*   CONTROLS PROVIDED:
*     # Container/separators Controls
*       - WindowBox     --> StatusBar, Panel
*       - GroupBox      --> Line
*       - Line
*       - Panel         --> StatusBar
*       - ScrollPanel   --> StatusBar
*       - TabBar        --> Button
*
*     # Basic Controls
*       - Label
*       - LabelButton   --> Label
*       - Button
*       - Toggle
*       - ToggleGroup   --> Toggle
*       - ToggleSlider
*       - CheckBox
*       - ComboBox
*       - DropdownBox
*       - TextBox
*       - ValueBox      --> TextBox
*       - Spinner       --> Button, ValueBox
*       - Slider
*       - SliderBar     --> Slider
*       - ProgressBar
*       - StatusBar
*       - DummyRec
*       - Grid
*
*     # Advance Controls
*       - ListView
*       - ColorPicker   --> ColorPanel, ColorBarHue
*       - MessageBox    --> Window, Label, Button
*       - TextInputBox  --> Window, Label, TextBox, Button
*
*     It also provides a set of functions for styling the controls based on its properties (size, color_).
*
*
*   RAYGUI STYLE (guiStyle):
*       raygui uses a global data array for all gui style properties (allocated on data segment by default),
*       when a new style is loaded, it is loaded over the global style... but a default gui style could always be
*       recovered with GuiLoadStyleDefault() function, that overwrites the current style to the default one
*
*       The global style array size is fixed and depends on the number of controls and properties:
*
*           static unsigned int guiStyle[RAYGUI_MAX_CONTROLS*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED)]
*
*       guiStyle size is by default: 16*(16 + 8) = 384*4 = 1536 bytes = 1.5 KB
*
*       Note that the first set of BASE_ properties (by default guiStyle[0..15]) belong to the generic style
*       used for all controls, when any of those base values is set, it is automatically populated to all
*       controls, so, specific control values overwriting generic style should be set after base values.
*
*       After the first BASE_ set we have the EXTENDED properties (by default guiStyle[16..23]), those
*       properties are actually common to all controls and can not be overwritten individually (like BASE_ ones)
*       Some of those properties are: TEXT_SIZE, TEXT_SPACING, LINE_COLOR, BACKGROUND_COLOR
*
*       Custom control properties can be defined using the EXTENDED properties for each independent control.
*
*       TOOL: rGuiStyler is a visual tool to customize raygui style: github.com/raysan5/rguistyler
*
*
*   RAYGUI ICONS (guiIcons):
*       raygui could use a global array containing icons data (allocated on data segment by default),
*       a custom icons set could be loaded over this array using GuiLoadIcons(), but loaded icons set
*       must be same RAYGUI_ICON_SIZE and no more than RAYGUI_ICON_MAX_ICONS will be loaded
*
*       Every icon is codified in binary form, using 1 bit per pixel, so, every 16x16 icon
*       requires 8 integers (16*16/32) to be stored in memory.
*
*       When the icon is draw, actually one quad per pixel is drawn if the bit for that pixel is set.
*
*       The global icons array size is fixed and depends on the number of icons and size:
*
*           static unsigned int guiIcons[RAYGUI_ICON_MAX_ICONS*RAYGUI_ICON_DATA_ELEMENTS]
*
*       guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
*
*       TOOL: rGuiIcons is a visual tool to customize/create raygui icons: github.com/raysan5/rguiicons
*
*   RAYGUI LAYOUT:
*       raygui currently does not provide an auto-layout mechanism like other libraries,
*       layouts must be defined manually on controls drawing, providing the right bounds Rectangle for it.
*
*       TOOL: rGuiLayout is a visual tool to create raygui layouts: github.com/raysan5/rguilayout
*
*   CONFIGURATION:
*       #define USE_C_IMP
*           Defines functions to be used with the C implementation of this API.
*
*       #define RAYGUI_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*
*       #define RAYGUI_NO_ICONS
*           Avoid including embedded ricons data (256 icons, 16x16 pixels, 1-bit per pixel, 2KB)
*
*       #define RAYGUI_DEBUG_RECS_BOUNDS
*           Draw control bounds rectangles for debug
* 
*       #define RAYGUI_DEBUG_TEXT_BOUNDS
*           Draw text bounds rectangles for debug
*
*   VERSIONS HISTORY:
*       4.0 (12-Sep-2023) ADDED: GuiToggleSlider()
*                         ADDED: GuiColorPickerHSV() and GuiColorPanelHSV()
*                         ADDED: Multiple new icons, mostly compiler related
*                         ADDED: New DEFAULT properties: TEXT_LINE_SPACING, TEXT_ALIGNMENT_VERTICAL, TEXT_WRAP_MODE
*                         ADDED: New enum values: GuiTextAlignment, GuiTextAlignmentVertical, GuiTextWrapMode
*                         ADDED: Support loading styles with custom font_ charset from external file
*                         REDESIGNED: GuiTextBox(), support mouse cursor positioning
*                         REDESIGNED: GuiDrawText(), support multiline and word-wrap modes (read only)
*                         REDESIGNED: GuiProgressBar() to be more visual, progress affects border color_
*                         REDESIGNED: Global alpha consideration moved to GuiDrawRectangle() and GuiDrawText()
*                         REDESIGNED: GuiScrollPanel(), get parameters by reference and return result value
*                         REDESIGNED: GuiToggleGroup(), get parameters by reference and return result value
*                         REDESIGNED: GuiComboBox(), get parameters by reference and return result value
*                         REDESIGNED: GuiCheckBox(), get parameters by reference and return result value
*                         REDESIGNED: GuiSlider(), get parameters by reference and return result value
*                         REDESIGNED: GuiSliderBar(), get parameters by reference and return result value
*                         REDESIGNED: GuiProgressBar(), get parameters by reference and return result value
*                         REDESIGNED: GuiListView(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorPicker(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorPanel(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorBarAlpha(), get parameters by reference and return result value
*                         REDESIGNED: GuiColorBarHue(), get parameters by reference and return result value
*                         REDESIGNED: GuiGrid(), get parameters by reference and return result value
*                         REDESIGNED: GuiGrid(), added extra parameter
*                         REDESIGNED: GuiListViewEx(), change parameters order
*                         REDESIGNED: All controls return result as byval value as long
*                         REVIEWED: GuiScrollPanel() to avoid smallish scroll-bars
*                         REVIEWED: All examples and specially controls_test_suite
*                         RENAMED: gui_file_dialog module to gui_window_file_dialog
*                         UPDATED: All styles to include ISO-8859-15 charset (as much as possible)
*
*       3.6 (10-May-2023) ADDED: New icon: SAND_TIMER
*                         ADDED: GuiLoadStyleFromMemory() (binary only)
*                         REVIEWED: GuiScrollBar() horizontal movement key
*                         REVIEWED: GuiTextBox() crash on cursor movement
*                         REVIEWED: GuiTextBox(), additional inputs support
*                         REVIEWED: GuiLabelButton(), avoid text cut
*                         REVIEWED: GuiTextInputBox(), password input
*                         REVIEWED: Local GetCodepointNext(), aligned with raylib
*                         REDESIGNED: GuiSlider*()/GuiScrollBar() to support out-of-bounds
*
*       3.5 (20-Apr-2023) ADDED: GuiTabBar(), based on GuiToggle()
*                         ADDED: Helper functions to split text in separate lines
*                         ADDED: Multiple new icons, useful for code editing tools
*                         REMOVED: Unneeded icon editing functions
*                         REMOVED: GuiTextBoxMulti(), very limited and broken
*                         REMOVED: MeasureTextEx() dependency, logic directly implemented
*                         REMOVED: DrawTextEx() dependency, logic directly implemented
*                         REVIEWED: GuiScrollBar(), improve mouse-click behaviour
*                         REVIEWED: Library header info, more info, better organized
*                         REDESIGNED: GuiTextBox() to support cursor movement
*                         REDESIGNED: GuiDrawText() to divide drawing by lines
*
*       3.2 (22-May-2022) RENAMED: Some enum values, for unification, avoiding prefixes
*                         REMOVED: GuiScrollBar(), only internal
*                         REDESIGNED: GuiPanel() to support text parameter
*                         REDESIGNED: GuiScrollPanel() to support text parameter
*                         REDESIGNED: GuiColorPicker() to support text parameter
*                         REDESIGNED: GuiColorPanel() to support text parameter
*                         REDESIGNED: GuiColorBarAlpha() to support text parameter
*                         REDESIGNED: GuiColorBarHue() to support text parameter
*                         REDESIGNED: GuiTextInputBox() to support password
*
*       3.1 (12-Jan-2022) REVIEWED: Default style for consistency (aligned with rGuiLayout v2.5 tool)
*                         REVIEWED: GuiLoadStyle() to support compressed font_ atlas image data and unload previous textures
*                         REVIEWED: External icons usage logic
*                         REVIEWED: GuiLine() for centered alignment when including text
*                         RENAMED: Multiple controls properties definitions to prepend RAYGUI_
*                         RENAMED: RICON_ references to RAYGUI_ICON_ for library consistency
*                         Projects updated and multiple tweaks
*
*       3.0 (04-Nov-2021) Integrated ricons data to avoid external file
*                         REDESIGNED: GuiTextBoxMulti()
*                         REMOVED: GuiImageButton*()
*                         Multiple minor tweaks and bugs corrected
*
*       2.9 (17-Mar-2021) REMOVED: Tooltip API
*       2.8 (03-May-2020) Centralized rectangles drawing to GuiDrawRectangle()
*       2.7 (20-Feb-2020) ADDED: Possible tooltips API
*       2.6 (09-Sep-2019) ADDED: GuiTextInputBox()
*                         REDESIGNED: GuiListView*(), GuiDropdownBox(), GuiSlider*(), GuiProgressBar(), GuiMessageBox()
*                         REVIEWED: GuiTextBox(), GuiSpinner(), GuiValueBox(), GuiLoadStyle()
*                         Replaced property INNER_PADDING by TEXT_PADDING, renamed some properties
*                         ADDED: 8 new custom styles ready to use
*                         Multiple minor tweaks and bugs corrected
*
*       2.5 (28-May-2019) Implemented extended GuiTextBox(), GuiValueBox(), GuiSpinner()
*       2.3 (29-Apr-2019) ADDED: rIcons auxiliar library and support for it, multiple controls reviewed
*                         Refactor all controls drawing mechanism to use control state
*       2.2 (05-Feb-2019) ADDED: GuiScrollBar(), GuiScrollPanel(), reviewed GuiListView(), removed Gui*Ex() controls
*       2.1 (26-Dec-2018) REDESIGNED: GuiCheckBox(), GuiComboBox(), GuiDropdownBox(), GuiToggleGroup() > Use combined text string
*                         REDESIGNED: Style system (breaking change)
*       2.0 (08-Nov-2018) ADDED: Support controls guiLock and custom fonts
*                         REVIEWED: GuiComboBox(), GuiListView()...
*       1.9 (09-Oct-2018) REVIEWED: GuiGrid(), GuiTextBox(), GuiTextBoxMulti(), GuiValueBox()...
*       1.8 (01-May-2018) Lot of rework and redesign to align with rGuiStyler and rGuiLayout
*       1.5 (21-Jun-2017) Working in an improved styles system
*       1.4 (15-Jun-2017) Rewritten all GUI functions (removed useless ones)
*       1.3 (12-Jun-2017) Complete redesign of style system
*       1.1 (01-Jun-2017) Complete review of the library
*       1.0 (07-Jun-2016) Converted to header-only by Ramon Santamaria.
*       0.9 (07-Mar-2016) Reviewed and tested by Albert Martos, Ian Eito, Sergio Martinez and Ramon Santamaria.
*       0.8 (27-Aug-2015) Initial release. Implemented by Kevin Gato, Daniel Nicolás and Ramon Santamaria.
*
*   DEPENDENCIES:
*       raylib 4.6-dev      Inputs reading (keyboard/mouse), shapes drawing, font_ loading and text drawing
*
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, redesign, update and maintenance
*       Vlad Adrian:        Complete rewrite of GuiTextBox() to support extended features (2019)
*       Sergio Martinez:    Review, testing (2015) and redesign of multiple controls (2018)
*       Adria Arranz:       Testing and implementation of additional controls (2018)
*       Jordi Jorba:        Testing and implementation of additional controls (2018)
*       Albert Martos:      Review and testing of the library (2015)
*       Ian Eito:           Review and testing of the library (2015)
*       Kevin Gato:         Initial implementation of basic components (2014)
*       Daniel Nicolas:     Initial implementation of basic components (2014)
*       Ebben Feagan:       Translated to FreeBASIC
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
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

#ifndef RAYGUI_BI
#define RAYGUI_BI

#ifdef USE_C_IMP
#ifdef RAYGUI_IMPLEMENTATION
#error "The defines USE_C_IMP and RAYGUI_IMPLEMENTATION cannot be used together."
#endif
#endif

#define RAYGUI_VERSION_MAJOR 4
#define RAYGUI_VERSION_MINOR 0
#define RAYGUI_VERSION_PATCH 0
#define RAYGUI_VERSION  "4.0"

#include once "raylib.bi"

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------

' Style property
' NOTE: Used when exporting style as code for convenience
type GuiStyleProp 
    as ushort controlId   ' Control identifier
    as ushort propertyId  ' Property identifier
    as long propertyValue          ' Property value
end type

' Gui control state
enum GuiState
    STATE_NORMAL = 0
    STATE_FOCUSED
    STATE_PRESSED
    STATE_DISABLED
end enum

' Gui control text alignment
enum GuiTextAlignment
    TEXT_ALIGN_LEFT = 0
    TEXT_ALIGN_CENTER
    TEXT_ALIGN_RIGHT
end enum

' Gui control text alignment vertical
' NOTE: Text vertical position inside the text bounds
enum GuiTextAlignmentVertical
    TEXT_ALIGN_TOP = 0
    TEXT_ALIGN_MIDDLE
    TEXT_ALIGN_BOTTOM
end enum

' Gui control text wrap mode
' NOTE: Useful for multiline text
enum GuiTextWrapMode
    TEXT_WRAP_NONE = 0
    TEXT_WRAP_CHAR
    TEXT_WRAP_WORD
end enum

' Gui controls
enum GuiControl
    ' Default -> populates to all controls when set
    DEFAULT = 0
    
    ' Basic controls
    LABEL          ' Used also for: LABELBUTTON
    BUTTON
    TOGGLE        ' Used also for: TOGGLEGROUP
    SLIDER_         ' Used also for: SLIDERBAR, TOGGLESLIDER
    PROGRESSBAR
    CHECKBOX
    COMBOBOX
    DROPDOWNBOX
    TEXTBOX        ' Used also for: TEXTBOXMULTI
    VALUEBOX
    SPINNER_        ' Uses: BUTTON, VALUEBOX
    LISTVIEW
    COLORPICKER
    SCROLLBAR_
    STATUSBAR
end enum

' Gui base properties for every control
' NOTE: RAYGUI_MAX_PROPS_BASE properties (by default 16 properties)
enum GuiControlProperty
    BORDER_COLOR_NORMAL = 0    ' Control border color_ in STATE_NORMAL
    BASE_COLOR_NORMAL          ' Control base color_ in STATE_NORMAL
    TEXT_COLOR_NORMAL          ' Control text color_ in STATE_NORMAL
    BORDER_COLOR_FOCUSED       ' Control border color_ in STATE_FOCUSED
    BASE_COLOR_FOCUSED         ' Control base color_ in STATE_FOCUSED
    TEXT_COLOR_FOCUSED         ' Control text color_ in STATE_FOCUSED
    BORDER_COLOR_PRESSED       ' Control border color_ in STATE_PRESSED
    BASE_COLOR_PRESSED         ' Control base color_ in STATE_PRESSED
    TEXT_COLOR_PRESSED         ' Control text color_ in STATE_PRESSED
    BORDER_COLOR_DISABLED      ' Control border color_ in STATE_DISABLED
    BASE_COLOR_DISABLED        ' Control base color_ in STATE_DISABLED
    TEXT_COLOR_DISABLED        ' Control text color_ in STATE_DISABLED
    BORDER_WIDTH               ' Control border size, 0 for no border
    TEXT_PADDING               ' Control text padding, not considering border
    TEXT_ALIGNMENT             ' Control text horizontal alignment inside control text bound (after border and padding)
end enum

' Gui extended properties depend on control
' NOTE: RAYGUI_MAX_PROPS_EXTENDED properties (by default, max 8 properties)
'----------------------------------------------------------------------------------
' DEFAULT extended properties
' NOTE: Those properties are common to all controls or global
' WARNING: We only have 8 slots for those properties by defaultnotnotnot -> New global control: TEXT_?
enum GuiDefaultProperty
    TEXT_SIZE = 16             ' Text size (glyphs max height)
    TEXT_SPACING               ' Text spacing between glyphs
    LINE_COLOR                 ' Line control color_
    BACKGROUND_COLOR           ' Background color_
    TEXT_LINE_SPACING          ' Text spacing between lines
    TEXT_ALIGNMENT_VERTICAL    ' Text vertical alignment inside text bounds (after border and padding)
    TEXT_WRAP_MODE              ' Text wrap-mode inside text bounds
end enum

' Toggle/ToggleGroup
#define GROUP_PADDING 16         ' ToggleGroup separation between toggles

' Slider/SliderBar
enum GuiSliderProperty
    SLIDER_WIDTH = 16          ' Slider size of internal bar
    SLIDER_PADDING              ' Slider/SliderBar internal bar padding
end enum

' ProgressBar
#define PROGRESS_PADDING 16      ' ProgressBar internal padding

' ScrollBar
enum GuiScrollBarProperty
    ARROWS_SIZE = 16           ' ScrollBar arrows size
    ARROWS_VISIBLE             ' ScrollBar arrows visible
    SCROLL_SLIDER_PADDING      ' ScrollBar slider internal padding
    SCROLL_SLIDER_SIZE         ' ScrollBar slider size
    SCROLL_PADDING             ' ScrollBar scroll padding from arrows
    SCROLL_SPEED               ' ScrollBar scrolling speed
end enum

' CheckBox
#define CHECK_PADDING 16          ' CheckBox internal check padding

' ComboBox
enum GuiComboBoxProperty
    COMBO_BUTTON_WIDTH = 16    ' ComboBox right button width_
    COMBO_BUTTON_SPACING        ' ComboBox button separation
end enum

' DropdownBox
enum GuiDropdownBoxProperty
    ARROW_PADDING = 16         ' DropdownBox arrow separation from border and items
    DROPDOWN_ITEMS_SPACING      ' DropdownBox items separation
end enum

' TextBox/TextBoxMulti/ValueBox/Spinner
#define TEXT_READONLY 16         ' TextBox in read-only mode: 0-text editable, 1-text no-editable

' Spinner
enum GuiSpinnerProperty
    SPIN_BUTTON_WIDTH = 16     ' Spinner left/right buttons width_
    SPIN_BUTTON_SPACING        ' Spinner buttons separation
end enum

' ListView
enum GuiListViewProperty
    LIST_ITEMS_HEIGHT = 16     ' ListView items height
    LIST_ITEMS_SPACING         ' ListView items separation
    SCROLLBAR_WIDTH            ' ListView scrollbar size (usually width_)
    SCROLLBAR_SIDE             ' ListView scrollbar side (0-SCROLLBAR_LEFT_SIDE, 1-SCROLLBAR_RIGHT_SIDE)
end enum

' ColorPicker
enum GuiColorPickerProperty
    COLOR_SELECTOR_SIZE = 16
    HUEBAR_WIDTH               ' ColorPicker right hue bar width_
    HUEBAR_PADDING             ' ColorPicker right hue bar separation from panel
    HUEBAR_SELECTOR_HEIGHT     ' ColorPicker right hue bar selector height
    HUEBAR_SELECTOR_OVERFLOW    ' ColorPicker right hue bar selector overflow
end enum

#define SCROLLBAR_LEFT_SIDE     0
#define SCROLLBAR_RIGHT_SIDE    1

#ifndef RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT
    #define RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT        24
#endif

#ifndef RAYGUI_MESSAGEBOX_BUTTON_HEIGHT
    #define RAYGUI_MESSAGEBOX_BUTTON_HEIGHT    24
#endif
#ifndef RAYGUI_MESSAGEBOX_BUTTON_PADDING
    #define RAYGUI_MESSAGEBOX_BUTTON_PADDING   12
#endif

#define MAX_LINE_BUFFER_SIZE    256

'----------------------------------------------------------------------------------
' Module Functions Declaration
'----------------------------------------------------------------------------------
#ifdef USE_C_IMP
extern "C"
#endif

' Global gui state control functions
declare sub GuiEnable()                                 ' Enable gui controls (global state)
declare sub GuiDisable()                                ' Disable gui controls (global state)
declare sub GuiLock()                                   ' Lock gui controls (global state)
declare sub GuiUnlock()                                 ' Unlock gui controls (global state)
declare function GuiIsLocked() as boolean                               ' Check if gui is locked (global state)
declare sub GuiSetAlpha(byval alpha as single)                        ' Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
declare sub GuiSetState(byval state as GuiState)                          ' Set gui state (global state)
declare function GuiGetState() as GuiState                                ' Get gui state (global state)

' Font set/get functions
declare sub GuiSetFont(byval font_ as Font)                           ' Set gui custom font_ (global state)
declare function GuiGetFont() as Font                                ' Get gui custom font_ (global state)

' Style set/get functions
declare sub GuiSetStyle(byval control as long, byval property_ as long, byval value as long) ' Set one style property
declare function GuiGetStyle(byval control as long, byval property_ as long) as long           ' Get one style property

' Styles loading functions
declare sub GuiLoadStyle(byval fileName as const zstring ptr)              ' Load style file over global style variable (.rgs)
declare sub GuiLoadStyleDefault()                       ' Load style default over global style

' Tooltips management functions
declare sub GuiEnableTooltip()                          ' Enable gui tooltips (global state)
declare sub GuiDisableTooltip()                         ' Disable gui tooltips (global state)
declare sub GuiSetTooltip(byval tooltip as const zstring ptr)              ' Set tooltip string

' Icons functionality
declare function GuiIconText(byval iconId as long, byval text as const zstring ptr) as const zstring ptr ' Get text with icon id prepended (if supported)
#ifndef RAYGUI_NO_ICONS
declare sub GuiSetIconScale(byval scale as long)                      ' Set default icon drawing size
declare function GuiGetIcons() as ulong ptr                      ' Get raygui icons data pointer
declare function GuiLoadIcons(byval fileName as const zstring ptr, byval loadIconsName as boolean) as zstring ptr ptr ' Load raygui icons file (.rgi) into internal icons data
declare sub GuiDrawIcon(byval iconId as long, byval posX as long, byval posY as long, byval pixelSize as long, byval color_ as RayColor) ' Draw icon using pixel size at specified position
#endif

' Controls
'----------------------------------------------------------------------------------------------------------
' Container/separator controls, useful for controls organization
declare function GuiWindowBox(byval bounds as Rectangle, byval title as const zstring ptr) as long                                       ' Window Box control, shows a window that can be closed
declare function GuiGroupBox(byval bounds as Rectangle, byval text as const zstring ptr) as long                                         ' Group Box control with text name
declare function GuiLine(byval bounds as Rectangle, byval text as const zstring ptr) as long                                             ' Line separator control, could contain text
declare function GuiPanel(byval bounds as Rectangle, byval text as const zstring ptr) as long                                            ' Panel control, useful to group controls
declare function GuiTabBar(byval bounds as Rectangle, byval text as const zstring ptr ptr, byval count as long, byval active as long ptr) as long                  ' Tab Bar control, returns TAB to be closed or -1
declare function GuiScrollPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval content as Rectangle, byval scroll as Vector2 ptr, byval view_ as Rectangle ptr) as long ' Scroll Panel control

' Basic controls set
declare function GuiLabel(byval bounds as Rectangle, byval text as const zstring ptr) as long                                            ' Label control, shows text
declare function GuiButton(byval bounds as Rectangle, byval text as const zstring ptr) as long                                           ' Button control, returns true when clicked
declare function GuiLabelButton(byval bounds as Rectangle, byval text as const zstring ptr) as long                                      ' Label button control, show true when clicked
declare function GuiToggle(byval bounds as Rectangle, byval text as const zstring ptr, byval active as boolean ptr) as long                             ' Toggle Button control, returns true when active
declare function GuiToggleGroup(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long                         ' Toggle Group control, returns active toggle index
declare function GuiToggleSlider(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long                        ' Toggle Slider control, returns true when clicked
declare function GuiCheckBox(byval bounds as Rectangle, byval text as const zstring ptr, byval checked as boolean ptr) as long                          ' Check Box control, returns true when active
declare function GuiComboBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long                            ' Combo Box control, returns selected item index

declare function GuiDropdownBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr, byval editMode as boolean) as long          ' Dropdown Box control, returns selected item
declare function GuiSpinner(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as long ' Spinner control, returns selected value
declare function GuiValueBox(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as long ' Value Box control, updates input text with numbers
declare function GuiTextBox(byval bounds as Rectangle, byval text as zstring ptr, byval textSize as long, byval editMode as boolean) as long                   ' Text Box control, updates input text

declare function GuiSlider(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long ' Slider control, returns selected value
declare function GuiSliderBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long ' Slider Bar control, returns selected value
declare function GuiProgressBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long ' Progress Bar control, shows current progress value
declare function GuiStatusBar(byval bounds as Rectangle, byval text as const zstring ptr) as long                                        ' Status Bar control, shows info text
declare function GuiDummyRec(byval bounds as Rectangle, byval text as const zstring ptr) as long                                         ' Dummy control for placeholders
declare function GuiGrid(byval bounds as Rectangle, byval text as const zstring ptr, byval spacing as single, byval subdivs as long, byval mouseCell as Vector2 ptr) as long ' Grid control, returns mouse cell position

' Advance controls set
declare function GuiListView(byval bounds as Rectangle, byval text as const zstring ptr, byval scrollIndex as long ptr, byval active as long ptr) as long          ' List View control, returns selected list item index
declare function GuiListViewEx(byval bounds as Rectangle, byval text as const zstring ptr ptr, byval count as long, byval scrollIndex as long ptr, byval active as long ptr, byval focus as long ptr) as long ' List View with extended parameters
declare function GuiMessageBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr) as long ' Message Box control, displays a message
declare function GuiTextInputBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr, byval text as zstring ptr, byval textMaxSize as long, byval secretViewActive as boolean ptr) as long ' Text Input Box control, ask for text, supports secret
declare function GuiColorPicker(byval bounds as Rectangle, byval text as const zstring ptr, byval color_ as RayColor ptr) as long                        ' RayColor Picker control (multiple color_ controls)
declare function GuiColorPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval color_ as RayColor ptr) as long                         ' RayColor Panel control
declare function GuiColorBarAlpha(byval bounds as Rectangle, byval text as const zstring ptr, byval alpha as single ptr) as long                      ' RayColor Bar Alpha control
declare function GuiColorBarHue(byval bounds as Rectangle, byval text as const zstring ptr, byval value as single ptr) as long                        ' RayColor Bar Hue control
declare function GuiColorPickerHSV(byval bounds as Rectangle, byval text as const zstring ptr, byval colorHsv as Vector3 ptr) as long                ' RayColor Picker control that avoids conversion to RGB on each call (multiple color_ controls)
declare function GuiColorPanelHSV(byval bounds as Rectangle, byval text as const zstring ptr, byval colorHsv as Vector3 ptr) as long                 ' RayColor Panel control that returns HSV color_ value, used by GuiColorPickerHSV()
'----------------------------------------------------------------------------------------------------------
#ifdef USE_C_IMP
end extern
#endif

#ifndef RAYGUI_NO_ICONS
'----------------------------------------------------------------------------------
' Icons enumeration
'----------------------------------------------------------------------------------
enum GuiIconName
    ICON_NONE                     = 0
    ICON_FOLDER_FILE_OPEN         = 1
    ICON_FILE_SAVE_CLASSIC        = 2
    ICON_FOLDER_OPEN              = 3
    ICON_FOLDER_SAVE              = 4
    ICON_FILE_OPEN                = 5
    ICON_FILE_SAVE                = 6
    ICON_FILE_EXPORT              = 7
    ICON_FILE_ADD                 = 8
    ICON_FILE_DELETE              = 9
    ICON_FILETYPE_TEXT            = 10
    ICON_FILETYPE_AUDIO           = 11
    ICON_FILETYPE_IMAGE           = 12
    ICON_FILETYPE_PLAY            = 13
    ICON_FILETYPE_VIDEO           = 14
    ICON_FILETYPE_INFO            = 15
    ICON_FILE_COPY                = 16
    ICON_FILE_CUT                 = 17
    ICON_FILE_PASTE               = 18
    ICON_CURSOR_HAND              = 19
    ICON_CURSOR_POINTER           = 20
    ICON_CURSOR_CLASSIC           = 21
    ICON_PENCIL                   = 22
    ICON_PENCIL_BIG               = 23
    ICON_BRUSH_CLASSIC            = 24
    ICON_BRUSH_PAINTER            = 25
    ICON_WATER_DROP               = 26
    ICON_COLOR_PICKER             = 27
    ICON_RUBBER                   = 28
    ICON_COLOR_BUCKET             = 29
    ICON_TEXT_T                   = 30
    ICON_TEXT_A                   = 31
    ICON_SCALE                    = 32
    ICON_RESIZE                   = 33
    ICON_FILTER_POINT             = 34
    ICON_FILTER_BILINEAR          = 35
    ICON_CROP                     = 36
    ICON_CROP_ALPHA               = 37
    ICON_SQUARE_TOGGLE            = 38
    ICON_SYMMETRY                 = 39
    ICON_SYMMETRY_HORIZONTAL      = 40
    ICON_SYMMETRY_VERTICAL        = 41
    ICON_LENS                     = 42
    ICON_LENS_BIG                 = 43
    ICON_EYE_ON                   = 44
    ICON_EYE_OFF                  = 45
    ICON_FILTER_TOP               = 46
    ICON_FILTER                   = 47
    ICON_TARGET_POINT             = 48
    ICON_TARGET_SMALL             = 49
    ICON_TARGET_BIG               = 50
    ICON_TARGET_MOVE              = 51
    ICON_CURSOR_MOVE              = 52
    ICON_CURSOR_SCALE             = 53
    ICON_CURSOR_SCALE_RIGHT       = 54
    ICON_CURSOR_SCALE_LEFT        = 55
    ICON_UNDO                     = 56
    ICON_REDO                     = 57
    ICON_REREDO                   = 58
    ICON_MUTATE                   = 59
    ICON_ROTATE                   = 60
    ICON_REPEAT                   = 61
    ICON_SHUFFLE                  = 62
    ICON_EMPTYBOX                 = 63
    ICON_TARGET                   = 64
    ICON_TARGET_SMALL_FILL        = 65
    ICON_TARGET_BIG_FILL          = 66
    ICON_TARGET_MOVE_FILL         = 67
    ICON_CURSOR_MOVE_FILL         = 68
    ICON_CURSOR_SCALE_FILL        = 69
    ICON_CURSOR_SCALE_RIGHT_FILL  = 70
    ICON_CURSOR_SCALE_LEFT_FILL   = 71
    ICON_UNDO_FILL                = 72
    ICON_REDO_FILL                = 73
    ICON_REREDO_FILL              = 74
    ICON_MUTATE_FILL              = 75
    ICON_ROTATE_FILL              = 76
    ICON_REPEAT_FILL              = 77
    ICON_SHUFFLE_FILL             = 78
    ICON_EMPTYBOX_SMALL           = 79
    ICON_BOX                      = 80
    ICON_BOX_TOP                  = 81
    ICON_BOX_TOP_RIGHT            = 82
    ICON_BOX_RIGHT                = 83
    ICON_BOX_BOTTOM_RIGHT         = 84
    ICON_BOX_BOTTOM               = 85
    ICON_BOX_BOTTOM_LEFT          = 86
    ICON_BOX_LEFT                 = 87
    ICON_BOX_TOP_LEFT             = 88
    ICON_BOX_CENTER               = 89
    ICON_BOX_CIRCLE_MASK          = 90
    ICON_POT                      = 91
    ICON_ALPHA_MULTIPLY           = 92
    ICON_ALPHA_CLEAR              = 93
    ICON_DITHERING                = 94
    ICON_MIPMAPS                  = 95
    ICON_BOX_GRID                 = 96
    ICON_GRID                     = 97
    ICON_BOX_CORNERS_SMALL        = 98
    ICON_BOX_CORNERS_BIG          = 99
    ICON_FOUR_BOXES               = 100
    ICON_GRID_FILL                = 101
    ICON_BOX_MULTISIZE            = 102
    ICON_ZOOM_SMALL               = 103
    ICON_ZOOM_MEDIUM              = 104
    ICON_ZOOM_BIG                 = 105
    ICON_ZOOM_ALL                 = 106
    ICON_ZOOM_CENTER              = 107
    ICON_BOX_DOTS_SMALL           = 108
    ICON_BOX_DOTS_BIG             = 109
    ICON_BOX_CONCENTRIC           = 110
    ICON_BOX_GRID_BIG             = 111
    ICON_OK_TICK                  = 112
    ICON_CROSS                    = 113
    ICON_ARROW_LEFT               = 114
    ICON_ARROW_RIGHT              = 115
    ICON_ARROW_DOWN               = 116
    ICON_ARROW_UP                 = 117
    ICON_ARROW_LEFT_FILL          = 118
    ICON_ARROW_RIGHT_FILL         = 119
    ICON_ARROW_DOWN_FILL          = 120
    ICON_ARROW_UP_FILL            = 121
    ICON_AUDIO                    = 122
    ICON_FX                       = 123
    ICON_WAVE                     = 124
    ICON_WAVE_SINUS               = 125
    ICON_WAVE_SQUARE              = 126
    ICON_WAVE_TRIANGULAR          = 127
    ICON_CROSS_SMALL              = 128
    ICON_PLAYER_PREVIOUS          = 129
    ICON_PLAYER_PLAY_BACK         = 130
    ICON_PLAYER_PLAY              = 131
    ICON_PLAYER_PAUSE             = 132
    ICON_PLAYER_STOP              = 133
    ICON_PLAYER_NEXT              = 134
    ICON_PLAYER_RECORD            = 135
    ICON_MAGNET                   = 136
    ICON_LOCK_CLOSE               = 137
    ICON_LOCK_OPEN                = 138
    ICON_CLOCK                    = 139
    ICON_TOOLS                    = 140
    ICON_GEAR                     = 141
    ICON_GEAR_BIG                 = 142
    ICON_BIN                      = 143
    ICON_HAND_POINTER             = 144
    ICON_LASER                    = 145
    ICON_COIN                     = 146
    ICON_EXPLOSION                = 147
    ICON_1UP                      = 148
    ICON_PLAYER                   = 149
    ICON_PLAYER_JUMP              = 150
    ICON_KEY                      = 151
    ICON_DEMON                    = 152
    ICON_TEXT_POPUP               = 153
    ICON_GEAR_EX                  = 154
    ICON_CRACK                    = 155
    ICON_CRACK_POINTS             = 156
    ICON_STAR                     = 157
    ICON_DOOR                     = 158
    ICON_EXIT                     = 159
    ICON_MODE_2D                  = 160
    ICON_MODE_3D                  = 161
    ICON_CUBE                     = 162
    ICON_CUBE_FACE_TOP            = 163
    ICON_CUBE_FACE_LEFT           = 164
    ICON_CUBE_FACE_FRONT          = 165
    ICON_CUBE_FACE_BOTTOM         = 166
    ICON_CUBE_FACE_RIGHT          = 167
    ICON_CUBE_FACE_BACK           = 168
    ICON_CAMERA                   = 169
    ICON_SPECIAL                  = 170
    ICON_LINK_NET                 = 171
    ICON_LINK_BOXES               = 172
    ICON_LINK_MULTI               = 173
    ICON_LINK                     = 174
    ICON_LINK_BROKE               = 175
    ICON_TEXT_NOTES               = 176
    ICON_NOTEBOOK                 = 177
    ICON_SUITCASE                 = 178
    ICON_SUITCASE_ZIP             = 179
    ICON_MAILBOX                  = 180
    ICON_MONITOR                  = 181
    ICON_PRINTER                  = 182
    ICON_PHOTO_CAMERA             = 183
    ICON_PHOTO_CAMERA_FLASH       = 184
    ICON_HOUSE                    = 185
    ICON_HEART                    = 186
    ICON_CORNER                   = 187
    ICON_VERTICAL_BARS            = 188
    ICON_VERTICAL_BARS_FILL       = 189
    ICON_LIFE_BARS                = 190
    ICON_INFO                     = 191
    ICON_CROSSLINE                = 192
    ICON_HELP                     = 193
    ICON_FILETYPE_ALPHA           = 194
    ICON_FILETYPE_HOME            = 195
    ICON_LAYERS_VISIBLE           = 196
    ICON_LAYERS                   = 197
    ICON_WINDOW                   = 198
    ICON_HIDPI                    = 199
    ICON_FILETYPE_BINARY          = 200
    ICON_HEX                      = 201
    ICON_SHIELD                   = 202
    ICON_FILE_NEW                 = 203
    ICON_FOLDER_ADD               = 204
    ICON_ALARM                    = 205
    ICON_CPU                      = 206
    ICON_ROM                      = 207
    ICON_STEP_OVER                = 208
    ICON_STEP_INTO                = 209
    ICON_STEP_OUT                 = 210
    ICON_RESTART                  = 211
    ICON_BREAKPOINT_ON            = 212
    ICON_BREAKPOINT_OFF           = 213
    ICON_BURGER_MENU              = 214
    ICON_CASE_SENSITIVE           = 215
    ICON_REG_EXP                  = 216
    ICON_FOLDER                   = 217
    ICON_FILE                     = 218
    ICON_SAND_TIMER               = 219
    ICON_220                      = 220
    ICON_221                      = 221
    ICON_222                      = 222
    ICON_223                      = 223
    ICON_224                      = 224
    ICON_225                      = 225
    ICON_226                      = 226
    ICON_227                      = 227
    ICON_228                      = 228
    ICON_229                      = 229
    ICON_230                      = 230
    ICON_231                      = 231
    ICON_232                      = 232
    ICON_233                      = 233
    ICON_234                      = 234
    ICON_235                      = 235
    ICON_236                      = 236
    ICON_237                      = 237
    ICON_238                      = 238
    ICON_239                      = 239
    ICON_240                      = 240
    ICON_241                      = 241
    ICON_242                      = 242
    ICON_243                      = 243
    ICON_244                      = 244
    ICON_245                      = 245
    ICON_246                      = 246
    ICON_247                      = 247
    ICON_248                      = 248
    ICON_249                      = 249
    ICON_250                      = 250
    ICON_251                      = 251
    ICON_252                      = 252
    ICON_253                      = 253
    ICON_254                      = 254
    ICON_255                      = 255
end enum

#endif ' RAYGUI_NO_ICONS
#endif ' RAYGUI_BI

/'**********************************************************************************
*
*   RAYGUI IMPLEMENTATION
*
***********************************************************************************'/

#ifdef RAYGUI_IMPLEMENTATION

#include "crt/stdio.bi"              ' Required for: FILE, fopen(), fclose(), fprintf(), feof(), fscanf(), vsprintf() [GuiLoadStyle(), GuiLoadIcons()]
#include "crt/stdlib.bi"             ' Required for: malloc(), calloc(), free() [GuiLoadStyle(), GuiLoadIcons()]
#include "crt/string.bi"             ' Required for: strlen() [GuiTextBox(), GuiValueBox()], memset(), memcpy()
#include "crt/stdarg.bi"             ' Required for: va_list, va_start(), vfprintf(), va_end() [TextFormat()]
#include "crt/math.bi"               ' Required for: roundf() [GuiColorPicker()]


' Check if two rectangles are equal, used to validate a slider bounds as an id
#ifndef CHECK_BOUNDS_ID
    #macro CHECK_BOUNDS_ID(src, dst) 
    ((src.x = dst.x) AND (src.y = dst.y) AND (src.width_ = dst.width_) AND (src.height = dst.height))
    #endmacro
#endif

#ifndef RAYGUI_NO_ICONS

' Embedded icons, no external file provided
#define RAYGUI_ICON_SIZE               16          ' Size of icons in pixels (squared)
#define RAYGUI_ICON_MAX_ICONS         256          ' Maximum number of icons
#define RAYGUI_ICON_MAX_NAME_LENGTH    32          ' Maximum length of icon name id

' Icons data is defined by bit array (every bit represents one pixel)
' Those arrays are stored as unsigned int data arrays, so,
' every array element defines 32 pixels (bits) of information
' One icon is defined by 8 int, (8 int * 32 bit = 256 bit = 16*16 pixels)
' NOTE: Number of elemens depend on RAYGUI_ICON_SIZE (by default 16x16 pixels)
#define RAYGUI_ICON_DATA_ELEMENTS   (RAYGUI_ICON_SIZE*RAYGUI_ICON_SIZE/32)

'----------------------------------------------------------------------------------
' Icons data for all gui possible icons (allocated on data segment by default)
'
' NOTE 1: Every icon is codified in binary form, using 1 bit per pixel, so,
' every 16x16 icon requires 8 integers (16*16/32) to be stored
'
' NOTE 2: A different icon set could be loaded over this array using GuiLoadIcons(),
' but loaded icons set must be same RAYGUI_ICON_SIZE and no more than RAYGUI_ICON_MAX_ICONS
'
' guiIcons size is by default: 256*(16*16/32) = 2048*4 = 8192 bytes = 8 KB
'----------------------------------------------------------------------------------
dim shared as ulong guiIcons(0 to (RAYGUI_ICON_MAX_ICONS*RAYGUI_ICON_DATA_ELEMENTS) - 1) = { _
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_NONE
    &h3ff80000, &h2f082008, &h2042207e, &h40027fc2, &h40024002, &h40024002, &h40024002, &h00007ffe, _     ' ICON_FOLDER_FILE_OPEN
    &h3ffe0000, &h44226422, &h400247e2, &h5ffa4002, &h57ea500a, &h500a500a, &h40025ffa, &h00007ffe, _     ' ICON_FILE_SAVE_CLASSIC
    &h00000000, &h0042007e, &h40027fc2, &h40024002, &h41024002, &h44424282, &h793e4102, &h00000100, _     ' ICON_FOLDER_OPEN
    &h00000000, &h0042007e, &h40027fc2, &h40024002, &h41024102, &h44424102, &h793e4282, &h00000000, _     ' ICON_FOLDER_SAVE
    &h3ff00000, &h201c2010, &h20042004, &h21042004, &h24442284, &h21042104, &h20042104, &h00003ffc, _     ' ICON_FILE_OPEN
    &h3ff00000, &h201c2010, &h20042004, &h21042004, &h21042104, &h22842444, &h20042104, &h00003ffc, _     ' ICON_FILE_SAVE
    &h3ff00000, &h201c2010, &h00042004, &h20041004, &h20844784, &h00841384, &h20042784, &h00003ffc, _     ' ICON_FILE_EXPORT
    &h3ff00000, &h201c2010, &h20042004, &h20042004, &h22042204, &h22042f84, &h20042204, &h00003ffc, _     ' ICON_FILE_ADD
    &h3ff00000, &h201c2010, &h20042004, &h20042004, &h25042884, &h25042204, &h20042884, &h00003ffc, _     ' ICON_FILE_DELETE
    &h3ff00000, &h201c2010, &h20042004, &h20042ff4, &h20042ff4, &h20042ff4, &h20042004, &h00003ffc, _     ' ICON_FILETYPE_TEXT
    &h3ff00000, &h201c2010, &h27042004, &h244424c4, &h26442444, &h20642664, &h20042004, &h00003ffc, _     ' ICON_FILETYPE_AUDIO
    &h3ff00000, &h201c2010, &h26042604, &h20042004, &h35442884, &h2414222c, &h20042004, &h00003ffc, _     ' ICON_FILETYPE_IMAGE
    &h3ff00000, &h201c2010, &h20c42004, &h22442144, &h22442444, &h20c42144, &h20042004, &h00003ffc, _     ' ICON_FILETYPE_PLAY
    &h3ff00000, &h3ffc2ff0, &h3f3c2ff4, &h3dbc2eb4, &h3dbc2bb4, &h3f3c2eb4, &h3ffc2ff4, &h00002ff4, _     ' ICON_FILETYPE_VIDEO
    &h3ff00000, &h201c2010, &h21842184, &h21842004, &h21842184, &h21842184, &h20042184, &h00003ffc, _     ' ICON_FILETYPE_INFO
    &h0ff00000, &h381c0810, &h28042804, &h28042804, &h28042804, &h28042804, &h20102ffc, &h00003ff0, _     ' ICON_FILE_COPY
    &h00000000, &h701c0000, &h079c1e14, &h55a000f0, &h079c00f0, &h701c1e14, &h00000000, &h00000000, _     ' ICON_FILE_CUT
    &h01c00000, &h13e41bec, &h3f841004, &h204420c4, &h20442044, &h20442044, &h207c2044, &h00003fc0, _     ' ICON_FILE_PASTE
    &h00000000, &h3aa00fe0, &h2abc2aa0, &h2aa42aa4, &h20042aa4, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_CURSOR_HAND
    &h00000000, &h003c000c, &h030800c8, &h30100c10, &h10202020, &h04400840, &h01800280, &h00000000, _     ' ICON_CURSOR_POINTER
    &h00000000, &h00180000, &h01f00078, &h03e007f0, &h07c003e0, &h04000e40, &h00000000, &h00000000, _     ' ICON_CURSOR_CLASSIC
    &h00000000, &h04000000, &h11000a00, &h04400a80, &h01100220, &h00580088, &h00000038, &h00000000, _     ' ICON_PENCIL
    &h04000000, &h15000a00, &h50402880, &h14102820, &h05040a08, &h015c028c, &h007c00bc, &h00000000, _     ' ICON_PENCIL_BIG
    &h01c00000, &h01400140, &h01400140, &h0ff80140, &h0ff80808, &h0aa80808, &h0aa80aa8, &h00000ff8, _     ' ICON_BRUSH_CLASSIC
    &h1ffc0000, &h5ffc7ffe, &h40004000, &h00807f80, &h01c001c0, &h01c001c0, &h01c001c0, &h00000080, _     ' ICON_BRUSH_PAINTER
    &h00000000, &h00800000, &h01c00080, &h03e001c0, &h07f003e0, &h036006f0, &h000001c0, &h00000000, _     ' ICON_WATER_DROP
    &h00000000, &h3e003800, &h1f803f80, &h0c201e40, &h02080c10, &h00840104, &h00380044, &h00000000, _     ' ICON_COLOR_PICKER
    &h00000000, &h07800300, &h1fe00fc0, &h3f883fd0, &h0e021f04, &h02040402, &h00f00108, &h00000000, _     ' ICON_RUBBER
    &h00c00000, &h02800140, &h08200440, &h20081010, &h2ffe3004, &h03f807fc, &h00e001f0, &h00000040, _     ' ICON_COLOR_BUCKET
    &h00000000, &h21843ffc, &h01800180, &h01800180, &h01800180, &h01800180, &h03c00180, &h00000000, _     ' ICON_TEXT_T
    &h00800000, &h01400180, &h06200340, &h0c100620, &h1ff80c10, &h380c1808, &h70067004, &h0000f80f, _     ' ICON_TEXT_A
    &h78000000, &h50004000, &h00004800, &h03c003c0, &h03c003c0, &h00100000, &h0002000a, &h0000000e, _     ' ICON_SCALE
    &h75560000, &h5e004002, &h54001002, &h41001202, &h408200fe, &h40820082, &h40820082, &h00006afe, _     ' ICON_RESIZE
    &h00000000, &h3f003f00, &h3f003f00, &h3f003f00, &h00400080, &h001c0020, &h001c001c, &h00000000, _     ' ICON_FILTER_POINT
    &h6d800000, &h00004080, &h40804080, &h40800000, &h00406d80, &h001c0020, &h001c001c, &h00000000, _     ' ICON_FILTER_BILINEAR
    &h40080000, &h1ffe2008, &h14081008, &h11081208, &h10481088, &h10081028, &h10047ff8, &h00001002, _     ' ICON_CROP
    &h00100000, &h3ffc0010, &h2ab03550, &h22b02550, &h20b02150, &h20302050, &h2000fff0, &h00002000, _     ' ICON_CROP_ALPHA
    &h40000000, &h1ff82000, &h04082808, &h01082208, &h00482088, &h00182028, &h35542008, &h00000002, _     ' ICON_SQUARE_TOGGLE
    &h00000000, &h02800280, &h06c006c0, &h0ea00ee0, &h1e901eb0, &h3e883e98, &h7efc7e8c, &h00000000, _     ' ICON_SYMMETRY
    &h01000000, &h05600100, &h1d480d50, &h7d423d44, &h3d447d42, &h0d501d48, &h01000560, &h00000100, _     ' ICON_SYMMETRY_HORIZONTAL
    &h01800000, &h04200240, &h10080810, &h00001ff8, &h00007ffe, &h0ff01ff8, &h03c007e0, &h00000180, _     ' ICON_SYMMETRY_VERTICAL
    &h00000000, &h010800f0, &h02040204, &h02040204, &h07f00308, &h1c000e00, &h30003800, &h00000000, _     ' ICON_LENS
    &h00000000, &h061803f0, &h08240c0c, &h08040814, &h0c0c0804, &h23f01618, &h18002400, &h00000000, _     ' ICON_LENS_BIG
    &h00000000, &h00000000, &h1c7007c0, &h638e3398, &h1c703398, &h000007c0, &h00000000, &h00000000, _     ' ICON_EYE_ON
    &h00000000, &h10002000, &h04700fc0, &h610e3218, &h1c703098, &h001007a0, &h00000008, &h00000000, _     ' ICON_EYE_OFF
    &h00000000, &h00007ffc, &h40047ffc, &h10102008, &h04400820, &h02800280, &h02800280, &h00000100, _     ' ICON_FILTER_TOP
    &h00000000, &h40027ffe, &h10082004, &h04200810, &h02400240, &h02400240, &h01400240, &h000000c0, _     ' ICON_FILTER
    &h00800000, &h00800080, &h00000080, &h3c9e0000, &h00000000, &h00800080, &h00800080, &h00000000, _     ' ICON_TARGET_POINT
    &h00800000, &h00800080, &h00800080, &h3f7e01c0, &h008001c0, &h00800080, &h00800080, &h00000000, _     ' ICON_TARGET_SMALL
    &h00800000, &h00800080, &h03e00080, &h3e3e0220, &h03e00220, &h00800080, &h00800080, &h00000000, _     ' ICON_TARGET_BIG
    &h01000000, &h04400280, &h01000100, &h43842008, &h43849ab2, &h01002008, &h04400100, &h01000280, _     ' ICON_TARGET_MOVE
    &h01000000, &h04400280, &h01000100, &h41042108, &h41049ff2, &h01002108, &h04400100, &h01000280, _     ' ICON_CURSOR_MOVE
    &h781e0000, &h500a4002, &h04204812, &h00000240, &h02400000, &h48120420, &h4002500a, &h0000781e, _     ' ICON_CURSOR_SCALE
    &h00000000, &h20003c00, &h24002800, &h01000200, &h00400080, &h00140024, &h003c0004, &h00000000, _     ' ICON_CURSOR_SCALE_RIGHT
    &h00000000, &h0004003c, &h00240014, &h00800040, &h02000100, &h28002400, &h3c002000, &h00000000, _     ' ICON_CURSOR_SCALE_LEFT
    &h00000000, &h00100020, &h10101fc8, &h10001020, &h10001000, &h10001000, &h00001fc0, &h00000000, _     ' ICON_UNDO
    &h00000000, &h08000400, &h080813f8, &h00080408, &h00080008, &h00080008, &h000003f8, &h00000000, _     ' ICON_REDO
    &h00000000, &h3ffc0000, &h20042004, &h20002000, &h20402000, &h3f902020, &h00400020, &h00000000, _     ' ICON_REREDO
    &h00000000, &h3ffc0000, &h20042004, &h27fc2004, &h20202000, &h3fc82010, &h00200010, &h00000000, _     ' ICON_MUTATE
    &h00000000, &h0ff00000, &h10081818, &h11801008, &h10001180, &h18101020, &h00100fc8, &h00000020, _     ' ICON_ROTATE
    &h00000000, &h04000200, &h240429fc, &h20042204, &h20442004, &h3f942024, &h00400020, &h00000000, _     ' ICON_REPEAT
    &h00000000, &h20001000, &h22104c0e, &h00801120, &h11200040, &h4c0e2210, &h10002000, &h00000000, _     ' ICON_SHUFFLE
    &h7ffe0000, &h50024002, &h44024802, &h41024202, &h40424082, &h40124022, &h4002400a, &h00007ffe, _     ' ICON_EMPTYBOX
    &h00800000, &h03e00080, &h08080490, &h3c9e0808, &h08080808, &h03e00490, &h00800080, &h00000000, _     ' ICON_TARGET
    &h00800000, &h00800080, &h00800080, &h3ffe01c0, &h008001c0, &h00800080, &h00800080, &h00000000, _     ' ICON_TARGET_SMALL_FILL
    &h00800000, &h00800080, &h03e00080, &h3ffe03e0, &h03e003e0, &h00800080, &h00800080, &h00000000, _     ' ICON_TARGET_BIG_FILL
    &h01000000, &h07c00380, &h01000100, &h638c2008, &h638cfbbe, &h01002008, &h07c00100, &h01000380, _     ' ICON_TARGET_MOVE_FILL
    &h01000000, &h07c00380, &h01000100, &h610c2108, &h610cfffe, &h01002108, &h07c00100, &h01000380, _     ' ICON_CURSOR_MOVE_FILL
    &h781e0000, &h6006700e, &h04204812, &h00000240, &h02400000, &h48120420, &h700e6006, &h0000781e, _     ' ICON_CURSOR_SCALE_FILL
    &h00000000, &h38003c00, &h24003000, &h01000200, &h00400080, &h000c0024, &h003c001c, &h00000000, _     ' ICON_CURSOR_SCALE_RIGHT_FILL
    &h00000000, &h001c003c, &h0024000c, &h00800040, &h02000100, &h30002400, &h3c003800, &h00000000, _     ' ICON_CURSOR_SCALE_LEFT_FILL
    &h00000000, &h00300020, &h10301ff8, &h10001020, &h10001000, &h10001000, &h00001fc0, &h00000000, _     ' ICON_UNDO_FILL
    &h00000000, &h0c000400, &h0c081ff8, &h00080408, &h00080008, &h00080008, &h000003f8, &h00000000, _     ' ICON_REDO_FILL
    &h00000000, &h3ffc0000, &h20042004, &h20002000, &h20402000, &h3ff02060, &h00400060, &h00000000, _     ' ICON_REREDO_FILL
    &h00000000, &h3ffc0000, &h20042004, &h27fc2004, &h20202000, &h3ff82030, &h00200030, &h00000000, _     ' ICON_MUTATE_FILL
    &h00000000, &h0ff00000, &h10081818, &h11801008, &h10001180, &h18301020, &h00300ff8, &h00000020, _     ' ICON_ROTATE_FILL
    &h00000000, &h06000200, &h26042ffc, &h20042204, &h20442004, &h3ff42064, &h00400060, &h00000000, _     ' ICON_REPEAT_FILL
    &h00000000, &h30001000, &h32107c0e, &h00801120, &h11200040, &h7c0e3210, &h10003000, &h00000000, _     ' ICON_SHUFFLE_FILL
    &h00000000, &h30043ffc, &h24042804, &h21042204, &h20442084, &h20142024, &h3ffc200c, &h00000000, _     ' ICON_EMPTYBOX_SMALL
    &h00000000, &h20043ffc, &h20042004, &h20042004, &h20042004, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX
    &h00000000, &h23c43ffc, &h23c423c4, &h200423c4, &h20042004, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_TOP
    &h00000000, &h3e043ffc, &h3e043e04, &h20043e04, &h20042004, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_TOP_RIGHT
    &h00000000, &h20043ffc, &h20042004, &h3e043e04, &h3e043e04, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_RIGHT
    &h00000000, &h20043ffc, &h20042004, &h20042004, &h3e042004, &h3e043e04, &h3ffc3e04, &h00000000, _     ' ICON_BOX_BOTTOM_RIGHT
    &h00000000, &h20043ffc, &h20042004, &h20042004, &h23c42004, &h23c423c4, &h3ffc23c4, &h00000000, _     ' ICON_BOX_BOTTOM
    &h00000000, &h20043ffc, &h20042004, &h20042004, &h207c2004, &h207c207c, &h3ffc207c, &h00000000, _     ' ICON_BOX_BOTTOM_LEFT
    &h00000000, &h20043ffc, &h20042004, &h207c207c, &h207c207c, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_LEFT
    &h00000000, &h207c3ffc, &h207c207c, &h2004207c, &h20042004, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_TOP_LEFT
    &h00000000, &h20043ffc, &h20042004, &h23c423c4, &h23c423c4, &h20042004, &h3ffc2004, &h00000000, _     ' ICON_BOX_CENTER
    &h7ffe0000, &h40024002, &h47e24182, &h4ff247e2, &h47e24ff2, &h418247e2, &h40024002, &h00007ffe, _     ' ICON_BOX_CIRCLE_MASK
    &h7fff0000, &h40014001, &h40014001, &h49555ddd, &h4945495d, &h400149c5, &h40014001, &h00007fff, _     ' ICON_POT
    &h7ffe0000, &h53327332, &h44ce4cce, &h41324332, &h404e40ce, &h48125432, &h4006540e, &h00007ffe, _     ' ICON_ALPHA_MULTIPLY
    &h7ffe0000, &h53327332, &h44ce4cce, &h41324332, &h5c4e40ce, &h44124432, &h40065c0e, &h00007ffe, _     ' ICON_ALPHA_CLEAR
    &h7ffe0000, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h42fe417e, &h00007ffe, _     ' ICON_DITHERING
    &h07fe0000, &h1ffa0002, &h7fea000a, &h402a402a, &h5b2a512a, &h5128552a, &h40205128, &h00007fe0, _     ' ICON_MIPMAPS
    &h00000000, &h1ff80000, &h12481248, &h12481ff8, &h1ff81248, &h12481248, &h00001ff8, &h00000000, _     ' ICON_BOX_GRID
    &h12480000, &h7ffe1248, &h12481248, &h12487ffe, &h7ffe1248, &h12481248, &h12487ffe, &h00001248, _     ' ICON_GRID
    &h00000000, &h1c380000, &h1c3817e8, &h08100810, &h08100810, &h17e81c38, &h00001c38, &h00000000, _     ' ICON_BOX_CORNERS_SMALL
    &h700e0000, &h700e5ffa, &h20042004, &h20042004, &h20042004, &h20042004, &h5ffa700e, &h0000700e, _     ' ICON_BOX_CORNERS_BIG
    &h3f7e0000, &h21422142, &h21422142, &h00003f7e, &h21423f7e, &h21422142, &h3f7e2142, &h00000000, _     ' ICON_FOUR_BOXES
    &h00000000, &h3bb80000, &h3bb83bb8, &h3bb80000, &h3bb83bb8, &h3bb80000, &h3bb83bb8, &h00000000, _     ' ICON_GRID_FILL
    &h7ffe0000, &h7ffe7ffe, &h77fe7000, &h77fe77fe, &h777e7700, &h777e777e, &h777e777e, &h0000777e, _     ' ICON_BOX_MULTISIZE
    &h781e0000, &h40024002, &h00004002, &h01800000, &h00000180, &h40020000, &h40024002, &h0000781e, _     ' ICON_ZOOM_SMALL
    &h781e0000, &h40024002, &h00004002, &h03c003c0, &h03c003c0, &h40020000, &h40024002, &h0000781e, _     ' ICON_ZOOM_MEDIUM
    &h781e0000, &h40024002, &h07e04002, &h07e007e0, &h07e007e0, &h400207e0, &h40024002, &h0000781e, _     ' ICON_ZOOM_BIG
    &h781e0000, &h5ffa4002, &h1ff85ffa, &h1ff81ff8, &h1ff81ff8, &h5ffa1ff8, &h40025ffa, &h0000781e, _     ' ICON_ZOOM_ALL
    &h00000000, &h2004381c, &h00002004, &h00000000, &h00000000, &h20040000, &h381c2004, &h00000000, _     ' ICON_ZOOM_CENTER
    &h00000000, &h1db80000, &h10081008, &h10080000, &h00001008, &h10081008, &h00001db8, &h00000000, _     ' ICON_BOX_DOTS_SMALL
    &h35560000, &h00002002, &h00002002, &h00002002, &h00002002, &h00002002, &h35562002, &h00000000, _     ' ICON_BOX_DOTS_BIG
    &h7ffe0000, &h40024002, &h48124ff2, &h49924812, &h48124992, &h4ff24812, &h40024002, &h00007ffe, _     ' ICON_BOX_CONCENTRIC
    &h00000000, &h10841ffc, &h10841084, &h1ffc1084, &h10841084, &h10841084, &h00001ffc, &h00000000, _     ' ICON_BOX_GRID_BIG
    &h00000000, &h00000000, &h10000000, &h04000800, &h01040200, &h00500088, &h00000020, &h00000000, _     ' ICON_OK_TICK
    &h00000000, &h10080000, &h04200810, &h01800240, &h02400180, &h08100420, &h00001008, &h00000000, _     ' ICON_CROSS
    &h00000000, &h02000000, &h00800100, &h00200040, &h00200010, &h00800040, &h02000100, &h00000000, _     ' ICON_ARROW_LEFT
    &h00000000, &h00400000, &h01000080, &h04000200, &h04000800, &h01000200, &h00400080, &h00000000, _     ' ICON_ARROW_RIGHT
    &h00000000, &h00000000, &h00000000, &h08081004, &h02200410, &h00800140, &h00000000, &h00000000, _     ' ICON_ARROW_DOWN
    &h00000000, &h00000000, &h01400080, &h04100220, &h10040808, &h00000000, &h00000000, &h00000000, _     ' ICON_ARROW_UP
    &h00000000, &h02000000, &h03800300, &h03e003c0, &h03e003f0, &h038003c0, &h02000300, &h00000000, _     ' ICON_ARROW_LEFT_FILL
    &h00000000, &h00400000, &h01c000c0, &h07c003c0, &h07c00fc0, &h01c003c0, &h004000c0, &h00000000, _     ' ICON_ARROW_RIGHT_FILL
    &h00000000, &h00000000, &h00000000, &h0ff81ffc, &h03e007f0, &h008001c0, &h00000000, &h00000000, _     ' ICON_ARROW_DOWN_FILL
    &h00000000, &h00000000, &h01c00080, &h07f003e0, &h1ffc0ff8, &h00000000, &h00000000, &h00000000, _     ' ICON_ARROW_UP_FILL
    &h00000000, &h18a008c0, &h32881290, &h24822686, &h26862482, &h12903288, &h08c018a0, &h00000000, _     ' ICON_AUDIO
    &h00000000, &h04800780, &h004000c0, &h662000f0, &h08103c30, &h130a0e18, &h0000318e, &h00000000, _     ' ICON_FX
    &h00000000, &h00800000, &h08880888, &h2aaa0a8a, &h0a8a2aaa, &h08880888, &h00000080, &h00000000, _     ' ICON_WAVE
    &h00000000, &h00600000, &h01080090, &h02040108, &h42044204, &h24022402, &h00001800, &h00000000, _     ' ICON_WAVE_SINUS
    &h00000000, &h07f80000, &h04080408, &h04080408, &h04080408, &h7c0e0408, &h00000000, &h00000000, _     ' ICON_WAVE_SQUARE
    &h00000000, &h00000000, &h00a00040, &h22084110, &h08021404, &h00000000, &h00000000, &h00000000, _     ' ICON_WAVE_TRIANGULAR
    &h00000000, &h00000000, &h04200000, &h01800240, &h02400180, &h00000420, &h00000000, &h00000000, _     ' ICON_CROSS_SMALL
    &h00000000, &h18380000, &h12281428, &h10a81128, &h112810a8, &h14281228, &h00001838, &h00000000, _     ' ICON_PLAYER_PREVIOUS
    &h00000000, &h18000000, &h11801600, &h10181060, &h10601018, &h16001180, &h00001800, &h00000000, _     ' ICON_PLAYER_PLAY_BACK
    &h00000000, &h00180000, &h01880068, &h18080608, &h06081808, &h00680188, &h00000018, &h00000000, _     ' ICON_PLAYER_PLAY
    &h00000000, &h1e780000, &h12481248, &h12481248, &h12481248, &h12481248, &h00001e78, &h00000000, _     ' ICON_PLAYER_PAUSE
    &h00000000, &h1ff80000, &h10081008, &h10081008, &h10081008, &h10081008, &h00001ff8, &h00000000, _     ' ICON_PLAYER_STOP
    &h00000000, &h1c180000, &h14481428, &h15081488, &h14881508, &h14281448, &h00001c18, &h00000000, _     ' ICON_PLAYER_NEXT
    &h00000000, &h03c00000, &h08100420, &h10081008, &h10081008, &h04200810, &h000003c0, &h00000000, _     ' ICON_PLAYER_RECORD
    &h00000000, &h0c3007e0, &h13c81818, &h14281668, &h14281428, &h1c381c38, &h08102244, &h00000000, _     ' ICON_MAGNET
    &h07c00000, &h08200820, &h3ff80820, &h23882008, &h21082388, &h20082108, &h1ff02008, &h00000000, _     ' ICON_LOCK_CLOSE
    &h07c00000, &h08000800, &h3ff80800, &h23882008, &h21082388, &h20082108, &h1ff02008, &h00000000, _     ' ICON_LOCK_OPEN
    &h01c00000, &h0c180770, &h3086188c, &h60832082, &h60034781, &h30062002, &h0c18180c, &h01c00770, _     ' ICON_CLOCK
    &h0a200000, &h1b201b20, &h04200e20, &h04200420, &h04700420, &h0e700e70, &h0e700e70, &h04200e70, _     ' ICON_TOOLS
    &h01800000, &h3bdc318c, &h0ff01ff8, &h7c3e1e78, &h1e787c3e, &h1ff80ff0, &h318c3bdc, &h00000180, _     ' ICON_GEAR
    &h01800000, &h3ffc318c, &h1c381ff8, &h781e1818, &h1818781e, &h1ff81c38, &h318c3ffc, &h00000180, _     ' ICON_GEAR_BIG
    &h00000000, &h08080ff8, &h08081ffc, &h0aa80aa8, &h0aa80aa8, &h0aa80aa8, &h08080aa8, &h00000ff8, _     ' ICON_BIN
    &h00000000, &h00000000, &h20043ffc, &h08043f84, &h04040f84, &h04040784, &h000007fc, &h00000000, _     ' ICON_HAND_POINTER
    &h00000000, &h24400400, &h00001480, &h6efe0e00, &h00000e00, &h24401480, &h00000400, &h00000000, _     ' ICON_LASER
    &h00000000, &h03c00000, &h08300460, &h11181118, &h11181118, &h04600830, &h000003c0, &h00000000, _     ' ICON_COIN
    &h00000000, &h10880080, &h06c00810, &h366c07e0, &h07e00240, &h00001768, &h04200240, &h00000000, _     ' ICON_EXPLOSION
    &h00000000, &h3d280000, &h2528252c, &h3d282528, &h05280528, &h05e80528, &h00000000, &h00000000, _     ' ICON_1UP
    &h01800000, &h03c003c0, &h018003c0, &h0ff007e0, &h0bd00bd0, &h0a500bd0, &h02400240, &h02400240, _     ' ICON_PLAYER
    &h01800000, &h03c003c0, &h118013c0, &h03c81ff8, &h07c003c8, &h04400440, &h0c080478, &h00000000, _     ' ICON_PLAYER_JUMP
    &h3ff80000, &h30183ff8, &h30183018, &h3ff83ff8, &h03000300, &h03c003c0, &h03e00300, &h000003e0, _     ' ICON_KEY
    &h3ff80000, &h3ff83ff8, &h33983ff8, &h3ff83398, &h3ff83ff8, &h00000540, &h0fe00aa0, &h00000fe0, _     ' ICON_DEMON
    &h00000000, &h0ff00000, &h20041008, &h25442004, &h10082004, &h06000bf0, &h00000300, &h00000000, _     ' ICON_TEXT_POPUP
    &h00000000, &h11440000, &h07f00be8, &h1c1c0e38, &h1c1c0c18, &h07f00e38, &h11440be8, &h00000000, _     ' ICON_GEAR_EX
    &h00000000, &h20080000, &h0c601010, &h07c00fe0, &h07c007c0, &h0c600fe0, &h20081010, &h00000000, _     ' ICON_CRACK
    &h00000000, &h20080000, &h0c601010, &h04400fe0, &h04405554, &h0c600fe0, &h20081010, &h00000000, _     ' ICON_CRACK_POINTS
    &h00000000, &h00800080, &h01c001c0, &h1ffc3ffe, &h03e007f0, &h07f003e0, &h0c180770, &h00000808, _     ' ICON_STAR
    &h0ff00000, &h08180810, &h08100818, &h0a100810, &h08180810, &h08100818, &h08100810, &h00001ff8, _     ' ICON_DOOR
    &h0ff00000, &h08100810, &h08100810, &h10100010, &h4f902010, &h10102010, &h08100010, &h00000ff0, _     ' ICON_EXIT
    &h00040000, &h001f000e, &h0ef40004, &h12f41284, &h0ef41214, &h10040004, &h7ffc3004, &h10003000, _     ' ICON_MODE_2D
    &h78040000, &h501f600e, &h0ef44004, &h12f41284, &h0ef41284, &h10140004, &h7ffc300c, &h10003000, _     ' ICON_MODE_3D
    &h7fe00000, &h50286030, &h47fe4804, &h44224402, &h44224422, &h241275e2, &h0c06140a, &h000007fe, _     ' ICON_CUBE
    &h7fe00000, &h5ff87ff0, &h47fe4ffc, &h44224402, &h44224422, &h241275e2, &h0c06140a, &h000007fe, _     ' ICON_CUBE_FACE_TOP
    &h7fe00000, &h50386030, &h47c2483c, &h443e443e, &h443e443e, &h241e75fe, &h0c06140e, &h000007fe, _     ' ICON_CUBE_FACE_LEFT
    &h7fe00000, &h50286030, &h47fe4804, &h47fe47fe, &h47fe47fe, &h27fe77fe, &h0ffe17fe, &h000007fe, _     ' ICON_CUBE_FACE_FRONT
    &h7fe00000, &h50286030, &h47fe4804, &h44224402, &h44224422, &h3bf27be2, &h0bfe1bfa, &h000007fe, _     ' ICON_CUBE_FACE_BOTTOM
    &h7fe00000, &h70286030, &h7ffe7804, &h7c227c02, &h7c227c22, &h3c127de2, &h0c061c0a, &h000007fe, _     ' ICON_CUBE_FACE_RIGHT
    &h7fe00000, &h6fe85ff0, &h781e77e4, &h7be27be2, &h7be27be2, &h24127be2, &h0c06140a, &h000007fe, _     ' ICON_CUBE_FACE_BACK
    &h00000000, &h2a0233fe, &h22022602, &h22022202, &h2a022602, &h00a033fe, &h02080110, &h00000000, _     ' ICON_CAMERA
    &h00000000, &h200c3ffc, &h000c000c, &h3ffc000c, &h30003000, &h30003000, &h3ffc3004, &h00000000, _     ' ICON_SPECIAL
    &h00000000, &h0022003e, &h012201e2, &h0100013e, &h01000100, &h79000100, &h4f004900, &h00007800, _     ' ICON_LINK_NET
    &h00000000, &h44007c00, &h45004600, &h00627cbe, &h00620022, &h45007cbe, &h44004600, &h00007c00, _     ' ICON_LINK_BOXES
    &h00000000, &h0044007c, &h0010007c, &h3f100010, &h3f1021f0, &h3f100010, &h3f0021f0, &h00000000, _     ' ICON_LINK_MULTI
    &h00000000, &h0044007c, &h00440044, &h0010007c, &h00100010, &h44107c10, &h440047f0, &h00007c00, _     ' ICON_LINK
    &h00000000, &h0044007c, &h00440044, &h0000007c, &h00000010, &h44007c10, &h44004550, &h00007c00, _     ' ICON_LINK_BROKE
    &h02a00000, &h22a43ffc, &h20042004, &h20042ff4, &h20042ff4, &h20042ff4, &h20042004, &h00003ffc, _     ' ICON_TEXT_NOTES
    &h3ffc0000, &h20042004, &h245e27c4, &h27c42444, &h2004201e, &h201e2004, &h20042004, &h00003ffc, _     ' ICON_NOTEBOOK
    &h00000000, &h07e00000, &h04200420, &h24243ffc, &h24242424, &h24242424, &h3ffc2424, &h00000000, _     ' ICON_SUITCASE
    &h00000000, &h0fe00000, &h08200820, &h40047ffc, &h7ffc5554, &h40045554, &h7ffc4004, &h00000000, _     ' ICON_SUITCASE_ZIP
    &h00000000, &h20043ffc, &h3ffc2004, &h13c81008, &h100813c8, &h10081008, &h1ff81008, &h00000000, _     ' ICON_MAILBOX
    &h00000000, &h40027ffe, &h5ffa5ffa, &h5ffa5ffa, &h40025ffa, &h03c07ffe, &h1ff81ff8, &h00000000, _     ' ICON_MONITOR
    &h0ff00000, &h6bfe7ffe, &h7ffe7ffe, &h68167ffe, &h08106816, &h08100810, &h0ff00810, &h00000000, _     ' ICON_PRINTER
    &h3ff80000, &hfffe2008, &h870a8002, &h904a888a, &h904a904a, &h870a888a, &hfffe8002, &h00000000, _     ' ICON_PHOTO_CAMERA
    &h0fc00000, &hfcfe0cd8, &h8002fffe, &h84428382, &h84428442, &h80028382, &hfffe8002, &h00000000, _     ' ICON_PHOTO_CAMERA_FLASH
    &h00000000, &h02400180, &h08100420, &h20041008, &h23c42004, &h22442244, &h3ffc2244, &h00000000, _     ' ICON_HOUSE
    &h00000000, &h1c700000, &h3ff83ef8, &h3ff83ff8, &h0fe01ff0, &h038007c0, &h00000100, &h00000000, _     ' ICON_HEART
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h80000000, &he000c000, _     ' ICON_CORNER
    &h00000000, &h14001c00, &h15c01400, &h15401540, &h155c1540, &h15541554, &h1ddc1554, &h00000000, _     ' ICON_VERTICAL_BARS
    &h00000000, &h03000300, &h1b001b00, &h1b601b60, &h1b6c1b60, &h1b6c1b6c, &h1b6c1b6c, &h00000000, _     ' ICON_VERTICAL_BARS_FILL
    &h00000000, &h00000000, &h403e7ffe, &h7ffe403e, &h7ffe0000, &h43fe43fe, &h00007ffe, &h00000000, _     ' ICON_LIFE_BARS
    &h7ffc0000, &h43844004, &h43844284, &h43844004, &h42844284, &h42844284, &h40044384, &h00007ffc, _     ' ICON_INFO
    &h40008000, &h10002000, &h04000800, &h01000200, &h00400080, &h00100020, &h00040008, &h00010002, _     ' ICON_CROSSLINE
    &h00000000, &h1ff01ff0, &h18301830, &h1f001830, &h03001f00, &h00000300, &h03000300, &h00000000, _     ' ICON_HELP
    &h3ff00000, &h2abc3550, &h2aac3554, &h2aac3554, &h2aac3554, &h2aac3554, &h2aac3554, &h00003ffc, _     ' ICON_FILETYPE_ALPHA
    &h3ff00000, &h201c2010, &h22442184, &h28142424, &h29942814, &h2ff42994, &h20042004, &h00003ffc, _     ' ICON_FILETYPE_HOME
    &h07fe0000, &h04020402, &h7fe20402, &h44224422, &h44224422, &h402047fe, &h40204020, &h00007fe0, _     ' ICON_LAYERS_VISIBLE
    &h07fe0000, &h04020402, &h7c020402, &h44024402, &h44024402, &h402047fe, &h40204020, &h00007fe0, _     ' ICON_LAYERS
    &h00000000, &h40027ffe, &h7ffe4002, &h40024002, &h40024002, &h40024002, &h7ffe4002, &h00000000, _     ' ICON_WINDOW
    &h09100000, &h09f00910, &h09100910, &h00000910, &h24a2779e, &h27a224a2, &h709e20a2, &h00000000, _     ' ICON_HIDPI
    &h3ff00000, &h201c2010, &h2a842e84, &h2e842a84, &h2ba42004, &h2aa42aa4, &h20042ba4, &h00003ffc, _     ' ICON_FILETYPE_BINARY
    &h00000000, &h00000000, &h00120012, &h4a5e4bd2, &h485233d2, &h00004bd2, &h00000000, &h00000000, _     ' ICON_HEX
    &h01800000, &h381c0660, &h23c42004, &h23c42044, &h13c82204, &h08101008, &h02400420, &h00000180, _     ' ICON_SHIELD
    &h007e0000, &h20023fc2, &h40227fe2, &h400a403a, &h400a400a, &h400a400a, &h4008400e, &h00007ff8, _     ' ICON_FILE_NEW
    &h00000000, &h0042007e, &h40027fc2, &h44024002, &h5f024402, &h44024402, &h7ffe4002, &h00000000, _     ' ICON_FOLDER_ADD
    &h44220000, &h12482244, &hf3cf0000, &h14280420, &h48122424, &h08100810, &h1ff81008, &h03c00420, _     ' ICON_ALARM
    &h0aa00000, &h1ff80aa0, &h1068700e, &h1008706e, &h1008700e, &h1008700e, &h0aa01ff8, &h00000aa0, _     ' ICON_CPU
    &h07e00000, &h04201db8, &h04a01c38, &h04a01d38, &h04a01d38, &h04a01d38, &h04201d38, &h000007e0, _     ' ICON_ROM
    &h00000000, &h03c00000, &h3c382ff0, &h3c04380c, &h01800000, &h03c003c0, &h00000180, &h00000000, _     ' ICON_STEP_OVER
    &h01800000, &h01800180, &h01800180, &h03c007e0, &h00000180, &h01800000, &h03c003c0, &h00000180, _     ' ICON_STEP_INTO
    &h01800000, &h07e003c0, &h01800180, &h01800180, &h00000180, &h01800000, &h03c003c0, &h00000180, _     ' ICON_STEP_OUT
    &h00000000, &h0ff003c0, &h181c1c34, &h303c301c, &h30003000, &h1c301800, &h03c00ff0, &h00000000, _     ' ICON_RESTART
    &h00000000, &h00000000, &h07e003c0, &h0ff00ff0, &h0ff00ff0, &h03c007e0, &h00000000, &h00000000, _     ' ICON_BREAKPOINT_ON
    &h00000000, &h00000000, &h042003c0, &h08100810, &h08100810, &h03c00420, &h00000000, &h00000000, _     ' ICON_BREAKPOINT_OFF
    &h00000000, &h00000000, &h1ff81ff8, &h1ff80000, &h00001ff8, &h1ff81ff8, &h00000000, &h00000000, _     ' ICON_BURGER_MENU
    &h00000000, &h00000000, &h00880070, &h0c880088, &h1e8810f8, &h3e881288, &h00000000, &h00000000, _     ' ICON_CASE_SENSITIVE
    &h00000000, &h02000000, &h07000a80, &h07001fc0, &h02000a80, &h00300030, &h00000000, &h00000000, _     ' ICON_REG_EXP
    &h00000000, &h0042007e, &h40027fc2, &h40024002, &h40024002, &h40024002, &h7ffe4002, &h00000000, _     ' ICON_FOLDER
    &h3ff00000, &h201c2010, &h20042004, &h20042004, &h20042004, &h20042004, &h20042004, &h00003ffc, _     ' ICON_FILE
    &h1ff00000, &h20082008, &h17d02fe8, &h05400ba0, &h09200540, &h23881010, &h2fe827c8, &h00001ff0, _     ' ICON_SAND_TIMER
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_220
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_221
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_222
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_223
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_224
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_225
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_226
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_227
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_228
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_229
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_230
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_231
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_232
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_233
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_234
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_235
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_236
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_237
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_238
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_239
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_240
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_241
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_242
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_243
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_244
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_245
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_246
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_247
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_248
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_249
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_250
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_251
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_252
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_253
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, _     ' ICON_254
    &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000, &h00000000 _     ' ICON_255
}

' NOTE: We keep a pointer to the icons array, useful to point to other sets if required
dim shared as ulong ptr guiIconsPtr = @guiIcons(0)

#endif      ' notRAYGUI_NO_ICONS

#ifndef RAYGUI_ICON_SIZE
    #define RAYGUI_ICON_SIZE             0
#endif

' WARNING: Those values define the total size of the style data array,
' if changed, previous saved styles could become incompatible
#define RAYGUI_MAX_CONTROLS             16      ' Maximum number of controls
#define RAYGUI_MAX_PROPS_BASE           16      ' Maximum number of base properties
#define RAYGUI_MAX_PROPS_EXTENDED        8      ' Maximum number of extended properties

'----------------------------------------------------------------------------------
' Types and Structures Definition
'----------------------------------------------------------------------------------
' Gui control property style color_ element
enum GuiPropertyElement
    BORDER = 0
    BASE_ 
    TEXT_ 
    OTHER 
end enum

'----------------------------------------------------------------------------------
' Global Variables Definition
'----------------------------------------------------------------------------------
dim shared as GuiState guiState_ = STATE_NORMAL        ' Gui global state, if notSTATE_NORMAL, forces defined state

dim shared as Font guiFont                    ' Gui current font_ (WARNING: highly coupled to raylib)
dim shared as boolean guiLocked = false                  ' Gui lock state (no inputs processed)
dim shared as single guiAlpha = 1.0f                   ' Gui controls transparency

dim shared as ulong guiIconScale = 1           ' Gui icon default scale (if icons enabled)

dim shared as boolean guiTooltip_ = false                 ' Tooltip enabled/disabled
dim shared as const zstring ptr guiTooltipPtr = NULL        ' Tooltip string pointer (string provided by user)

dim shared as boolean guiSliderDragging = false          ' Gui slider drag state (no inputs processed except dragged slider)
dim shared as Rectangle guiSliderActive        ' Gui slider active bounds rectangle, used as an unique identifier

dim shared as long textBoxCursorIndex = 0              ' Cursor index, shared by all GuiTextBox*()

dim shared as long autoCursorCooldownCounter = 0       ' Cooldown frame counter for automatic cursor movement on key-down
dim shared as long autoCursorDelayCounter = 0          ' Delay frame counter for automatic cursor movement

'----------------------------------------------------------------------------------
' Style data array for all gui style properties (allocated on data segment by default)
'
' NOTE 1: First set of BASE_ properties are generic to all controls but could be individually
' overwritten per control, first set of EXTENDED properties are generic to all controls and
' can not be overwritten individually but custom EXTENDED properties can be used by control
'
' NOTE 2: A new style set could be loaded over this array using GuiLoadStyle(),
' but default gui style could always be recovered with GuiLoadStyleDefault()
'
' guiStyle size is by default: 16*(16 + 8) = 384*4 = 1536 bytes = 1.5 KB
'----------------------------------------------------------------------------------
dim shared as ulong guiStyle(0 to RAYGUI_MAX_CONTROLS*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED) - 1)

dim shared as boolean guiStyleLoaded = false         ' Style loaded flag for lazy style initialization

'----------------------------------------------------------------------------------
' Module specific Functions Declaration
'----------------------------------------------------------------------------------
declare sub GuiLoadStyleFromMemory(byval fileData as const ubyte ptr, byval dataSize as long)    ' Load style from memory (binary only)

declare function GetTextWidth(byval text as const zstring ptr) as long                      ' Gui get text width_ using gui font_ and style
declare function GetTextBounds(byval control as long, byval bounds as Rectangle) as Rectangle  ' Get text bounds considering control bounds
declare function GetTextIcon(byval text as const zstring ptr, byval iconId as long ptr) as const zstring ptr  ' Get text icon if provided and move text cursor

declare sub GuiDrawText(byval text as const zstring ptr, byval textBounds as Rectangle, byval alignment as long, byval tint as RayColor)     ' Gui draw text using default font_
declare sub GuiDrawRectangle(byval rec as Rectangle, byval borderWidth as long, byval borderColor as RayColor, byval color_ as RayColor)   ' Gui draw rectangle using default raygui style

declare function GuiTextSplit(byval text as const zstring ptr, byval delimiter as ubyte, byval count as long ptr, byval textRow as long ptr) as const zstring ptr ptr   ' Split controls text into multiple strings
declare function ConvertHSVtoRGB(byval hsv as Vector3) as Vector3                    ' Convert color_ data from HSV to RGB
declare function ConvertRGBtoHSV(byval rgb_ as Vector3) as Vector3                    ' Convert color_ data from RGB to HSV

declare function GuiScrollBar(byval bounds as Rectangle, byval value as long, byval minValue as long, byval maxValue as long) as long   ' Scroll bar control, used by GuiScrollPanel()
declare sub GuiTooltip(byval controlRec as Rectangle)                   ' Draw tooltip using control rec position

declare function GuiFade(byval color_ as RayColor, byval alpha as single) as RayColor         ' Fade color_ by an alpha factor

'----------------------------------------------------------------------------------
' Gui Setup Functions Definition
'----------------------------------------------------------------------------------
' Enable gui global state
' NOTE: We check for STATE_DISABLED to avoid messing custom global state setups
sub GuiEnable() 
    if (guiState_ = STATE_DISABLED) then 
        guiState_ = STATE_NORMAL 
    end if
end sub

' Disable gui global state
' NOTE: We check for STATE_NORMAL to avoid messing custom global state setups
sub GuiDisable()  
    if (guiState_ = STATE_NORMAL) then 
        guiState_ = STATE_DISABLED 
    end if
end sub

' Lock gui global state
sub GuiLock() 
    guiLocked = true 
end sub

' Unlock gui global state
sub GuiUnlock() 
    guiLocked = false
end sub

' Check if gui is locked (global state)
function GuiIsLocked() as boolean 
    return guiLocked
end function

' Set gui controls alpha global state
sub GuiSetAlpha(byval alpha as single)
    if (alpha < 0.0f) then 
        alpha = 0.0f
    elseif (alpha > 1.0f) then 
        alpha = 1.0f
    end if

    guiAlpha = alpha
end sub

' Set gui state (global state)
sub GuiSetState(byval state as GuiState) 
    guiState_ = state
end sub

' Get gui state (global state)
function GuiGetState() as GuiState 
    return guiState_ 
end function

' Set custom gui font_
' NOTE: Font loading/unloading is external to raygui
sub GuiSetFont(byval font_ as Font)
    if (font_.texture.id > 0) then
    
        ' NOTE: If we try to setup a font_ but default style has not been
        ' lazily loaded before, it will be overwritten, so we need to force
        ' default style loading first
        if (not guiStyleLoaded) then
            GuiLoadStyleDefault()
        end if

        guiFont = font_
    end if
end sub

' Get custom gui font_
function GuiGetFont() as Font
    return guiFont
end function

' Set control style property value
sub GuiSetStyle(byval control as long, byval property_ as long, byval value as long)

    if (not guiStyleLoaded) then
        GuiLoadStyleDefault()
    end if
    guiStyle(control*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED) + property_) = value

    ' Default properties are propagated to all controls
    if ((control = 0) AND (property_ < RAYGUI_MAX_PROPS_BASE)) then
    
        for i as integer = 1 to RAYGUI_MAX_CONTROLS - 1
            guiStyle(i*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED) + property_) = value
        next i

    end if
end sub

' Get control style property value
function GuiGetStyle(byval control as long, byval property_ as long) as long

    if (not guiStyleLoaded) then
        GuiLoadStyleDefault()
    end if
    if (control < 0 OR control > 16) then
        control = 0
    end if
    return guiStyle(control*(RAYGUI_MAX_PROPS_BASE + RAYGUI_MAX_PROPS_EXTENDED) + property_)
end function

'----------------------------------------------------------------------------------
' Gui Controls Functions Definition
'----------------------------------------------------------------------------------

' Window Box control
function GuiWindowBox(byval bounds as Rectangle, byval title as const zstring ptr) as long

    ' Window title bar height (including borders)
    ' NOTE: This define is also used by GuiMessageBox() and GuiTextInputBox()
    

    var result = 0
    'GuiState state = guiState_

    var statusBarHeight = RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT

    var statusBar_ = type<Rectangle>( bounds.x, bounds.y, bounds.width_, csng(statusBarHeight) )
    if (bounds.height < statusBarHeight*2.0f) then 
        bounds.height = statusBarHeight*2.0f
    end if

    var windowPanel = type<Rectangle>( bounds.x, bounds.y + csng(statusBarHeight - 1), bounds.width_, bounds.height - csng(statusBarHeight + 1) )
    var closeButtonRec = type<Rectangle>( _
                                statusBar_.x + statusBar_.width_ - GuiGetStyle(STATUSBAR, BORDER_WIDTH) - 20, _
                                statusBar_.y + statusBarHeight/2.0f - 18.0f/2.0f, 18, 18 )

    ' Update control
    '--------------------------------------------------------------------
    ' NOTE: Logic is directly managed by button
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiStatusBar(statusBar_, title) ' Draw window header as status bar
    GuiPanel(windowPanel, NULL)    ' Draw window base

    ' Draw window close button
    var tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
    var tempTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
    GuiSetStyle(BUTTON, BORDER_WIDTH, 1)
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
#ifdef RAYGUI_NO_ICONS
    result = GuiButton(closeButtonRec, "x")
#else
    result = GuiButton(closeButtonRec, GuiIconText(ICON_CROSS_SMALL, NULL))
#endif
    GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlignment)
    '--------------------------------------------------------------------

    return result      ' Window close button clicked: result = 1
end function

' Group Box control with text name
function GuiGroupBox(byval bounds as Rectangle, byval text as const zstring ptr) as long

    #ifndef RAYGUI_GROUPBOX_LINE_THICK
        #define RAYGUI_GROUPBOX_LINE_THICK     1
    #endif

    var result = 0
    var state = guiState_

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y, RAYGUI_GROUPBOX_LINE_THICK, bounds.height ), 0, BLANK, GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BORDER_COLOR_DISABLED , LINE_COLOR))))
    GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + bounds.height - 1, bounds.width_, RAYGUI_GROUPBOX_LINE_THICK ), 0, BLANK, GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BORDER_COLOR_DISABLED , LINE_COLOR))))
    GuiDrawRectangle(type<Rectangle>( bounds.x + bounds.width_ - 1, bounds.y, RAYGUI_GROUPBOX_LINE_THICK, bounds.height ), 0, BLANK, GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BORDER_COLOR_DISABLED , LINE_COLOR))))

    GuiLine(type<Rectangle>( bounds.x, bounds.y - GuiGetStyle(DEFAULT, TEXT_SIZE)/2, bounds.width_, GuiGetStyle(DEFAULT, TEXT_SIZE) ), text)
    '--------------------------------------------------------------------

    return result
end function

' Line control
function GuiLine(byval bounds as Rectangle, byval text as const zstring ptr) as long

    #ifndef RAYGUI_LINE_ORIGIN_SIZE
        #define RAYGUI_LINE_MARGIN_TEXT  12
    #endif
    #ifndef RAYGUI_LINE_TEXT_PADDING
        #define RAYGUI_LINE_TEXT_PADDING  4
    #endif

    var result = 0
    var state = guiState_

    var color_ = GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BORDER_COLOR_DISABLED , LINE_COLOR)))

    ' Draw control
    '--------------------------------------------------------------------
    if (text = NULL) then 
        GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + bounds.height/2, bounds.width_, 1 ), 0, BLANK, color_)
    else
    
        dim textBounds as Rectangle 
        textBounds.width_ = GetTextWidth(text) + 2
        textBounds.height = bounds.height
        textBounds.x = bounds.x + RAYGUI_LINE_MARGIN_TEXT
        textBounds.y = bounds.y

        ' Draw line with embedded text label: "--- text --------------"
        GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + bounds.height/2, RAYGUI_LINE_MARGIN_TEXT - RAYGUI_LINE_TEXT_PADDING, 1 ), 0, BLANK, color_)
        GuiDrawText(text, textBounds, TEXT_ALIGN_LEFT, color_)
        GuiDrawRectangle(type<Rectangle>( bounds.x + 12 + textBounds.width_ + 4, bounds.y + bounds.height/2, bounds.width_ - textBounds.width_ - RAYGUI_LINE_MARGIN_TEXT - RAYGUI_LINE_TEXT_PADDING, 1 ), 0, BLANK, color_)
    end if
    '--------------------------------------------------------------------

    return result
end function

' Panel control
function GuiPanel(byval bounds as Rectangle, byval text as const zstring ptr) as long

    #ifndef RAYGUI_PANEL_BORDER_WIDTH
        #define RAYGUI_PANEL_BORDER_WIDTH   1
    #endif

    var result = 0
    var state = guiState_

    ' Text will be drawn as a header bar (if provided)
    var statusBar_ = type<Rectangle>( bounds.x, bounds.y, bounds.width_, RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT )
    if ((text <> NULL) AND (bounds.height < RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT*2.0f)) then 
        bounds.height = RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT*2.0f
    end if

    if (text <> NULL) then
    
        ' Move panel bounds after the header bar
        bounds.y += RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - 1
        bounds.height -= RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - 1
    end if

    ' Draw control
    '--------------------------------------------------------------------
    if (text <> NULL) then 
        GuiStatusBar(statusBar_, text)  ' Draw panel header as status bar
    end if

    GuiDrawRectangle(bounds, RAYGUI_PANEL_BORDER_WIDTH, GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BORDER_COLOR_DISABLED, LINE_COLOR))), _
                     GetColor(GuiGetStyle(DEFAULT, iif((state = STATE_DISABLED), BASE_COLOR_DISABLED , BACKGROUND_COLOR))))
    '--------------------------------------------------------------------

    return result
end function

' Tab Bar control
' NOTE: Using GuiToggle() for the TABS
function GuiTabBar(byval bounds as Rectangle, byval text as const zstring ptr ptr, byval count as long, byval active as long ptr) as long

    #define RAYGUI_TABBAR_ITEM_WIDTH    160

    var result = -1
    

    var tabBounds = type<Rectangle>( bounds.x, bounds.y, RAYGUI_TABBAR_ITEM_WIDTH, bounds.height )

    if (*active < 0) then 
        *active = 0
    elseif (*active > count - 1) then 
        *active = count - 1
    end if

    var offsetX = 0    ' Required in case tabs go out of screen
    offsetX = (*active + 2)*RAYGUI_TABBAR_ITEM_WIDTH - GetScreenWidth()
    if (offsetX < 0) then 
        offsetX = 0
    end if

    var toggle = false    ' Required for individual toggles

    ' Draw control
    '--------------------------------------------------------------------
    for i as integer = 0 to count - 1
    
        tabBounds.x = bounds.x + (RAYGUI_TABBAR_ITEM_WIDTH + 4)*i - offsetX

        if (tabBounds.x < GetScreenWidth()) then
        
            ' Draw tabs as toggle controls
            var textAlignment = GuiGetStyle(TOGGLE, TEXT_ALIGNMENT)
            var textPadding = GuiGetStyle(TOGGLE, TEXT_PADDING)
            GuiSetStyle(TOGGLE, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
            GuiSetStyle(TOGGLE, TEXT_PADDING, 8)

            if (i = (*active)) then
            
                toggle = true
                GuiToggle(tabBounds, GuiIconText(12, text[i]), @toggle)
            
            else
            
                toggle = false
                GuiToggle(tabBounds, GuiIconText(12, text[i]), @toggle)
                if (toggle) then
                    *active = i
                end if
            end if

            GuiSetStyle(TOGGLE, TEXT_PADDING, textPadding)
            GuiSetStyle(TOGGLE, TEXT_ALIGNMENT, textAlignment)

            ' Draw tab close button
            ' NOTE: Only draw close button for current tab: if (CheckCollisionPointRec(mousePosition, tabBounds))
            var tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
            var tempTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
            GuiSetStyle(BUTTON, BORDER_WIDTH, 1)
            GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
#ifdef RAYGUI_NO_ICONS
            if (GuiButton(type<Rectangle>( tabBounds.x + tabBounds.width_ - 14 - 5, tabBounds.y + 5, 14, 14 ), "x")) then 
                result = i
            end if
#else
            if (GuiButton(type<Rectangle>( tabBounds.x + tabBounds.width_ - 14 - 5, tabBounds.y + 5, 14, 14 ), GuiIconText(ICON_CROSS_SMALL, NULL))) then 
                result = i
            end if
#endif
            GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)
            GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlignment)
        end if
    next i

    ' Draw tab-bar bottom line
    GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + bounds.height - 1, bounds.width_, 1 ), 0, BLANK, GetColor(GuiGetStyle(TOGGLE, BORDER_COLOR_NORMAL)))
    '--------------------------------------------------------------------

    return result     ' Return as result the current TAB closing requested
end function

' Scroll Panel control
function GuiScrollPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval content as Rectangle, byval scroll as Vector2 ptr, byval view_ as Rectangle ptr) as long

    #define RAYGUI_MIN_SCROLLBAR_WIDTH     40
    #define RAYGUI_MIN_SCROLLBAR_HEIGHT    40
    
    var result = 0
    var state = guiState_
    var mouseWheelSpeed = 20.0f      ' Default movement speed with mouse wheel

    dim as Rectangle temp
    if (view_ = NULL) then
        view_ = @temp
    end if

    var scrollPos = type<Vector2>( 0.0f, 0.0f )
    if (scroll <> NULL) then
        scrollPos = *scroll
    end if

    ' Text will be drawn as a header bar (if provided)
    var statusBar = type<Rectangle>( bounds.x, bounds.y, bounds.width_, RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT )
    if (bounds.height < RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT*2.0f) then
        bounds.height = RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT*2.0f
    end if

    if (text <> NULL) then
    
        ' Move panel bounds after the header bar
        bounds.y += RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - 1
        bounds.height -= RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT + 1
    end if

    var hasHorizontalScrollBar = iif((content.width_ > bounds.width_ - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH)), true , false)
    var hasVerticalScrollBar = iif((content.height > bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH)), true , false)

    ' Recheck to account for the other scrollbar being visible
    if (not hasHorizontalScrollBar) then 
        hasHorizontalScrollBar = iif((hasVerticalScrollBar AND (content.width_ > (bounds.width_ - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH)))), true , false)
    end if
    if (not hasVerticalScrollBar) then 
        hasVerticalScrollBar = iif((hasHorizontalScrollBar AND (content.height > (bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH)))), true , false)
    end if

    var horizontalScrollBarWidth = iif(hasHorizontalScrollBar, GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH) , 0)
    var verticalScrollBarWidth =  iif(hasVerticalScrollBar, GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH) , 0)
    var horizontalScrollBar = type<Rectangle>( _
        iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), bounds.x + verticalScrollBarWidth , bounds.x) + GuiGetStyle(DEFAULT, BORDER_WIDTH), _
        bounds.y + bounds.height - horizontalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH), _
        bounds.width_ - verticalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH), _
        horizontalScrollBarWidth _
    )
    var verticalScrollBar = type<Rectangle>( _
        iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH) , bounds.x + bounds.width_ - verticalScrollBarWidth - GuiGetStyle(DEFAULT, BORDER_WIDTH)), _
        bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), _
        verticalScrollBarWidth, _
        bounds.height - horizontalScrollBarWidth - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) _
    )

    ' Make sure scroll bars have a minimum width_/height
    ' NOTE: If content >>> bounds, size could be very small or even 0
    if (horizontalScrollBar.width_ < RAYGUI_MIN_SCROLLBAR_WIDTH) then
    
        horizontalScrollBar.width_ = RAYGUI_MIN_SCROLLBAR_WIDTH
        mouseWheelSpeed = 30.0f    ' TODO: Calculate speed increment based on content.height vs bounds.height
    end if
    if (verticalScrollBar.height < RAYGUI_MIN_SCROLLBAR_HEIGHT) then
    
        verticalScrollBar.height = RAYGUI_MIN_SCROLLBAR_HEIGHT
        mouseWheelSpeed = 30.0f    ' TODO: Calculate speed increment based on content.width_ vs bounds.width_
    end if

    ' Calculate view area (area without the scrollbars)
    *view_ = iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), _
                type<Rectangle>( bounds.x + verticalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.width_ - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth, bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth ) , _
                type<Rectangle>( bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.y + GuiGetStyle(DEFAULT, BORDER_WIDTH), bounds.width_ - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth, bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth ))

    ' Clip view area to the actual content size
    if (view_->width_ > content.width_) then
        view_->width_ = content.width_
    end if
    if (view_->height > content.height) then 
        view_->height = content.height
    end if

    var horizontalMin = iif( _
        hasHorizontalScrollBar, _
        iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), -verticalScrollBarWidth , 0) - GuiGetStyle(DEFAULT, BORDER_WIDTH) , _
        iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), -verticalScrollBarWidth , 0) - GuiGetStyle(DEFAULT, BORDER_WIDTH))

    var horizontalMax = iif( _
        hasHorizontalScrollBar, _
        content.width_ - bounds.width_ + verticalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH) - iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), verticalScrollBarWidth , 0) , _ 
        -GuiGetStyle(DEFAULT, BORDER_WIDTH))

    var verticalMin = iif(hasVerticalScrollBar, 0.0f , -1.0f)
    var verticalMax = iif(hasVerticalScrollBar, content.height - bounds.height + horizontalScrollBarWidth + GuiGetStyle(DEFAULT, BORDER_WIDTH) , -GuiGetStyle(DEFAULT, BORDER_WIDTH))

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        ' Check button state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if

#ifdef SUPPORT_SCROLLBAR_KEY_INPUT
            if (hasHorizontalScrollBar) then
            
                if (IsKeyDown(KEY_RIGHT)) then 
                    scrollPos.x -= GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                end if
                if (IsKeyDown(KEY_LEFT)) then 
                    scrollPos.x += GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                end if
            end if

            if (hasVerticalScrollBar) then
            
                if (IsKeyDown(KEY_DOWN)) then 
                    scrollPos.y -= GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                end if
                if (IsKeyDown(KEY_UP)) then 
                    scrollPos.y += GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                end if
            end if
#endif
            var wheelMove = GetMouseWheelMove()

            ' Horizontal and vertical scrolling with mouse wheel
            if (hasHorizontalScrollBar AND (IsKeyDown(KEY_LEFT_CONTROL) OR IsKeyDown(KEY_LEFT_SHIFT))) then 
                scrollPos.x += wheelMove*mouseWheelSpeed
            else 
                scrollPos.y += wheelMove*mouseWheelSpeed ' Vertical scroll
            end if
        end if
    end if

    ' Normalize scroll values
    if (scrollPos.x > -horizontalMin) then 
        scrollPos.x = -horizontalMin
    end if
    if (scrollPos.x < -horizontalMax) then
        scrollPos.x = -horizontalMax
    end if
    if (scrollPos.y > -verticalMin) then 
        scrollPos.y = -verticalMin
    end if
    if (scrollPos.y < -verticalMax) then 
        scrollPos.y = -verticalMax
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (text <> NULL) then 
        GuiStatusBar(statusBar, text)  ' Draw panel header as status bar
    end if

    GuiDrawRectangle(bounds, 0, BLANK, GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))        ' Draw background

    ' Save size of the scrollbar slider
    var slider = GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE)

    ' Draw horizontal scrollbar if visible
    if (hasHorizontalScrollBar) then
    
        ' Change scrollbar slider size to show the diff in size between the content width_ and the widget width_
        GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, int(((bounds.width_ - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth)/int(content.width_))*(int(bounds.width_) - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - verticalScrollBarWidth)))
        scrollPos.x = -GuiScrollBar(horizontalScrollBar, int(-scrollPos.x), int(horizontalMin), int(horizontalMax))
    
    else 
        scrollPos.x = 0.0f
    end if

    ' Draw vertical scrollbar if visible
    if (hasVerticalScrollBar) then
    
        ' Change scrollbar slider size to show the diff in size between the content height and the widget height
        GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, int(((bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth)/int(content.height))*(int(bounds.height) - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) - horizontalScrollBarWidth)))
        scrollPos.y = -GuiScrollBar(verticalScrollBar, int(-scrollPos.y), int(verticalMin), int(verticalMax))
    
    else 
        scrollPos.y = 0.0f
    end if

    ' Draw detail corner rectangle if both scroll bars are visible
    if (hasHorizontalScrollBar AND hasVerticalScrollBar) then
    
        var corner = type<Rectangle>( iif((GuiGetStyle(LISTVIEW, SCROLLBAR_SIDE) = SCROLLBAR_LEFT_SIDE), (bounds.x + GuiGetStyle(DEFAULT, BORDER_WIDTH) + 2) , (horizontalScrollBar.x + horizontalScrollBar.width_ + 2)), verticalScrollBar.y + verticalScrollBar.height + 2, horizontalScrollBarWidth - 4, verticalScrollBarWidth - 4 )
        GuiDrawRectangle(corner, 0, BLANK, GetColor(GuiGetStyle(LISTVIEW, TEXT_ + (state*3))))
    end if

    ' Draw scrollbar lines depending on current state
    GuiDrawRectangle(bounds, GuiGetStyle(DEFAULT, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER + (state*3))), BLANK)

    ' Set scrollbar slider size back to the way it was before
    GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, slider)
    '--------------------------------------------------------------------

    if (scroll <> NULL) then 
        *scroll = scrollPos
    end if

    return result
end function

' Label control
function GuiLabel(byval bounds as Rectangle, byval text as const zstring ptr) as long

    var result = 0
    var state = guiState_

    ' Update control
    '--------------------------------------------------------------------
    '...
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawText(text, GetTextBounds(LABEL, bounds), GuiGetStyle(LABEL, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LABEL, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    return result
end function

' Button control, returns true when clicked
function GuiButton(byval bounds as Rectangle, byval text as const zstring ptr) as long

    var result = 0
    var state = guiState_

    ' Update control
    '--------------------------------------------------------------------
    if ( _
        cbool(state <> STATE_DISABLED) _
        AND (not guiLocked) _
        AND (not guiSliderDragging) _
    ) then
    
        var mousePoint = GetMousePosition()

        ' Check button state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then 
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if

            if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then
                result = 1
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(BUTTON, BORDER_WIDTH), GetColor(GuiGetStyle(BUTTON, BORDER + (state*3))), GetColor(GuiGetStyle(BUTTON, BASE_ + (state*3))))
    GuiDrawText(text, GetTextBounds(BUTTON, bounds), GuiGetStyle(BUTTON, TEXT_ALIGNMENT), GetColor(GuiGetStyle(BUTTON, TEXT_ + (state*3))))

    if (state = STATE_FOCUSED) then 
        GuiTooltip(bounds)
    end if
    '------------------------------------------------------------------

    return result      ' Button pressed: result = 1
end function

' Label button control
function GuiLabelButton(byval bounds as Rectangle, byval text as const zstring ptr) as long

    var state = guiState_
    var pressed = false

    ' NOTE: We force bounds.width_ to be all text
    var textWidth = GetTextWidth(text)
    if ((bounds.width_ - 2*GuiGetStyle(LABEL, BORDER_WIDTH) - 2*GuiGetStyle(LABEL, TEXT_PADDING)) < textWidth) then 
        bounds.width_ = textWidth + 2*GuiGetStyle(LABEL, BORDER_WIDTH) + 2*GuiGetStyle(LABEL, TEXT_PADDING) + 2
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        ' Check checkbox state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then 
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if

            if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then 
                pressed = true
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawText(text, GetTextBounds(LABEL, bounds), GuiGetStyle(LABEL, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LABEL, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    return pressed
end function

' Toggle Button control, returns true when active
function GuiToggle(byval bounds as Rectangle, byval text as const zstring ptr, byval active as boolean ptr) as long

    var result = 0
    var state = guiState_

    var temp = false
    if (active = NULL) then 
        active = @temp
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        ' Check toggle button state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
                state = STATE_PRESSED
            elseif (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_NORMAL
                *active = not(*active)
            
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state = STATE_NORMAL) then
    
        GuiDrawRectangle(bounds, GuiGetStyle(TOGGLE, BORDER_WIDTH), GetColor(GuiGetStyle(TOGGLE, iif((*active), BORDER_COLOR_PRESSED , (BORDER + state*3)))), GetColor(GuiGetStyle(TOGGLE, iif((*active), BASE_COLOR_PRESSED , (BASE_ + state*3)))))
        GuiDrawText(text, GetTextBounds(TOGGLE, bounds), GuiGetStyle(TOGGLE, TEXT_ALIGNMENT), GetColor(GuiGetStyle(TOGGLE, iif((*active), TEXT_COLOR_PRESSED , (TEXT_ + state*3)))))
    
    else
    
        GuiDrawRectangle(bounds, GuiGetStyle(TOGGLE, BORDER_WIDTH), GetColor(GuiGetStyle(TOGGLE, BORDER + state*3)), GetColor(GuiGetStyle(TOGGLE, BASE_ + state*3)))
        GuiDrawText(text, GetTextBounds(TOGGLE, bounds), GuiGetStyle(TOGGLE, TEXT_ALIGNMENT), GetColor(GuiGetStyle(TOGGLE, TEXT_ + state*3)))
    end if

    if (state = STATE_FOCUSED) then
        GuiTooltip(bounds)
    end if
    '--------------------------------------------------------------------

    return result
end function

' Toggle Group control, returns toggled button codepointIndex
function GuiToggleGroup(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long

    #ifndef RAYGUI_TOGGLEGROUP_MAX_ITEMS
        #define RAYGUI_TOGGLEGROUP_MAX_ITEMS    32
    #endif

    var result = 0
    var initBoundsX = bounds.x

    var temp = 0l
    if (active = NULL) then 
        active = @temp
    end if

    var toggle = false    ' Required for individual toggles

    ' Get substrings items from text (items pointers)
    dim as long rows(0 to RAYGUI_TOGGLEGROUP_MAX_ITEMS - 1)
    var itemCount = 0l
    var items = GuiTextSplit(text, asc(";"), @itemCount, @rows(0))

    var prevRow = rows(0)

    for i as integer = 0 to itemCount - 1
    
        if (prevRow <> rows(i)) then
        
            bounds.x = initBoundsX
            bounds.y += (bounds.height + GuiGetStyle(TOGGLE, GROUP_PADDING))
            prevRow = rows(i)
        end if

        if (i = (*active)) then
        
            toggle = true
            GuiToggle(bounds, items[i], @toggle)
        
        else
        
            toggle = false
            GuiToggle(bounds, items[i], @toggle)
            if (toggle) then 
                *active = i
            end if
        end if

        bounds.x += (bounds.width_ + GuiGetStyle(TOGGLE, GROUP_PADDING))
    next i

    return result
end function

' Toggle Slider control extended, returns true when clicked
function GuiToggleSlider(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long
    var result = 0
    var state = guiState_

    var temp = 0l
    if (active = NULL) then
        active = @temp
    end if

    ' Get substrings items from text (items pointers)
    var itemCount = 0l
    var items = GuiTextSplit(text, asc(";"), @itemCount, NULL)

    var slider = type<Rectangle>( _
        0, _     ' Calculated later depending on the active toggle
        bounds.y + GuiGetStyle(SLIDER_, BORDER_WIDTH) + GuiGetStyle(SLIDER_, SLIDER_PADDING), _
        (bounds.width_ - 2*GuiGetStyle(SLIDER_, BORDER_WIDTH) - (itemCount + 1)*GuiGetStyle(SLIDER_, SLIDER_PADDING))/itemCount, _
        bounds.height - 2*GuiGetStyle(SLIDER_, BORDER_WIDTH) - 2*GuiGetStyle(SLIDER_, SLIDER_PADDING) )

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then 
                state = STATE_PRESSED
            
            elseif (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                (*active) += 1
                result = 1
            
            else 
                state = STATE_FOCUSED
            end if
        end if
        
        if ((*active) AND (state <> STATE_FOCUSED)) then 
            state = STATE_PRESSED
        end if
    end if

    if (*active >= itemCount) then 
        *active = 0
    end if
    slider.x = bounds.x + GuiGetStyle(SLIDER_, BORDER_WIDTH) + (*active + 1)*GuiGetStyle(SLIDER_, SLIDER_PADDING) + (*active)*slider.width_
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(SLIDER_, BORDER_WIDTH), GetColor(GuiGetStyle(TOGGLE, BORDER + (state*3))), _
        GetColor(GuiGetStyle(TOGGLE, BASE_COLOR_NORMAL)))

    ' Draw internal slider
    if (state = STATE_NORMAL) then 
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, BASE_COLOR_PRESSED)))
    elseif (state = STATE_FOCUSED) then 
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, BASE_COLOR_FOCUSED)))
    elseif (state = STATE_PRESSED) then 
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, BASE_COLOR_PRESSED)))
    end if

    ' Draw text in slider
    if (text <> NULL) then
    
        dim textBounds as Rectangle
        textBounds.width_ = GetTextWidth(text)
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = slider.x + slider.width_/2 - textBounds.width_/2
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

        GuiDrawText(items[*active], textBounds, GuiGetStyle(TOGGLE, TEXT_ALIGNMENT), Fade(GetColor(GuiGetStyle(TOGGLE, TEXT_ + (state*3))), guiAlpha))
    end if
    '--------------------------------------------------------------------

    return result
end function

' Check Box control, returns true when active
function GuiCheckBox(byval bounds as Rectangle, byval text as const zstring ptr, byval checked as boolean ptr) as long

    var result = 0
    var state = guiState_

    var temp = false
    if (checked = NULL) then
        checked = @temp
    end if

    dim textBounds as Rectangle

    if (text <> NULL) then
    
        textBounds.width_ = GetTextWidth(text) + 2
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x + bounds.width_ + GuiGetStyle(CHECKBOX, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
        if (GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = TEXT_ALIGN_LEFT) then 
            textBounds.x = bounds.x - textBounds.width_ - GuiGetStyle(CHECKBOX, TEXT_PADDING)
        end if
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        var totalBounds = type<Rectangle>( _
            iif((GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = TEXT_ALIGN_LEFT), textBounds.x , bounds.x), _
            bounds.y, _
            bounds.width_ + textBounds.width_ + GuiGetStyle(CHECKBOX, TEXT_PADDING), _
            bounds.height _
        )

        ' Check checkbox state
        if (CheckCollisionPointRec(mousePoint, totalBounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then 
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if

            if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then 
                *checked = not(*checked)
            end if
        end if
    end if
    
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(CHECKBOX, BORDER_WIDTH), GetColor(GuiGetStyle(CHECKBOX, BORDER + (state*3))), BLANK)

    if (*checked) then
    
        var check = type<Rectangle>( bounds.x + GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING), _
                            bounds.y + GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING), _
                            bounds.width_ - 2*(GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING)), _
                            bounds.height - 2*(GuiGetStyle(CHECKBOX, BORDER_WIDTH) + GuiGetStyle(CHECKBOX, CHECK_PADDING)) )
        GuiDrawRectangle(check, 0, BLANK, GetColor(GuiGetStyle(CHECKBOX, TEXT_ + state*3)))
    end if

    GuiDrawText(text, textBounds, iif((GuiGetStyle(CHECKBOX, TEXT_ALIGNMENT) = TEXT_ALIGN_RIGHT), TEXT_ALIGN_LEFT , TEXT_ALIGN_RIGHT), GetColor(GuiGetStyle(LABEL, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    return result
end function

' Combo Box control, returns selected item codepointIndex
function GuiComboBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr) as long

    var result = 0
    var state = guiState_

    var temp = 0l
    if (active = NULL) then 
        active = @temp
    end if

    bounds.width_ -= (GuiGetStyle(COMBOBOX, COMBO_BUTTON_WIDTH) + GuiGetStyle(COMBOBOX, COMBO_BUTTON_SPACING))

    var selector = type<Rectangle>( bounds.x + bounds.width_ + GuiGetStyle(COMBOBOX, COMBO_BUTTON_SPACING), _
                           bounds.y, GuiGetStyle(COMBOBOX, COMBO_BUTTON_WIDTH), bounds.height )

    ' Get substrings items from text (items pointers, lengths and count)
    var itemCount = 0l
    var items = GuiTextSplit(text, asc(";"), @itemCount, NULL)

    if (*active < 0) then 
        *active = 0
    elseif (*active > (itemCount - 1)) then
        *active = itemCount - 1
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND cbool(itemCount > 1) AND (not guiSliderDragging)) then
        var mousePoint = GetMousePosition()

        if (CheckCollisionPointRec(mousePoint, bounds) OR _
            CheckCollisionPointRec(mousePoint, selector)) then
        
            if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
            
                *active += 1
                if (*active >= itemCount) then 
                    *active = 0      ' Cyclic combobox
                end if
            end if

            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then 
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    ' Draw combo box main
    GuiDrawRectangle(bounds, GuiGetStyle(COMBOBOX, BORDER_WIDTH), GetColor(GuiGetStyle(COMBOBOX, BORDER + (state*3))), GetColor(GuiGetStyle(COMBOBOX, BASE_ + (state*3))))
    GuiDrawText(items[*active], GetTextBounds(COMBOBOX, bounds), GuiGetStyle(COMBOBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(COMBOBOX, TEXT_ + (state*3))))

    ' Draw selector using a custom button
    ' NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values
    var tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
    var tempTextAlign = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
    GuiSetStyle(BUTTON, BORDER_WIDTH, 1)
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

    GuiButton(selector, TextFormat("%i/%i", *active + 1, itemCount))

    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlign)
    GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)
    '--------------------------------------------------------------------

    return result
end function

' Dropdown Box control
' NOTE: Returns mouse click
function GuiDropdownBox(byval bounds as Rectangle, byval text as const zstring ptr, byval active as long ptr, byval editMode as boolean) as long

    var result = 0
    var state = guiState_

    var itemSelected = *active
    var itemFocused = -1

    ' Get substrings items from text (items pointers, lengths and count)
    var itemCount = 0l
    var items = GuiTextSplit(text, asc(";"), @itemCount, NULL)

    var boundsOpen = bounds
    boundsOpen.height = (itemCount + 1)*(bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_SPACING))

    var itemBounds = bounds

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (editMode OR (not guiLocked)) AND cbool(itemCount > 1) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        if (editMode) then
        
            state = STATE_PRESSED

            ' Check if mouse has been pressed or released outside limits
            if (not CheckCollisionPointRec(mousePoint, boundsOpen)) then
            
                if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) OR IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then 
                    result = 1
                end if
            end if

            ' Check if already selected item has been pressed again
            if (CheckCollisionPointRec(mousePoint, bounds) AND IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                result = 1
            end if

            ' Check focused and selected item
            for i as integer = 0 to itemCount - 1
                ' Update item rectangle y position for next item
                itemBounds.y += (bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_SPACING))

                if (CheckCollisionPointRec(mousePoint, itemBounds)) then
                    itemFocused = i
                    if (IsMouseButtonReleased(MOUSE_LEFT_BUTTON)) then
                        itemSelected = i
                        result = 1         ' Item selected
                    end if
                    exit for
                end if
            next i

            itemBounds = bounds
        
        else
        
            if (CheckCollisionPointRec(mousePoint, bounds)) then
                if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                    result = 1
                    state = STATE_PRESSED
                
                else 
                    state = STATE_FOCUSED
                end if
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (editMode) then 
        GuiPanel(boundsOpen, NULL)
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), GetColor(GuiGetStyle(DROPDOWNBOX, BORDER + state*3)), GetColor(GuiGetStyle(DROPDOWNBOX, BASE_ + state*3)))
    GuiDrawText(items[itemSelected], GetTextBounds(DROPDOWNBOX, bounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_ + state*3)))

    if (editMode) then
        ' Draw visible items
        for i as integer = 0 to itemCount - 1
            ' Update item rectangle y position for next item
            itemBounds.y += (bounds.height + GuiGetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_SPACING))

            if (i = itemSelected) then
                GuiDrawRectangle(itemBounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), GetColor(GuiGetStyle(DROPDOWNBOX, BORDER_COLOR_PRESSED)), GetColor(GuiGetStyle(DROPDOWNBOX, BASE_COLOR_PRESSED)))
                GuiDrawText(items[i], GetTextBounds(DROPDOWNBOX, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_PRESSED)))
            
            elseif (i = itemFocused) then
                GuiDrawRectangle(itemBounds, GuiGetStyle(DROPDOWNBOX, BORDER_WIDTH), GetColor(GuiGetStyle(DROPDOWNBOX, BORDER_COLOR_FOCUSED)), GetColor(GuiGetStyle(DROPDOWNBOX, BASE_COLOR_FOCUSED)))
                GuiDrawText(items[i], GetTextBounds(DROPDOWNBOX, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_FOCUSED)))
            
            else 
                GuiDrawText(items[i], GetTextBounds(DROPDOWNBOX, itemBounds), GuiGetStyle(DROPDOWNBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_COLOR_NORMAL)))
            end if
        next i
    end if

    ' Draw arrows (using icon if available)
#ifdef RAYGUI_NO_ICONS
    GuiDrawText("v", type<Rectangle>( bounds.x + bounds.width_ - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING), bounds.y + bounds.height/2 - 2, 10, 10 ), _
                TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_ + (state*3))))
#else
    GuiDrawText("#120#", type<Rectangle>( bounds.x + bounds.width_ - GuiGetStyle(DROPDOWNBOX, ARROW_PADDING), bounds.y + bounds.height/2 - 6, 10, 10 ), _
                TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_ + (state*3))))   ' ICON_ARROW_DOWN_FILL
#endif
    '--------------------------------------------------------------------

    *active = itemSelected

    ' TODO: Use result to return more internal states: mouse-press out-of-bounds, mouse-press over selected-item...
    return result   ' Mouse click: result = 1
end function

' Text Box control
' NOTE: Returns true on ENTER pressed (useful for data validation)
function GuiTextBox(byval bounds as Rectangle, byval text as zstring ptr, byval bufferSize as long, byval editMode as boolean) as long

    #ifndef RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN
        #define RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN  40        ' Frames to wait for autocursor movement
    #endif
    #ifndef RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY
        #define RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY      1        ' Frames delay for autocursor movement
    #endif

    var result = 0
    var state = guiState_

    var multiline = false     ' TODO: Consider multiline text input
    var wrapMode = GuiGetStyle(DEFAULT, TEXT_WRAP_MODE)

    var textBounds = GetTextBounds(TEXTBOX, bounds)
    var textWidth = GetTextWidth(text) - GetTextWidth(text + textBoxCursorIndex)
    var textIndexOffset = 0    ' Text index offset to start drawing in the box

    ' Cursor rectangle
    ' NOTE: Position X value should be updated
    var cursor = type<Rectangle>( _
        textBounds.x + textWidth + GuiGetStyle(DEFAULT, TEXT_SPACING), _
        textBounds.y + textBounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE), _
        2, _
        GuiGetStyle(DEFAULT, TEXT_SIZE)*2 _
    )

    if (cursor.height >= bounds.height) then 
        cursor.height = bounds.height - GuiGetStyle(TEXTBOX, BORDER_WIDTH)*2
    end if
    if (cursor.y < (bounds.y + GuiGetStyle(TEXTBOX, BORDER_WIDTH))) then 
        cursor.y = bounds.y + GuiGetStyle(TEXTBOX, BORDER_WIDTH)
    end if

    ' Mouse cursor rectangle
    ' NOTE: Initialized outside of screen
    var mouseCursor_ = cursor
    mouseCursor_.x = -1
    mouseCursor_.width_ = 1

    ' Auto-cursor movement logic
    ' NOTE: Cursor moves automatically when key down after some time
    if (IsKeyDown(KEY_LEFT) OR IsKeyDown(KEY_RIGHT) OR IsKeyDown(KEY_UP) OR IsKeyDown(KEY_DOWN) OR IsKeyDown(KEY_BACKSPACE) OR IsKeyDown(KEY_DELETE)) then
        autoCursorCooldownCounter += 1
    else
        autoCursorCooldownCounter = 0      ' GLOBAL: Cursor cooldown counter
        autoCursorDelayCounter = 0         ' GLOBAL: Cursor delay counter
    end if

    ' Update control
    '--------------------------------------------------------------------
    ' WARNING: Text editing is only supported under certain conditions:
    if (cbool(state <> STATE_DISABLED) AND _               ' Control not disabled
        (not cbool(GuiGetStyle(TEXTBOX, TEXT_READONLY))) AND _    ' TextBox not on read-only mode
        (not guiLocked) AND _                              ' Gui not locked
        (not guiSliderDragging) AND _                      ' No gui slider on dragging
        cbool(wrapMode = TEXT_WRAP_NONE)) then              ' No wrap mode
    
        var mousePosition = GetMousePosition()

        if (editMode) then
            state = STATE_PRESSED

            ' If text does not fit in the textbox and current cursor position is out of bounds,
            ' we add an index offset to text for drawing only what requires depending on cursor
            while (textWidth >= textBounds.width_)
            
                var nextCodepointSize = 0l
                GetCodepointNext(text + textIndexOffset, @nextCodepointSize)

                textIndexOffset += nextCodepointSize

                textWidth = GetTextWidth(text + textIndexOffset) - GetTextWidth(text + textBoxCursorIndex)
            wend

            var textLength_ = strlen(text)     ' Get current text length
            var codepoint = GetCharPressed()       ' Get Unicode codepoint
            if (multiline AND IsKeyPressed(KEY_ENTER)) then 
                codepoint = 13 ' \n
            end if

            if (textBoxCursorIndex > textLength_) then 
                textBoxCursorIndex = textLength_
            end if

            ' Encode codepoint as UTF-8
            var codepointSize = 0l
            var charEncoded = CodepointToUTF8(codepoint, @codepointSize)

            ' Add codepoint to text, at current cursor position
            ' NOTE: Make sure we do not overflow buffer size
            if (((multiline AND (codepoint = 13)) OR (codepoint >= 32)) AND ((textLength_ + codepointSize) < bufferSize)) then
            
                ' Move forward data from cursor position
                for i as integer = textLength_ + codepointSize to textBoxCursorIndex + 1 step -1
                    text[i] = text[i - codepointSize]
                next i

                ' Add new codepoint in current cursor position
                for i as integer = 0 to codepointSize - 1
                    text[textBoxCursorIndex + i] = charEncoded[i]
                next i

                textBoxCursorIndex += codepointSize
                textLength_ += codepointSize

                ' Make sure text last character is EOL
                text[textLength_] = 0
            end if

            ' Move cursor to start
            if ((textLength_ > 0) AND IsKeyPressed(KEY_HOME)) then 
                textBoxCursorIndex = 0
            end if

            ' Move cursor to end
            if ((textLength_ > textBoxCursorIndex) AND IsKeyPressed(KEY_END)) then 
                textBoxCursorIndex = textLength_
            end if

            ' Delete codepoint from text, after current cursor position
            if (cbool(textLength_ > textBoxCursorIndex) AND (IsKeyPressed(KEY_DELETE) OR (IsKeyDown(KEY_DELETE) AND cbool(autoCursorCooldownCounter >= RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN)))) then
                autoCursorDelayCounter += 1

                if (IsKeyPressed(KEY_DELETE) OR (autoCursorDelayCounter mod RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY) = 0) then      ' Delay every movement some frames
                    var nextCodepointSize = 0l
                    GetCodepointNext(text + textBoxCursorIndex, @nextCodepointSize)

                    ' Move backward text from cursor position
                    for i as integer = textBoxCursorIndex to textLength_ - 1
                        text[i] = text[i + nextCodepointSize]
                    next i

                    textLength_ -= codepointSize

                    ' Make sure text last character is EOL
                    text[textLength_] = 0
                end if
            end if

            ' Delete codepoint from text, before current cursor position
            if (cbool(textLength_ > 0) AND (IsKeyPressed(KEY_BACKSPACE) OR (IsKeyDown(KEY_BACKSPACE) AND cbool(autoCursorCooldownCounter >= RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN)))) then
                autoCursorDelayCounter += 1

                if (IsKeyPressed(KEY_BACKSPACE) OR (autoCursorDelayCounter mod RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY) = 0) then     ' Delay every movement some frames
                
                    var prevCodepointSize = 0l
                    GetCodepointPrevious(text + textBoxCursorIndex, @prevCodepointSize)

                    ' Move backward text from cursor position
                    for i as integer = textBoxCursorIndex - prevCodepointSize to textLength_ - 1
                        text[i] = text[i + prevCodepointSize]
                    next i

                    ' Prevent cursor index from decrementing past 0
                    if (textBoxCursorIndex > 0) then
                        textBoxCursorIndex -= codepointSize
                        textLength_ -= codepointSize
                    end if

                    ' Make sure text last character is EOL
                    text[textLength_] = 0
                end if
            end if

            ' Move cursor position with keys
            if (IsKeyPressed(KEY_LEFT) OR (IsKeyDown(KEY_LEFT) AND cbool(autoCursorCooldownCounter > RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN))) then
                autoCursorDelayCounter += 1

                if (IsKeyPressed(KEY_LEFT) OR (autoCursorDelayCounter mod RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY) = 0) then      ' Delay every movement some frames
                    var prevCodepointSize = 0l
                    GetCodepointPrevious(text + textBoxCursorIndex, @prevCodepointSize)

                    if (textBoxCursorIndex >= prevCodepointSize) then 
                        textBoxCursorIndex -= prevCodepointSize
                    end if
                end if
            
            elseif (IsKeyPressed(KEY_RIGHT) OR (IsKeyDown(KEY_RIGHT) AND cbool(autoCursorCooldownCounter > RAYGUI_TEXTBOX_AUTO_CURSOR_COOLDOWN))) then
                autoCursorDelayCounter += 1

                if (IsKeyPressed(KEY_RIGHT) OR (autoCursorDelayCounter mod RAYGUI_TEXTBOX_AUTO_CURSOR_DELAY) = 0) then      ' Delay every movement some frames
                    var nextCodepointSize = 0l
                    GetCodepointNext(text + textBoxCursorIndex, @nextCodepointSize)

                    if ((textBoxCursorIndex + nextCodepointSize) <= textLength_) then
                        textBoxCursorIndex += nextCodepointSize
                    end if
                end if
            end if

            ' Move cursor position with mouse
            if (CheckCollisionPointRec(mousePosition, textBounds)) then    ' Mouse hover text
                var scaleFactor = csng(GuiGetStyle(DEFAULT, TEXT_SIZE) / guiFont.baseSize)
                var codepoint = 0l
                var codepointSize = 0l
                var codepointIndex = 0l
                var glyphWidth = 0.0f
                var widthToMouseX = 0.0f
                var mouseCursorIndex = 0l

                for i as integer = textIndexOffset to textLength_ - 1
                    codepoint = GetCodepointNext(@text[i], @codepointSize)
                    codepointIndex = GetGlyphIndex(guiFont, codepoint)

                    if (guiFont.glyphs[codepointIndex].advanceX = 0) then
                        glyphWidth = (guiFont.recs[codepointIndex].width_*scaleFactor)
                    else 
                        glyphWidth = (guiFont.glyphs[codepointIndex].advanceX*scaleFactor)
                    end if

                    if (mousePosition.x <= (textBounds.x + (widthToMouseX + glyphWidth/2))) then
                        mouseCursor_.x = textBounds.x + widthToMouseX
                        mouseCursorIndex = i
                        exit for
                    end if
                    
                    widthToMouseX += (glyphWidth + GuiGetStyle(DEFAULT, TEXT_SPACING))
                next i

                ' Check if mouse cursor is at the last position
                var textEndWidth = GetTextWidth(text + textIndexOffset)
                if (GetMousePosition().x >= (textBounds.x + textEndWidth - glyphWidth/2)) then
                    mouseCursor_.x = textBounds.x + textEndWidth
                    mouseCursorIndex = strlen(text)
                end if

                ' Place cursor at required index on mouse click
                if ((mouseCursor_.x >= 0) AND IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                    cursor.x = mouseCursor_.x
                    textBoxCursorIndex = mouseCursorIndex
                end if
            else 
                mouseCursor_.x = -1
            end if

            ' Recalculate cursor position.y depending on textBoxCursorIndex
            cursor.x = bounds.x + GuiGetStyle(TEXTBOX, TEXT_PADDING) + GetTextWidth(text + textIndexOffset) - GetTextWidth(text + textBoxCursorIndex) + GuiGetStyle(DEFAULT, TEXT_SPACING)
            'if (multiline) cursor.y = GetTextLines()

            ' Finish text editing on ENTER or mouse click outside bounds
            if (((not multiline) AND IsKeyPressed(KEY_ENTER)) OR _
                ((not CheckCollisionPointRec(mousePosition, bounds)) AND IsMouseButtonPressed(MOUSE_LEFT_BUTTON))) then

                textBoxCursorIndex = 0     ' GLOBAL: Reset the shared cursor index
                result = 1
            end if
        
        else
        
            if (CheckCollisionPointRec(mousePosition, bounds)) then
                state = STATE_FOCUSED

                if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                    textBoxCursorIndex = strlen(text)   ' GLOBAL: Place cursor index to the end of current text
                    result = 1
                end if
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state = STATE_PRESSED) then
    
        GuiDrawRectangle(bounds, GuiGetStyle(TEXTBOX, BORDER_WIDTH), GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), GetColor(GuiGetStyle(TEXTBOX, BASE_COLOR_PRESSED)))
    
    elseif (state = STATE_DISABLED) then
    
        GuiDrawRectangle(bounds, GuiGetStyle(TEXTBOX, BORDER_WIDTH), GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), GetColor(GuiGetStyle(TEXTBOX, BASE_COLOR_DISABLED)))
    
    else 
        GuiDrawRectangle(bounds, GuiGetStyle(TEXTBOX, BORDER_WIDTH), GetColor(GuiGetStyle(TEXTBOX, BORDER + (state*3))), BLANK)
    end if

    ' Draw text considering index offset if required
    ' NOTE: Text index offset depends on cursor position
    GuiDrawText(text + textIndexOffset, textBounds, GuiGetStyle(TEXTBOX, TEXT_ALIGNMENT), GetColor(GuiGetStyle(TEXTBOX, TEXT_ + (state*3))))

    ' Draw cursor
    if (editMode AND cbool(not GuiGetStyle(TEXTBOX, TEXT_READONLY))) then
    
        'if (autoCursorMode OR ((blinkCursorFrameCounter/40)%2 == 0))
        GuiDrawRectangle(cursor, 0, BLANK, GetColor(GuiGetStyle(TEXTBOX, BORDER_COLOR_PRESSED)))

        ' Draw mouse position cursor (if required)
        if (mouseCursor_.x >= 0) then 
            GuiDrawRectangle(mouseCursor_, 0, BLANK, GetColor(GuiGetStyle(TEXTBOX, BORDER_COLOR_PRESSED)))
        end if
    
    elseif (state = STATE_FOCUSED) then
        GuiTooltip(bounds)
    end if
    '--------------------------------------------------------------------

    return result      ' Mouse button pressed: result = 1
end function

' Spinner control, returns selected value
function GuiSpinner(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as long

    var result = 1
    var state = guiState_

    var tempValue = *value

    var spinner = type<Rectangle>( bounds.x + GuiGetStyle(SPINNER_, SPIN_BUTTON_WIDTH) + GuiGetStyle(SPINNER_, SPIN_BUTTON_SPACING), bounds.y, _
                          bounds.width_ - 2*(GuiGetStyle(SPINNER_, SPIN_BUTTON_WIDTH) + GuiGetStyle(SPINNER_, SPIN_BUTTON_SPACING)), bounds.height )
    var leftButtonBound = type<Rectangle>( bounds.x, bounds.y, GuiGetStyle(SPINNER_, SPIN_BUTTON_WIDTH), bounds.height )
    var rightButtonBound = type<Rectangle>( bounds.x + bounds.width_ - GuiGetStyle(SPINNER_, SPIN_BUTTON_WIDTH), bounds.y, GuiGetStyle(SPINNER_, SPIN_BUTTON_WIDTH), bounds.height )

    dim textBounds as Rectangle
    if (text <> NULL) then
    
        textBounds.width_ = GetTextWidth(text) + 2
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x + bounds.width_ + GuiGetStyle(SPINNER_, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
        if (GuiGetStyle(SPINNER_, TEXT_ALIGNMENT) = TEXT_ALIGN_LEFT) then
            textBounds.x = bounds.x - textBounds.width_ - GuiGetStyle(SPINNER_, TEXT_PADDING)
        end if
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        ' Check spinner state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if

#ifdef RAYGUI_NO_ICONS
    if (GuiButton(leftButtonBound, "<")) then
        tempValue -= 1
    end if
    if (GuiButton(rightButtonBound, ">")) then
        tempValue += 1
    end if
#else
    if (GuiButton(leftButtonBound, GuiIconText(ICON_ARROW_LEFT_FILL, NULL))) then
        tempValue -= 1
    end if
    if (GuiButton(rightButtonBound, GuiIconText(ICON_ARROW_RIGHT_FILL, NULL))) then
        tempValue += 1
    end if
#endif

    if (not editMode) then
    
        if (tempValue < minValue) then
            tempValue = minValue
        end if
        if (tempValue > maxValue) then
            tempValue = maxValue
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    result = GuiValueBox(spinner, NULL, @tempValue, minValue, maxValue, editMode)

    ' Draw value selector custom buttons
    ' NOTE: BORDER_WIDTH and TEXT_ALIGNMENT forced values
    var tempBorderWidth = GuiGetStyle(BUTTON, BORDER_WIDTH)
    var tempTextAlign = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
    GuiSetStyle(BUTTON, BORDER_WIDTH, GuiGetStyle(SPINNER_, BORDER_WIDTH))
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, tempTextAlign)
    GuiSetStyle(BUTTON, BORDER_WIDTH, tempBorderWidth)

    ' Draw text label if provided
    GuiDrawText(text, textBounds, iif((GuiGetStyle(SPINNER_, TEXT_ALIGNMENT) = TEXT_ALIGN_RIGHT), TEXT_ALIGN_LEFT , TEXT_ALIGN_RIGHT), GetColor(GuiGetStyle(LABEL, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    *value = tempValue
    return result
end function

' Value Box control, updates input text with numbers
' NOTE: Requires static variables: frameCounter
function GuiValueBox(byval bounds as Rectangle, byval text as const zstring ptr, byval value as long ptr, byval minValue as long, byval maxValue as long, byval editMode as boolean) as long

    #ifndef RAYGUI_VALUEBOX_MAX_CHARS
        #define RAYGUI_VALUEBOX_MAX_CHARS  32
    #endif

    var result = 0l
    var state = guiState_

    dim textValue as zstring * (RAYGUI_VALUEBOX_MAX_CHARS + 1) 
    sprintf(@textValue, "%i", *value)

    dim textBounds as Rectangle
    if (text <> NULL) then
    
        textBounds.width_ = GetTextWidth(text) + 2
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x + bounds.width_ + GuiGetStyle(VALUEBOX, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
        if (GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = TEXT_ALIGN_LEFT) then
            textBounds.x = bounds.x - textBounds.width_ - GuiGetStyle(VALUEBOX, TEXT_PADDING)
        end if
    end if

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        var valueHasChanged = false

        if (editMode) then
        
            state = STATE_PRESSED

            var keyCount = strlen(textValue)

            ' Only allow keys in range [48..57]
            if (keyCount < RAYGUI_VALUEBOX_MAX_CHARS) then
            
                if (GetTextWidth(textValue) < bounds.width_) then
                
                    var key = GetCharPressed()
                    if ((key >= 48) AND (key <= 57)) then
                    
                        textValue[keyCount] = key
                        keyCount += 1
                        valueHasChanged = true
                    end if
                end if
            end if

            ' Delete text
            if (keyCount > 0) then
            
                if (IsKeyPressed(KEY_BACKSPACE)) then
                
                    keyCount -= 1
                    textValue[keyCount] = 0
                    valueHasChanged = true
                end if
            end if

            if (valueHasChanged) then
                *value = TextToInteger(textValue)
            end if

            ' NOTE: We are not clamp values until user input finishes
            'if (*value > maxValue) *value = maxValue
            'else if (*value < minValue) *value = minValue

            if (IsKeyPressed(KEY_ENTER) OR ((not CheckCollisionPointRec(mousePoint, bounds)) AND IsMouseButtonPressed(MOUSE_LEFT_BUTTON))) then
                result = 1
            end if
        
        else
        
            if (*value > maxValue) then
                *value = maxValue
            elseif (*value < minValue) then
                *value = minValue
            end if

            if (CheckCollisionPointRec(mousePoint, bounds)) then
            
                state = STATE_FOCUSED
                if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                    result = 1
                end if
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    var baseColor = BLANK
    if (state = STATE_PRESSED) then
        baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_PRESSED))
    elseif (state = STATE_DISABLED) then
        baseColor = GetColor(GuiGetStyle(VALUEBOX, BASE_COLOR_DISABLED))
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(VALUEBOX, BORDER_WIDTH), GetColor(GuiGetStyle(VALUEBOX, BORDER + (state*3))), baseColor)
    GuiDrawText(textValue, GetTextBounds(VALUEBOX, bounds), TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(VALUEBOX, TEXT_ + (state*3))))

    ' Draw cursor
    if (editMode) then
    
        ' NOTE: ValueBox internal text is always centered
        var cursor = type<Rectangle>( bounds.x + GetTextWidth(textValue)/2 + bounds.width_/2 + 1, bounds.y + 2*GuiGetStyle(VALUEBOX, BORDER_WIDTH), 4, bounds.height - 4*GuiGetStyle(VALUEBOX, BORDER_WIDTH) )
        GuiDrawRectangle(cursor, 0, BLANK, GetColor(GuiGetStyle(VALUEBOX, BORDER_COLOR_PRESSED)))
    end if

    ' Draw text label if provided
    GuiDrawText(text, textBounds, iif((GuiGetStyle(VALUEBOX, TEXT_ALIGNMENT) = TEXT_ALIGN_RIGHT), TEXT_ALIGN_LEFT , TEXT_ALIGN_RIGHT), GetColor(GuiGetStyle(LABEL, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    return result
end function

' Slider control with pro parameters
' NOTE: Other GuiSlider*() controls use this one
function GuiSliderPro(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single, byval sliderWidth as long) as long

    var result = 0l
    var state = guiState_

    var temp = (maxValue - minValue)/2.0f
    if (value = NULL) then
        value = @temp
    end if

    var sliderValue = clng(((*value - minValue)/(maxValue - minValue))*(bounds.width_ - 2*GuiGetStyle(SLIDER_, BORDER_WIDTH)))

    var slider = type<Rectangle>( bounds.x, bounds.y + GuiGetStyle(SLIDER_, BORDER_WIDTH) + GuiGetStyle(SLIDER_, SLIDER_PADDING), _
                         0, bounds.height - 2*GuiGetStyle(SLIDER_, BORDER_WIDTH) - 2*GuiGetStyle(SLIDER_, SLIDER_PADDING) )

    if (sliderWidth > 0) then       ' Slider
    
        slider.x += (sliderValue - sliderWidth/2)
        slider.width_ = sliderWidth
    
    elseif (sliderWidth = 0) then  ' SliderBar
    
        slider.x += GuiGetStyle(SLIDER_, BORDER_WIDTH)
        slider.width_ = sliderValue
    end if

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        if (guiSliderDragging) then ' Keep dragging outside of bounds
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                if (CHECK_BOUNDS_ID(bounds, guiSliderActive)) then
                
                    state = STATE_PRESSED

                    ' Get equivalent value and slider position from mousePosition.x
                    *value = ((maxValue - minValue)*(mousePoint.x - (bounds.x + sliderWidth/2)))/(bounds.width_ - sliderWidth) + minValue
                end if
            
            else
            
                guiSliderDragging = false
                guiSliderActive = type<Rectangle>( 0, 0, 0, 0 )
            end if
        
        elseif (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                guiSliderDragging = true
                guiSliderActive = bounds ' Store bounds as an identifier when dragging starts

                if (not CheckCollisionPointRec(mousePoint, slider)) then
                
                    ' Get equivalent value and slider position from mousePosition.x
                    *value = ((maxValue - minValue)*(mousePoint.x - (bounds.x + sliderWidth/2)))/(bounds.width_ - sliderWidth) + minValue

                    if (sliderWidth > 0) then
                        slider.x = mousePoint.x - slider.width_/2      ' Slider
                    elseif (sliderWidth = 0) then
                        slider.width_ = sliderValue       ' SliderBar
                    end if
                end if
            
            else 
                state = STATE_FOCUSED
            end if
        end if

        if (*value > maxValue) then
            *value = maxValue
        elseif (*value < minValue) then
            *value = minValue
        end if
    end if

    ' Bar limits check
    if (sliderWidth > 0) then        ' Slider
    
        if (slider.x <= (bounds.x + GuiGetStyle(SLIDER_, BORDER_WIDTH))) then
            slider.x = bounds.x + GuiGetStyle(SLIDER_, BORDER_WIDTH)
        elseif ((slider.x + slider.width_) >= (bounds.x + bounds.width_)) then
            slider.x = bounds.x + bounds.width_ - slider.width_ - GuiGetStyle(SLIDER_, BORDER_WIDTH)
        end if
    
    elseif (sliderWidth = 0) then  ' SliderBar
    
        if (slider.width_ > bounds.width_) then
            slider.width_ = bounds.width_ - 2*GuiGetStyle(SLIDER_, BORDER_WIDTH)
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(SLIDER_, BORDER_WIDTH), GetColor(GuiGetStyle(SLIDER_, BORDER + (state*3))), GetColor(GuiGetStyle(SLIDER_, iif((state <> STATE_DISABLED),  BASE_COLOR_NORMAL , BASE_COLOR_DISABLED))))

    ' Draw slider internal bar (depends on state)
    if (state = STATE_NORMAL) then
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, BASE_COLOR_PRESSED)))
    elseif (state = STATE_FOCUSED) then
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, TEXT_COLOR_FOCUSED)))
    elseif (state = STATE_PRESSED) then
        GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, TEXT_COLOR_PRESSED)))
    end if

    ' Draw left/right text if provided
    if (textLeft <> NULL) then
    
        dim textBounds as Rectangle
        textBounds.width_ = GetTextWidth(textLeft)
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x - textBounds.width_ - GuiGetStyle(SLIDER_, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

        GuiDrawText(textLeft, textBounds, TEXT_ALIGN_RIGHT, GetColor(GuiGetStyle(SLIDER_, TEXT_ + (state*3))))
    end if

    if (textRight <> NULL) then
    
        dim textBounds as Rectangle 
        textBounds.width_ = GetTextWidth(textRight)
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x + bounds.width_ + GuiGetStyle(SLIDER_, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

        GuiDrawText(textRight, textBounds, TEXT_ALIGN_LEFT, GetColor(GuiGetStyle(SLIDER_, TEXT_ + (state*3))))
    end if
    '--------------------------------------------------------------------

    return result
end function

' Slider control extended, returns selected value and has text
function GuiSlider(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long
    return GuiSliderPro(bounds, textLeft, textRight, value, minValue, maxValue, GuiGetStyle(SLIDER_, SLIDER_WIDTH))
end function

' Slider Bar control extended, returns selected value
function GuiSliderBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long
    return GuiSliderPro(bounds, textLeft, textRight, value, minValue, maxValue, 0)
end function

' Progress Bar control extended, shows current progress value
function GuiProgressBar(byval bounds as Rectangle, byval textLeft as const zstring ptr, byval textRight as const zstring ptr, byval value as single ptr, byval minValue as single, byval maxValue as single) as long

    var result = 0l
    var state = guiState_

    var temp = (maxValue - minValue)/2.0f
    if (value = NULL) then
        value = @temp
    end if

    ' Progress bar
    var progress = type<Rectangle>( bounds.x + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), _
                           bounds.y + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) + GuiGetStyle(PROGRESSBAR, PROGRESS_PADDING), 0, _
                           bounds.height - 2*GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) - 2*GuiGetStyle(PROGRESSBAR, PROGRESS_PADDING) )

    ' Update control
    '--------------------------------------------------------------------
    if (*value > maxValue) then
        *value = maxValue
    end if

    ' WARNING: Working with floats could lead to rounding issues
    if ((state <> STATE_DISABLED)) then
        progress.width_ = (*value/(maxValue - minValue))*bounds.width_ - iif((*value >= maxValue) , (2*GuiGetStyle(PROGRESSBAR, BORDER_WIDTH)) , 0.0f)
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state = STATE_DISABLED) then
    
        GuiDrawRectangle(bounds, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), GetColor(GuiGetStyle(PROGRESSBAR, BORDER + (state*3))), BLANK)
    
    else
    
        if (*value > minValue) then
        
            ' Draw progress bar with colored border, more visual
            GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y, int(progress.width_) + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_FOCUSED)))
            GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + 1, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), bounds.height - 2 ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_FOCUSED)))
            GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y + bounds.height - 1, int(progress.width_) + GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_FOCUSED)))
        
        else 
            GuiDrawRectangle(type<Rectangle>( bounds.x, bounds.y, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), bounds.height ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_NORMAL)))
        end if

        if (*value >= maxValue) then
            GuiDrawRectangle(type<Rectangle>( bounds.x + progress.width_ + 1, bounds.y, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), bounds.height ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_FOCUSED)))
        else
        
            ' Draw borders not yet reached by value
            GuiDrawRectangle(type<Rectangle>( bounds.x + int(progress.width_) + 1, bounds.y, bounds.width_ - int(progress.width_) - 1, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_NORMAL)))
            GuiDrawRectangle(type<Rectangle>( bounds.x + int(progress.width_) + 1, bounds.y + bounds.height - 1, bounds.width_ - int(progress.width_) - 1, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH) ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_NORMAL)))
            GuiDrawRectangle(type<Rectangle>( bounds.x + bounds.width_ - 1, bounds.y + 1, GuiGetStyle(PROGRESSBAR, BORDER_WIDTH), bounds.height - 2 ), 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BORDER_COLOR_NORMAL)))
        end if

        ' Draw slider internal progress bar (depends on state)
        GuiDrawRectangle(progress, 0, BLANK, GetColor(GuiGetStyle(PROGRESSBAR, BASE_COLOR_PRESSED)))
    end if

    ' Draw left/right text if provided
    if (textLeft <> NULL) then
    
        dim textBounds as Rectangle 
        textBounds.width_ = GetTextWidth(textLeft)
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x - textBounds.width_ - GuiGetStyle(PROGRESSBAR, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

        GuiDrawText(textLeft, textBounds, TEXT_ALIGN_RIGHT, GetColor(GuiGetStyle(PROGRESSBAR, TEXT_ + (state*3))))
    end if

    if (textRight <> NULL) then
    
        dim textBounds as Rectangle 
        textBounds.width_ = GetTextWidth(textRight)
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
        textBounds.x = bounds.x + bounds.width_ + GuiGetStyle(PROGRESSBAR, TEXT_PADDING)
        textBounds.y = bounds.y + bounds.height/2 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2

        GuiDrawText(textRight, textBounds, TEXT_ALIGN_LEFT, GetColor(GuiGetStyle(PROGRESSBAR, TEXT_ + (state*3))))
    end if
    '--------------------------------------------------------------------

    return result
end function

' Status Bar control
function GuiStatusBar(byval bounds as Rectangle, byval text as const zstring ptr) as long

    var result = 0l
    var state = guiState_

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(STATUSBAR, BORDER_WIDTH), GetColor(GuiGetStyle(STATUSBAR, BORDER + (state*3))), GetColor(GuiGetStyle(STATUSBAR, BASE_ + (state*3))))
    GuiDrawText(text, GetTextBounds(STATUSBAR, bounds), GuiGetStyle(STATUSBAR, TEXT_ALIGNMENT), GetColor(GuiGetStyle(STATUSBAR, TEXT_ + (state*3))))
    '--------------------------------------------------------------------

    return result
end function

' Dummy rectangle control, intended for placeholding
function GuiDummyRec(byval bounds as Rectangle, byval text as const zstring ptr) as long

    var result = 0l
    var state = guiState_

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        ' Check button state
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
                state = STATE_PRESSED
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, 0, BLANK, GetColor(GuiGetStyle(DEFAULT, iif((state <> STATE_DISABLED), BASE_COLOR_NORMAL , BASE_COLOR_DISABLED))))
    GuiDrawText(text, GetTextBounds(DEFAULT, bounds), TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(BUTTON, iif((state <> STATE_DISABLED), TEXT_COLOR_NORMAL , TEXT_COLOR_DISABLED))))
    '------------------------------------------------------------------

    return result
end function

' List View control
function GuiListView(byval bounds as Rectangle, byval text as const zstring ptr, byval scrollIndex as long ptr, byval active as long ptr) as long

    var result = 0l
    var itemCount = 0l
    dim as const zstring ptr ptr items = NULL

    if (text <> NULL) then
        items = GuiTextSplit(text, asc(";"), @itemCount, NULL)
    end if

    result = GuiListViewEx(bounds, items, itemCount, scrollIndex, active, NULL)

    return result
end function

' List View control with extended parameters
function GuiListViewEx(byval bounds as Rectangle, byval text as const zstring ptr ptr, byval count as long, byval scrollIndex as long ptr, byval active as long ptr, byval focus as long ptr) as long

    var result = 0l
    var state = guiState_

    var itemFocused = iif((focus = NULL), -1l , *focus)
    var itemSelected = iif((active = NULL), -1l , *active)

    ' Check if we need a scroll bar
    var useScrollBar = false
    if ((GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING))*count > bounds.height) then
        useScrollBar = true
    end if

    ' Define base item rectangle [0]
    dim as Rectangle itemBounds
    itemBounds.x = bounds.x + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING)
    itemBounds.y = bounds.y + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING) + GuiGetStyle(DEFAULT, BORDER_WIDTH)
    itemBounds.width_ = bounds.width_ - 2*GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING) - GuiGetStyle(DEFAULT, BORDER_WIDTH)
    itemBounds.height = GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT)
    if (useScrollBar) then
        itemBounds.width_ -= GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH)
    end if

    ' Get items on the list
    var visibleItems = int(bounds.height)/(GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING))
    if (visibleItems > count) then
        visibleItems = count
    end if

    var startIndex = iif((scrollIndex = NULL), 0l , *scrollIndex)
    if ((startIndex < 0) OR (startIndex > (count - visibleItems))) then
        startIndex = 0
    end if
    var endIndex = startIndex + visibleItems

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        ' Check mouse inside list view
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            state = STATE_FOCUSED

            ' Check focused and selected item
            for i as integer = 0 to visibleItems - 1
            
                if (CheckCollisionPointRec(mousePoint, itemBounds)) then
                
                    itemFocused = startIndex + i
                    if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
                    
                        if (itemSelected = (startIndex + i)) then
                            itemSelected = -1
                        else 
                            itemSelected = startIndex + i
                        end if
                    end if
                    exit for
                end if

                ' Update item rectangle y position for next item
                itemBounds.y += (GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING))
            next i

            if (useScrollBar) then
            
                var wheelMove = clng(GetMouseWheelMove())
                startIndex -= wheelMove

                if (startIndex < 0) then
                    startIndex = 0
                elseif (startIndex > (count - visibleItems)) then
                    startIndex = count - visibleItems
                end if

                endIndex = startIndex + visibleItems
                if (endIndex > count) then
                    endIndex = count
                end if
            end if
        
        else 
            itemFocused = -1
        end if

        ' Reset item rectangle y to [0]
        itemBounds.y = bounds.y + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING) + GuiGetStyle(DEFAULT, BORDER_WIDTH)
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(DEFAULT, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER + state*3)), GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)))     ' Draw background

    ' Draw visible items
    var i = 0
    while ((i < visibleItems) AND (text <> NULL))
    
        if (state = STATE_DISABLED) then
        
            if ((startIndex + i) = itemSelected) then
                GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_DISABLED)), GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_DISABLED)))
            end if

            GuiDrawText(text[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_DISABLED)))
        
        else
        
            if (((startIndex + i) = itemSelected) AND (active <> NULL)) then
            
                ' Draw item selected
                GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_PRESSED)), GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_PRESSED)))
                GuiDrawText(text[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_PRESSED)))
            
            elseif (((startIndex + i) = itemFocused)) then ' AND (focus <> NULL))  ' NOTE: We want items focused, despite not returnednot
            
                ' Draw item focused
                GuiDrawRectangle(itemBounds, GuiGetStyle(LISTVIEW, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER_COLOR_FOCUSED)), GetColor(GuiGetStyle(LISTVIEW, BASE_COLOR_FOCUSED)))
                GuiDrawText(text[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_FOCUSED)))
            
            else
            
                ' Draw item normal
                GuiDrawText(text[startIndex + i], GetTextBounds(DEFAULT, itemBounds), GuiGetStyle(LISTVIEW, TEXT_ALIGNMENT), GetColor(GuiGetStyle(LISTVIEW, TEXT_COLOR_NORMAL)))
            end if
        end if

        ' Update item rectangle y position for next item
        itemBounds.y += (GuiGetStyle(LISTVIEW, LIST_ITEMS_HEIGHT) + GuiGetStyle(LISTVIEW, LIST_ITEMS_SPACING))

        i += 1
    wend

    if (useScrollBar) then
    
        var scrollBarBounds = type<Rectangle>( _
            bounds.x + bounds.width_ - GuiGetStyle(LISTVIEW, BORDER_WIDTH) - GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH), _
            bounds.y + GuiGetStyle(LISTVIEW, BORDER_WIDTH), _
            GuiGetStyle(LISTVIEW, SCROLLBAR_WIDTH), _
            bounds.height - 2*GuiGetStyle(DEFAULT, BORDER_WIDTH) _
        )

        ' Calculate percentage of visible items and apply same percentage to scrollbar
        var percentVisible = csng((endIndex - startIndex)/count)
        var sliderSize = bounds.height*percentVisible

        var prevSliderSize = GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE)   ' Save default slider size
        var prevScrollSpeed = GuiGetStyle(SCROLLBAR_, SCROLL_SPEED) ' Save default scroll speed
        GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, clng(sliderSize))            ' Change slider size
        GuiSetStyle(SCROLLBAR_, SCROLL_SPEED, count - visibleItems) ' Change scroll speed

        startIndex = GuiScrollBar(scrollBarBounds, startIndex, 0, count - visibleItems)

        GuiSetStyle(SCROLLBAR_, SCROLL_SPEED, prevScrollSpeed) ' Reset scroll speed to default
        GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, prevSliderSize) ' Reset slider size to default
    end if
    '--------------------------------------------------------------------

    if (active <> NULL) then
        *active = itemSelected
    end if
    if (focus <> NULL) then
        *focus = itemFocused
    end if
    if (scrollIndex <> NULL) then
        *scrollIndex = startIndex
    end if

    return result
end function

' RayColor Panel control
function GuiColorPanel(byval bounds as Rectangle, byval text as const zstring ptr, byval color_ as RayColor ptr) as long

    var result = 0l
    var state = guiState_
    dim as Vector2 pickerSelector 

    var colWhite = WHITE
    var colBlack = BLACK

    var vcolor = type<Vector3>( color_->r/255.0f, color_->g/255.0f, color_->b/255.0f )
    var hsv = ConvertRGBtoHSV(vcolor)

    pickerSelector.x = bounds.x + hsv.y*bounds.width_            ' HSV: Saturation
    pickerSelector.y = bounds.y + (1.0f - hsv.z)*bounds.height  ' HSV: Value

    var hue = -1.0f
    var maxHue = type<Vector3>( iif(hue >= 0.0f , hue , hsv.x), 1.0f, 1.0f )
    var rgbHue = ConvertHSVtoRGB(maxHue)
    var maxHueCol = type<RayColor>( cubyte(255.0f*rgbHue.x), _
                      cubyte(255.0f*rgbHue.y), _
                      cubyte(255.0f*rgbHue.z), 255 )

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                pickerSelector = mousePoint

                ' Calculate color_ from picker
                var colorPick = type<Vector2>( pickerSelector.x - bounds.x, pickerSelector.y - bounds.y )

                colorPick.x /= bounds.width_     ' Get normalized value on x
                colorPick.y /= bounds.height    ' Get normalized value on y

                hsv.y = colorPick.x
                hsv.z = 1.0f - colorPick.y

                var rgb_ = ConvertHSVtoRGB(hsv)

                ' NOTE: Vector3ToColor() only available on raylib 1.8.1
                *color_ = type<RayColor>( cubyte(255.0f*rgb_.x), _
                                 cubyte(255.0f*rgb_.y), _
                                 cubyte(255.0f*rgb_.z), _
                                 cubyte(255.0f*color_->a/255.0f) )

            
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state <> STATE_DISABLED) then
    
        DrawRectangleGradientEx(bounds, Fade(colWhite, guiAlpha), Fade(colWhite, guiAlpha), Fade(maxHueCol, guiAlpha), Fade(maxHueCol, guiAlpha))
        DrawRectangleGradientEx(bounds, Fade(colBlack, 0), Fade(colBlack, guiAlpha), Fade(colBlack, guiAlpha), Fade(colBlack, 0))

        ' Draw color_ picker: selector
        var selector = type<Rectangle>( pickerSelector.x - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, pickerSelector.y - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE), GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE) )
        GuiDrawRectangle(selector, 0, BLANK, colWhite)
    
    else
    
        DrawRectangleGradientEx(bounds, Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), 0.6f), guiAlpha))
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(COLORPICKER, BORDER_WIDTH), GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), BLANK)
    '--------------------------------------------------------------------

    return result
end function

' RayColor Bar Alpha control
' NOTE: Returns alpha value normalized [0..1]
function GuiColorBarAlpha(byval bounds as Rectangle, byval text as const zstring ptr, byval alpha as single ptr) as long

    #ifndef RAYGUI_COLORBARALPHA_CHECKED_SIZE
        #define RAYGUI_COLORBARALPHA_CHECKED_SIZE   10
    #endif

    var result = 0l
    var state = guiState_
    var selector = type<Rectangle>( bounds.x + (*alpha)*bounds.width_ - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT)/2, bounds.y - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT), bounds.height + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)*2 )

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        if (guiSliderDragging) then ' Keep dragging outside of bounds
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                if (CHECK_BOUNDS_ID(bounds, guiSliderActive)) then
                
                    state = STATE_PRESSED

                    *alpha = (mousePoint.x - bounds.x)/bounds.width_
                    if (*alpha <= 0.0f) then
                        *alpha = 0.0f
                    end if
                    if (*alpha >= 1.0f) then
                        *alpha = 1.0f
                    end if
                end if
            
            else
            
                guiSliderDragging = false
                guiSliderActive = type<Rectangle>( 0, 0, 0, 0 )
            end if
        
        elseif (CheckCollisionPointRec(mousePoint, bounds) OR CheckCollisionPointRec(mousePoint, selector)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                guiSliderDragging = true
                guiSliderActive = bounds ' Store bounds as an identifier when dragging starts

                *alpha = (mousePoint.x - bounds.x)/bounds.width_
                if (*alpha <= 0.0f) then
                    *alpha = 0.0f
                end if
                if (*alpha >= 1.0f) then
                    *alpha = 1.0f
                end if
            
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------

    ' Draw alpha bar: checked background
    if (state <> STATE_DISABLED) then
    
        var checksX = clng(bounds.width_)/RAYGUI_COLORBARALPHA_CHECKED_SIZE
        var checksY = clng(bounds.height)/RAYGUI_COLORBARALPHA_CHECKED_SIZE

        for x as integer = 0 to checksX - 1
            for y as integer = 0 to checksY - 1
                var check = type<Rectangle>( bounds.x + x*RAYGUI_COLORBARALPHA_CHECKED_SIZE, bounds.y + y*RAYGUI_COLORBARALPHA_CHECKED_SIZE, RAYGUI_COLORBARALPHA_CHECKED_SIZE, RAYGUI_COLORBARALPHA_CHECKED_SIZE )
                GuiDrawRectangle(_
                    check, _
                    0, _
                    BLANK, _
                    iif( _
                        (x + y) mod 2, _
                        Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), 0.4f), _
                        Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.4f) _
                    ) _
                )
            next Y
        next X

        DrawRectangleGradientEx(bounds, type<RayColor>( 255, 255, 255, 0 ), type<RayColor>( 255, 255, 255, 0 ), Fade(type<RayColor>( 0, 0, 0, 255 ), guiAlpha), Fade(type<RayColor>( 0, 0, 0, 255 ), guiAlpha))
    
    else 
        DrawRectangleGradientEx(bounds, Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha))
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(COLORPICKER, BORDER_WIDTH), GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), BLANK)

    ' Draw alpha bar: selector
    GuiDrawRectangle(selector, 0, BLANK, GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)))
    '--------------------------------------------------------------------

    return result
end function

' RayColor Bar Hue control
' Returns hue value normalized [0..1]
' NOTE: Other similar bars (for reference):
'      RayColor GuiColorBarSat() [WHITE->color_]
'      RayColor GuiColorBarValue() [BLACK->color_], HSV/HSL
'      float GuiColorBarLuminance() [BLACK->WHITE]
function GuiColorBarHue(byval bounds as Rectangle, byval text as const zstring ptr, byval hue as single ptr) as long

    var result = 0l
    var state = guiState_
    var selector = type<Rectangle>( bounds.x - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW), bounds.y + (*hue)/360.0f*bounds.height - GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT)/2, bounds.width_ + GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW)*2, GuiGetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT) )

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        if (guiSliderDragging) then ' Keep dragging outside of bounds
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                if (CHECK_BOUNDS_ID(bounds, guiSliderActive)) then
                
                    state = STATE_PRESSED

                    *hue = (mousePoint.y - bounds.y)*360/bounds.height
                    if (*hue <= 0.0f) then
                        *hue = 0.0f
                    end if
                    if (*hue >= 359.0f) then
                        *hue = 359.0f
                    end if
                end if
            
            else
            
                guiSliderDragging = false
                guiSliderActive = type<Rectangle>( 0, 0, 0, 0 )
            end if
        
        elseif (CheckCollisionPointRec(mousePoint, bounds) OR CheckCollisionPointRec(mousePoint, selector)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                guiSliderDragging = true
                guiSliderActive = bounds ' Store bounds as an identifier when dragging starts

                *hue = (mousePoint.y - bounds.y)*360/bounds.height
                if (*hue <= 0.0f) then
                    *hue = 0.0f
                end if
                if (*hue >= 359.0f) then
                    *hue = 359.0f
                end if

            
            else 
                state = STATE_FOCUSED
            end if

            
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state <> STATE_DISABLED) then
    
        ' Draw hue bar:color_ bars
        ' TODO: Use directly DrawRectangleGradientEx(bounds, color1, color2, color2, color1)
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y), clng(bounds.width_), clng(ceilf(bounds.height/6)), Fade(type<RayColor>(255, 0, 0, 255), guiAlpha), Fade(type<RayColor>(255, 255, 0, 255), guiAlpha))
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y + bounds.height/6), clng(bounds.width_), clng(ceilf(bounds.height/6)), Fade(type<RayColor>(255, 255, 0, 255), guiAlpha), Fade(type<RayColor>(0, 255, 0, 255), guiAlpha))
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y + 2*(bounds.height/6)), clng(bounds.width_), clng(ceilf(bounds.height/6)), Fade(type<RayColor>(0, 255, 0, 255), guiAlpha), Fade(type<RayColor>(0, 255, 255, 255), guiAlpha))
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y + 3*(bounds.height/6)), clng(bounds.width_), clng(ceilf(bounds.height/6)), Fade(type<RayColor>(0, 255, 255, 255), guiAlpha), Fade(type<RayColor>(0, 0, 255, 255), guiAlpha))
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y + 4*(bounds.height/6)), clng(bounds.width_), clng(ceilf(bounds.height/6)), Fade(type<RayColor>(0, 0, 255, 255), guiAlpha), Fade(type<RayColor>(255, 0, 255, 255), guiAlpha))
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y + 5*(bounds.height/6)), clng(bounds.width_), clng(bounds.height/6), Fade(type<RayColor>(255, 0, 255, 255), guiAlpha), Fade(type<RayColor>(255, 0, 0, 255), guiAlpha))
    
    else 
        DrawRectangleGradientV(clng(bounds.x), clng(bounds.y), clng(bounds.width_), clng(bounds.height), Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), guiAlpha), Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), guiAlpha))
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(COLORPICKER, BORDER_WIDTH), GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), BLANK)

    ' Draw hue bar: selector
    GuiDrawRectangle(selector, 0, BLANK, GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)))
    '--------------------------------------------------------------------

    return result
end function

' RayColor Picker control
' NOTE: It's divided in multiple controls:
'      RayColor GuiColorPanel(byval bounds as Rectangle, byval color_ as RayColor)
'      float GuiColorBarAlpha(byval bounds as Rectangle, byval alpha as single)
'      float GuiColorBarHue(byval bounds as Rectangle, float value)
' NOTE: bounds define GuiColorPanel() size
function GuiColorPicker(byval bounds as Rectangle, byval text as const zstring ptr, byval color_ as RayColor ptr) as long

    var result = 0l

    var temp = type<RayColor>( 200, 0, 0, 255 )
    if (color_ = NULL) then
        color_ = @temp
    end if

    GuiColorPanel(bounds, NULL, color_)

    var boundsHue = type<Rectangle>( bounds.x + bounds.width_ + GuiGetStyle(COLORPICKER, HUEBAR_PADDING), bounds.y, GuiGetStyle(COLORPICKER, HUEBAR_WIDTH), bounds.height )

    var hsv = ConvertRGBtoHSV(type<Vector3>( (*color_).r/255.0f, (*color_).g/255.0f, (*color_).b/255.0f ))

    GuiColorBarHue(boundsHue, NULL, @hsv.x)

    var rgb_ = ConvertHSVtoRGB(hsv)

    *color_ = type<RayColor>( cubyte(roundf(rgb_.x*255.0f)), cubyte(roundf(rgb_.y*255.0f)), cubyte(roundf(rgb_.z*255.0f)), (*color_).a )

    return result
end function

' RayColor Picker control that avoids conversion to RGB and back to HSV on each call, thus avoiding jittering.
' The user can call ConvertHSVtoRGB() to convert *colorHsv value to RGB.
' NOTE: It's divided in multiple controls:
'      int GuiColorPanelHSV(byval bounds as Rectangle, byval text as const zstring ptr, byval colorHsv as Vector3 ptr)
'      int GuiColorBarAlpha(byval bounds as Rectangle, byval text as const zstring ptr, byval alpha as single ptr)
'      float GuiColorBarHue(byval bounds as Rectangle, float value)
' NOTE: bounds define GuiColorPanelHSV() size
function GuiColorPickerHSV(byval bounds as Rectangle, byval text as const zstring ptr, byval colorHsv as Vector3 ptr) as long

    var result = 0l

    dim as Vector3 tempHsv

    if (colorHsv = NULL) then
    
        var tempColor = type<Vector3>( 200.0f/255.0f, 0.0f, 0.0f )
        tempHsv = ConvertRGBtoHSV(tempColor)
        colorHsv = @tempHsv
    end if

    GuiColorPanelHSV(bounds, NULL, colorHsv)

    var boundsHue = type<Rectangle>( bounds.x + bounds.width_ + GuiGetStyle(COLORPICKER, HUEBAR_PADDING), bounds.y, GuiGetStyle(COLORPICKER, HUEBAR_WIDTH), bounds.height )

    GuiColorBarHue(boundsHue, NULL, @(colorHsv->x))

    return result
end function

' RayColor Panel control, returns HSV color_ value in *colorHsv.
' Used by GuiColorPickerHSV()
function GuiColorPanelHSV(byval bounds as Rectangle, byval text as const zstring ptr, byval colorHsv as Vector3 ptr) as long

    var result = 0l
    var state = guiState_
    dim as Vector2 pickerSelector

    var colWhite = WHITE
    var colBlack = BLACK

    pickerSelector.x = bounds.x + colorHsv->y*bounds.width_            ' HSV: Saturation
    pickerSelector.y = bounds.y + (1.0f - colorHsv->z)*bounds.height  ' HSV: Value

    var hue = -1.0f
    var maxHue = type<Vector3>( iif(hue >= 0.0f , hue , colorHsv->x), 1.0f, 1.0f )
    var rgbHue = ConvertHSVtoRGB(maxHue)
    var maxHueCol = type<RayColor>( cubyte(255.0f*rgbHue.x), _
                      cubyte(255.0f*rgbHue.y), _
                      cubyte(255.0f*rgbHue.z), 255 )

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        var mousePoint = GetMousePosition()

        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON)) then
            
                state = STATE_PRESSED
                pickerSelector = mousePoint

                ' Calculate color_ from picker
                var colorPick = type<Vector2>( pickerSelector.x - bounds.x, pickerSelector.y - bounds.y )

                colorPick.x /= bounds.width_     ' Get normalized value on x
                colorPick.y /= bounds.height    ' Get normalized value on y

                colorHsv->y = colorPick.x
                colorHsv->z = 1.0f - colorPick.y
            
            else 
                state = STATE_FOCUSED
            end if
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state <> STATE_DISABLED) then
    
        DrawRectangleGradientEx(bounds, Fade(colWhite, guiAlpha), Fade(colWhite, guiAlpha), Fade(maxHueCol, guiAlpha), Fade(maxHueCol, guiAlpha))
        DrawRectangleGradientEx(bounds, Fade(colBlack, 0), Fade(colBlack, guiAlpha), Fade(colBlack, guiAlpha), Fade(colBlack, 0))

        ' Draw color_ picker: selector
        var selector = type<Rectangle>( pickerSelector.x - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, pickerSelector.y - GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE)/2, GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE), GuiGetStyle(COLORPICKER, COLOR_SELECTOR_SIZE) )
        GuiDrawRectangle(selector, 0, BLANK, colWhite)
    
    else
    
        DrawRectangleGradientEx(bounds, Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BASE_COLOR_DISABLED)), 0.1f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(colBlack, 0.6f), guiAlpha), Fade(Fade(GetColor(GuiGetStyle(COLORPICKER, BORDER_COLOR_DISABLED)), 0.6f), guiAlpha))
    end if

    GuiDrawRectangle(bounds, GuiGetStyle(COLORPICKER, BORDER_WIDTH), GetColor(GuiGetStyle(COLORPICKER, BORDER + state*3)), BLANK)
    '--------------------------------------------------------------------

    return result
end function

' Message Box control
function GuiMessageBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr) as long

    var result = -1l    ' Returns clicked button from buttons list, 0 refers to closed window button

    var buttonCount = 0l
    var buttonsText = GuiTextSplit(buttons, asc(";"), @buttonCount, NULL)
    dim as Rectangle buttonBounds 
    buttonBounds.x = bounds.x + RAYGUI_MESSAGEBOX_BUTTON_PADDING
    buttonBounds.y = bounds.y + bounds.height - RAYGUI_MESSAGEBOX_BUTTON_HEIGHT - RAYGUI_MESSAGEBOX_BUTTON_PADDING
    buttonBounds.width_ = (bounds.width_ - RAYGUI_MESSAGEBOX_BUTTON_PADDING*(buttonCount + 1))/buttonCount
    buttonBounds.height = RAYGUI_MESSAGEBOX_BUTTON_HEIGHT

    var textWidth = GetTextWidth(message) + 2

    dim textBounds as Rectangle 
    textBounds.x = bounds.x + bounds.width_/2 - textWidth/2
    textBounds.y = bounds.y + RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT + RAYGUI_MESSAGEBOX_BUTTON_PADDING
    textBounds.width_ = textWidth
    textBounds.height = bounds.height - RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - 3*RAYGUI_MESSAGEBOX_BUTTON_PADDING - RAYGUI_MESSAGEBOX_BUTTON_HEIGHT

    ' Draw control
    '--------------------------------------------------------------------
    if (GuiWindowBox(bounds, title)) then
        result = 0
    end if

    var prevTextAlignment = GuiGetStyle(LABEL, TEXT_ALIGNMENT)
    GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    GuiLabel(textBounds, message)
    GuiSetStyle(LABEL, TEXT_ALIGNMENT, prevTextAlignment)

    prevTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

    for i as integer = 0 to buttonCount - 1
    
        if (GuiButton(buttonBounds, buttonsText[i])) then
            result = i + 1
        end if
        buttonBounds.x += (buttonBounds.width_ + RAYGUI_MESSAGEBOX_BUTTON_PADDING)
    next I

    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, prevTextAlignment)
    '--------------------------------------------------------------------

    return result
end function

' Text Input Box control, ask for text
function GuiTextInputBox(byval bounds as Rectangle, byval title as const zstring ptr, byval message as const zstring ptr, byval buttons as const zstring ptr, byval text as zstring ptr, byval textMaxSize as long, byval secretViewActive as boolean ptr) as long

    #ifndef RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT
        #define RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT      24
    #endif
    #ifndef RAYGUI_TEXTINPUTBOX_BUTTON_PADDING
        #define RAYGUI_TEXTINPUTBOX_BUTTON_PADDING     12
    #endif
    #ifndef RAYGUI_TEXTINPUTBOX_HEIGHT
        #define RAYGUI_TEXTINPUTBOX_HEIGHT             26
    #endif

    ' Used to enable text edit mode
    ' WARNING: No more than one GuiTextInputBox() should be open at the same time
    static textEditMode as boolean = false

    var result = -1l

    var buttonCount = 0l
    var buttonsText = GuiTextSplit(buttons, asc(";"), @buttonCount, NULL)
    dim as Rectangle buttonBounds 
    buttonBounds.x = bounds.x + RAYGUI_TEXTINPUTBOX_BUTTON_PADDING
    buttonBounds.y = bounds.y + bounds.height - RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT - RAYGUI_TEXTINPUTBOX_BUTTON_PADDING
    buttonBounds.width_ = (bounds.width_ - RAYGUI_TEXTINPUTBOX_BUTTON_PADDING*(buttonCount + 1))/buttonCount
    buttonBounds.height = RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT

    var messageInputHeight = clng(bounds.height) - RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - GuiGetStyle(STATUSBAR, BORDER_WIDTH) - RAYGUI_TEXTINPUTBOX_BUTTON_HEIGHT - 2*RAYGUI_TEXTINPUTBOX_BUTTON_PADDING

    dim textBounds as Rectangle 
    if (message <> NULL) then
    
        var textSize = GetTextWidth(message) + 2

        textBounds.x = bounds.x + bounds.width_/2 - textSize/2
        textBounds.y = bounds.y + RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT + messageInputHeight/4 - GuiGetStyle(DEFAULT, TEXT_SIZE)/2
        textBounds.width_ = textSize
        textBounds.height = GuiGetStyle(DEFAULT, TEXT_SIZE)
    end if

    dim as Rectangle textBoxBounds 
    textBoxBounds.x = bounds.x + RAYGUI_TEXTINPUTBOX_BUTTON_PADDING
    textBoxBounds.y = bounds.y + RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT - RAYGUI_TEXTINPUTBOX_HEIGHT/2
    if (message = NULL) then
        textBoxBounds.y = bounds.y + 24 + RAYGUI_TEXTINPUTBOX_BUTTON_PADDING
    else 
        textBoxBounds.y += (messageInputHeight/2 + messageInputHeight/4)
    end if
    textBoxBounds.width_ = bounds.width_ - RAYGUI_TEXTINPUTBOX_BUTTON_PADDING*2
    textBoxBounds.height = RAYGUI_TEXTINPUTBOX_HEIGHT

    ' Draw control
    '--------------------------------------------------------------------
    if (GuiWindowBox(bounds, title)) then
        result = 0
    end if

    ' Draw message if available
    if (message <> NULL) then
    
        var prevTextAlignment = GuiGetStyle(LABEL, TEXT_ALIGNMENT)
        GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
        GuiLabel(textBounds, message)
        GuiSetStyle(LABEL, TEXT_ALIGNMENT, prevTextAlignment)
    end if

    if (secretViewActive <> NULL) then
    
        static stars as zstring ptr = strptr("****************")
        if ((GuiTextBox(type<Rectangle>( textBoxBounds.x, textBoxBounds.y, textBoxBounds.width_ - 4 - RAYGUI_TEXTINPUTBOX_HEIGHT, textBoxBounds.height ), _
            iif((((*(secretViewActive)) = true) OR cbool(textEditMode)), text , stars), textMaxSize, textEditMode))) then
            
            textEditMode = not textEditMode
        end if

        GuiToggle(type<Rectangle>( textBoxBounds.x + textBoxBounds.width_ - RAYGUI_TEXTINPUTBOX_HEIGHT, textBoxBounds.y, RAYGUI_TEXTINPUTBOX_HEIGHT, RAYGUI_TEXTINPUTBOX_HEIGHT ), iif((*(secretViewActive) = true), "#44#" , "#45#"), secretViewActive)
    
    else
    
        if (GuiTextBox(textBoxBounds, text, textMaxSize, textEditMode)) then
            textEditMode = not textEditMode
        end if
    end if

    var prevBtnTextAlignment = GuiGetStyle(BUTTON, TEXT_ALIGNMENT)
    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)

    for i as integer = 0 to buttonCount - 1
    
        if (GuiButton(buttonBounds, buttonsText[i])) then
            result = i + 1
        end if
        buttonBounds.x += (buttonBounds.width_ + RAYGUI_MESSAGEBOX_BUTTON_PADDING)
    next i

    if (result >= 0) then
        textEditMode = false
    end if

    GuiSetStyle(BUTTON, TEXT_ALIGNMENT, prevBtnTextAlignment)
    '--------------------------------------------------------------------

    return result      ' Result is the pressed button index
end function

' Grid control
' NOTE: Returns grid mouse-hover selected cell
' About drawing lines at subpixel spacing, simple put, not easy solution:
' https:'stackoverflow.com/questions/4435450/2d-opengl-drawing-lines-that-dont-exactly-fit-pixel-raster
function GuiGrid(byval bounds as Rectangle, byval text as const zstring ptr, byval spacing as single, byval subdivs as long, byval mouseCell as Vector2 ptr) as long

    ' Grid lines alpha amount
    #ifndef RAYGUI_GRID_ALPHA
        #define RAYGUI_GRID_ALPHA    0.15f
    #endif

    var result = 0l
    var state = guiState_

    var mousePoint = GetMousePosition()
    dim as Vector2 currentMouseCell

    var spaceWidth = spacing/subdivs
    var linesV = clng((bounds.width_/spaceWidth) + 1)
    var linesH = clng((bounds.height/spaceWidth) + 1)

    ' Update control
    '--------------------------------------------------------------------
    if (cbool(state <> STATE_DISABLED) AND (not guiLocked) AND (not guiSliderDragging)) then
    
        if (CheckCollisionPointRec(mousePoint, bounds)) then
        
            ' NOTE: Cell values must be the upper left of the cell the mouse is in
            currentMouseCell.x = floorf((mousePoint.x - bounds.x)/spacing)
            currentMouseCell.y = floorf((mousePoint.y - bounds.y)/spacing)
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    if (state = STATE_NORMAL) then
        
        if (subdivs > 0) then
        
            ' Draw vertical grid lines
            for i as integer = 0 to linesV - 1
                var lineV = type<Rectangle>( bounds.x + spacing*i/subdivs, bounds.y, 1, bounds.height )
                GuiDrawRectangle(lineV, 0, BLANK, iif(((i mod subdivs) = 0), GuiFade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), RAYGUI_GRID_ALPHA*4) , GuiFade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), RAYGUI_GRID_ALPHA)))
            next i

            ' Draw horizontal grid lines
            for i as integer = 0 to linesH - 1
                var lineH = type<Rectangle>( bounds.x, bounds.y + spacing*i/subdivs, bounds.width_, 1 )
                GuiDrawRectangle(lineH, 0, BLANK, iif(((i mod subdivs) = 0), GuiFade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), RAYGUI_GRID_ALPHA*4) , GuiFade(GetColor(GuiGetStyle(DEFAULT, LINE_COLOR)), RAYGUI_GRID_ALPHA)))
            next i
        end if
    end if

    if (mouseCell <> NULL) then
        *mouseCell = currentMouseCell
    end if
    return result
end function

'----------------------------------------------------------------------------------
' Tooltip management functions
' NOTE: Tooltips requires some global variables: tooltipPtr
'----------------------------------------------------------------------------------
' Enable gui tooltips (global state)
sub GuiEnableTooltip() 
    guiTooltip_ = true 
end sub

' Disable gui tooltips (global state)
sub GuiDisableTooltip() 
    guiTooltip_ = false 
end sub

' Set tooltip string
sub GuiSetTooltip(byval tooltip as const zstring ptr) 
    guiTooltipPtr = tooltip 
end sub


'----------------------------------------------------------------------------------
' Styles loading functions
'----------------------------------------------------------------------------------

' Load raygui style file (.rgs)
' NOTE: By default a binary file is expected, that file could contain a custom font_,
' in that case, custom font_ image atlas is GRAY+ALPHA and pixel data can be compressed (DEFLATE)
sub GuiLoadStyle(byval filename as const zstring ptr)

    

    var tryBinary = false

    ' Try reading the files as text file first
    var rgsFile = fopen(fileName, "rt")

    if (rgsFile <> NULL) then
    
        dim buffer as zstring * MAX_LINE_BUFFER_SIZE
        fgets(@buffer, MAX_LINE_BUFFER_SIZE, rgsFile)

        if (buffer[0] = asc("#")) then
        
            var controlId = 0l
            var propertyId = 0l
            var propertyValue = 0ul

            while (not feof(rgsFile))
                select case as const buffer[0]
                
                    case 112 
                    'ASCII value of p
                    
                        ' Style property: p <control_id> <property_id> <property_value> <property_name>

                        sscanf(buffer, "p %d %d 0x%x", @controlId, @propertyId, @propertyValue)
                        GuiSetStyle(controlId, propertyId, propertyValue)

                    
                    case 102 
                    'ASCII value of f
                    
                        ' Style font_: f <gen_font_size> <charmap_file> <font_file>

                        var fontSize = 0l
                        dim charmapFileName as zstring * 256
                        dim fontFileName as zstring * 256
                        sscanf(buffer, "f %d %s %[^\r\n]s", @fontSize, @charmapFileName, @fontFileName)

                        dim font_ as Font
                        dim as long ptr codepoints = NULL
                        var codepointCount = 0l

                        if (charmapFileName[0] <> asc("0")) then
                        
                            ' Load text data from file
                            ' NOTE: Expected an UTF-8 array of codepoints, no separation
                            var textData = LoadFileText(TextFormat("%s/%s", GetDirectoryPath(fileName), charmapFileName))
                            codepoints = LoadCodepoints(textData, @codepointCount)
                            UnloadFileText(textData)
                        end if

                        if (fontFileName[0] <> 0) then
                        
                            ' In case a font_ is already loaded and it is not default internal font_, unload it
                            if (font_.texture.id <> GetFontDefault().texture.id) then
                                UnloadTexture(font_.texture)
                            end if

                            if (codepointCount > 0) then
                                font_ = LoadFontEx(TextFormat("%s/%s", GetDirectoryPath(fileName), @fontFileName), fontSize, codepoints, codepointCount)
                            else 
                                font_ = LoadFontEx(TextFormat("%s/%s", GetDirectoryPath(fileName), @fontFileName), fontSize, NULL, 0)   ' Default to 95 standard codepoints
                            end if
                        end if

                        ' If font_ texture not properly loaded, revert to default font_ and size/spacing
                        if (font_.texture.id = 0) then
                        
                            font_ = GetFontDefault()
                            GuiSetStyle(DEFAULT, TEXT_SIZE, 10)
                            GuiSetStyle(DEFAULT, TEXT_SPACING, 1)
                        end if

                        UnloadCodepoints(codepoints)

                        if ((font_.texture.id > 0) AND (font_.glyphCount > 0)) then
                            GuiSetFont(font_)
                        end if

                    
                end select

                fgets(@buffer, MAX_LINE_BUFFER_SIZE, rgsFile)
            wend
        
        else 
            tryBinary = true
        end if

        fclose(rgsFile)
    end if

    if (tryBinary) then
    
        rgsFile = fopen(fileName, "rb")

        if (rgsFile <> NULL) then
        
            fseek(rgsFile, 0, SEEK_END)
            var fileDataSize = ftell(rgsFile)
            fseek(rgsFile, 0, SEEK_SET)

            if (fileDataSize > 0) then
            
                var fileData = malloc(fileDataSize*sizeof(ubyte))
                fread(fileData, sizeof(ubyte), fileDataSize, rgsFile)

                GuiLoadStyleFromMemory(fileData, fileDataSize)

                free(fileData)
            end if

            fclose(rgsFile)
        end if
    end if
end sub

' Load style default over global style
sub GuiLoadStyleDefault()
    ' We set this variable first to avoid cyclic function calls
    ' when calling GuiSetStyle() and GuiGetStyle()
    guiStyleLoaded = true

    ' Initialize default LIGHT style property values
    ' WARNING: Default value are applied to all controls on set but
    ' they can be overwritten later on for every custom control
    GuiSetStyle(DEFAULT, BORDER_COLOR_NORMAL, &h838383ff)
    GuiSetStyle(DEFAULT, BASE_COLOR_NORMAL, &hc9c9c9ff)
    GuiSetStyle(DEFAULT, TEXT_COLOR_NORMAL, &h686868ff)
    GuiSetStyle(DEFAULT, BORDER_COLOR_FOCUSED, &h5bb2d9ff)
    GuiSetStyle(DEFAULT, BASE_COLOR_FOCUSED, &hc9effeff)
    GuiSetStyle(DEFAULT, TEXT_COLOR_FOCUSED, &h6c9bbcff)
    GuiSetStyle(DEFAULT, BORDER_COLOR_PRESSED, &h0492c7ff)
    GuiSetStyle(DEFAULT, BASE_COLOR_PRESSED, &h97e8ffff)
    GuiSetStyle(DEFAULT, TEXT_COLOR_PRESSED, &h368bafff)
    GuiSetStyle(DEFAULT, BORDER_COLOR_DISABLED, &hb5c1c2ff)
    GuiSetStyle(DEFAULT, BASE_COLOR_DISABLED, &he6e9e9ff)
    GuiSetStyle(DEFAULT, TEXT_COLOR_DISABLED, &haeb7b8ff)
    GuiSetStyle(DEFAULT, BORDER_WIDTH, 1)
    GuiSetStyle(DEFAULT, TEXT_PADDING, 0)
    GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    
    ' Initialize default extended property values
    ' NOTE: By default, extended property values are initialized to 0
    GuiSetStyle(DEFAULT, TEXT_SIZE, 10)                ' DEFAULT, shared by all controls
    GuiSetStyle(DEFAULT, TEXT_SPACING, 1)              ' DEFAULT, shared by all controls
    GuiSetStyle(DEFAULT, LINE_COLOR, &h90abb5ff)       ' DEFAULT specific property
    GuiSetStyle(DEFAULT, BACKGROUND_COLOR, &hf5f5f5ff) ' DEFAULT specific property
    GuiSetStyle(DEFAULT, TEXT_LINE_SPACING, 15)        ' DEFAULT, 15 pixels between lines
    GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE)   ' DEFAULT, text aligned vertically to middle of text-bounds

    ' Initialize control-specific property values
    ' NOTE: Those properties are in default list but require specific values by control type
    GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    GuiSetStyle(BUTTON, BORDER_WIDTH, 2)
    GuiSetStyle(SLIDER_, TEXT_PADDING, 4)
    GuiSetStyle(PROGRESSBAR, TEXT_PADDING, 4)
    GuiSetStyle(CHECKBOX, TEXT_PADDING, 4)
    GuiSetStyle(CHECKBOX, TEXT_ALIGNMENT, TEXT_ALIGN_RIGHT)
    GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 0)
    GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
    GuiSetStyle(TEXTBOX, TEXT_PADDING, 4)
    GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    GuiSetStyle(VALUEBOX, TEXT_PADDING, 0)
    GuiSetStyle(VALUEBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    GuiSetStyle(SPINNER_, TEXT_PADDING, 0)
    GuiSetStyle(SPINNER_, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)
    GuiSetStyle(STATUSBAR, TEXT_PADDING, 8)
    GuiSetStyle(STATUSBAR, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT)

    ' Initialize extended property values
    ' NOTE: By default, extended property values are initialized to 0
    GuiSetStyle(TOGGLE, GROUP_PADDING, 2)
    GuiSetStyle(SLIDER_, SLIDER_WIDTH, 16)
    GuiSetStyle(SLIDER_, SLIDER_PADDING, 1)
    GuiSetStyle(PROGRESSBAR, PROGRESS_PADDING, 1)
    GuiSetStyle(CHECKBOX, CHECK_PADDING, 1)
    GuiSetStyle(COMBOBOX, COMBO_BUTTON_WIDTH, 32)
    GuiSetStyle(COMBOBOX, COMBO_BUTTON_SPACING, 2)
    GuiSetStyle(DROPDOWNBOX, ARROW_PADDING, 16)
    GuiSetStyle(DROPDOWNBOX, DROPDOWN_ITEMS_SPACING, 2)
    GuiSetStyle(SPINNER_, SPIN_BUTTON_WIDTH, 24)
    GuiSetStyle(SPINNER_, SPIN_BUTTON_SPACING, 2)
    GuiSetStyle(SCROLLBAR_, BORDER_WIDTH, 0)
    GuiSetStyle(SCROLLBAR_, ARROWS_VISIBLE, 0)
    GuiSetStyle(SCROLLBAR_, ARROWS_SIZE, 6)
    GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_PADDING, 0)
    GuiSetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE, 16)
    GuiSetStyle(SCROLLBAR_, SCROLL_PADDING, 0)
    GuiSetStyle(SCROLLBAR_, SCROLL_SPEED, 12)
    GuiSetStyle(LISTVIEW, LIST_ITEMS_HEIGHT, 28)
    GuiSetStyle(LISTVIEW, LIST_ITEMS_SPACING, 2)
    GuiSetStyle(LISTVIEW, SCROLLBAR_WIDTH, 12)
    GuiSetStyle(LISTVIEW, SCROLLBAR_SIDE, SCROLLBAR_RIGHT_SIDE)
    GuiSetStyle(COLORPICKER, COLOR_SELECTOR_SIZE, 8)
    GuiSetStyle(COLORPICKER, HUEBAR_WIDTH, 16)
    GuiSetStyle(COLORPICKER, HUEBAR_PADDING, 8)
    GuiSetStyle(COLORPICKER, HUEBAR_SELECTOR_HEIGHT, 8)
    GuiSetStyle(COLORPICKER, HUEBAR_SELECTOR_OVERFLOW, 2)

    if (guiFont.texture.id <> GetFontDefault().texture.id) then
    
        ' Unload previous font_ texture
        UnloadTexture(guiFont.texture)
        free(guiFont.recs)
        free(guiFont.glyphs)
        guiFont.recs = NULL
        guiFont.glyphs = NULL

        ' Setup default raylib font_
        guiFont = GetFontDefault()

        ' NOTE: Default raylib font_ character 95 is a white square
        var whiteChar = guiFont.recs[95]

        ' NOTE: We set up a 1px padding on char rectangle to avoid pixel bleeding on MSAA filtering
        SetShapesTexture(guiFont.texture, type<Rectangle>( whiteChar.x + 1, whiteChar.y + 1, whiteChar.width_ - 2, whiteChar.height - 2 ))
    end if
end sub

' Get text with icon id prepended
' NOTE: Useful to add icons by name id (enum) instead of
' a number that can change between ricon versions
function GuiIconText(byval iconId as long, byval text as const zstring ptr) as const zstring ptr

#ifdef RAYGUI_NO_ICONS
    return NULL
#else
    static buffer as zstring * 1024
    static iconBuffer as zstring * 6

    if (text <> NULL) then
    
        memset(@buffer, 0, 1024)
        sprintf(@buffer, "#%03i#", iconId)

        for i as integer = 5 to 1023
            buffer[i] = text[i - 5]
            if (text[i - 5] = 0) then
                exit for
            end if
        next i

        return @buffer
    
    else
    
        sprintf(iconBuffer, "#%03i#", iconId & &h1ff)

        return @iconBuffer
    end if
#endif
end function

#ifndef RAYGUI_NO_ICONS
' Get full icons data pointer
function GuiGetIcons() as ulong ptr 
    return guiIconsPtr 
end function

' Load raygui icons file (.rgi)
' NOTE: In case nameIds are required, they can be requested with loadIconsName,
' they are returned as a guiIconsName[iconCount][RAYGUI_ICON_MAX_NAME_LENGTH],
' WARNING: guiIconsName[]][] memory should be manually freednot
function GuiLoadIcons(byval fileName as const zstring ptr, byval loadIconsName as boolean) as zstring ptr ptr

    ' Style File Structure (.rgi)
    ' ------------------------------------------------------
    ' Offset  | Size    | Type       | Description
    ' ------------------------------------------------------
    ' 0       | 4       | char       | Signature: "rGI "
    ' 4       | 2       | short      | Version: 100
    ' 6       | 2       | short      | reserved

    ' 8       | 2       | short      | Num icons (N)
    ' 10      | 2       | short      | Icons size (Options: 16, 32, 64) (S)

    ' Icons name id (32 bytes per name id)
    ' foreach (icon)
    ' {
    '   12+32*i  | 32   | char       | Icon NameId
    ' }

    ' Icons data: One bit per pixel, stored as unsigned int array (depends on icon size)
    ' S*S pixels/32bit per unsigned int = K unsigned int per icon
    ' foreach (icon)
    ' {
    '   ...   | K       | unsigned int | Icon Data
    ' }

    var rgiFile = fopen(fileName, "rb")

    dim as zstring ptr ptr guiIconsName = NULL

    if (rgiFile <> NULL) then
    
        dim as zstring * 5 signature
        dim as short version = 0
        dim as short reserved = 0
        dim as short iconCount = 0
        dim as short iconSize = 0

        fread(@signature, 1, 4, rgiFile)
        fread(@version, sizeof(short), 1, rgiFile)
        fread(@reserved, sizeof(short), 1, rgiFile)
        fread(@iconCount, sizeof(short), 1, rgiFile)
        fread(@iconSize, sizeof(short), 1, rgiFile)

        if ((signature[0] = asc("r")) AND _
            (signature[1] = asc("G")) AND _
            (signature[2] = asc("I")) AND _
            (signature[3] = asc(" "))) then
        
            if (loadIconsName) then
            
                guiIconsName = malloc(iconCount*sizeof(zstring ptr ptr))
                for i as integer = 0 to iconCount - 1
                
                    guiIconsName[i] = malloc(RAYGUI_ICON_MAX_NAME_LENGTH)
                    fread(guiIconsName[i], 1, RAYGUI_ICON_MAX_NAME_LENGTH, rgiFile)
                next i
            
            else 
                fseek(rgiFile, iconCount*RAYGUI_ICON_MAX_NAME_LENGTH, SEEK_CUR)
            end if

            ' Read icons data directly over internal icons array
            fread(guiIconsPtr, sizeof(ulong), iconCount*(iconSize*iconSize/32), rgiFile)
        end if

        fclose(rgiFile)
    end if

    return guiIconsName
end function

' Draw selected icon using rectangles pixel-by-pixel
sub GuiDrawIcon(byval iconId as long, byval posX as long, byval posY as long, byval pixelSize as long, byval color_ as RayColor)

    #define BIT_CHECK(a,b) ((a) AND (1u shl (b)))

    var y = 0l
    for i as integer = 0 to (RAYGUI_ICON_SIZE * RAYGUI_ICON_SIZE / 32) -1
        for k as integer = 0 to 31

            if (BIT_CHECK(guiIconsPtr[iconId*RAYGUI_ICON_DATA_ELEMENTS + i], k)) then
            
            
                GuiDrawRectangle(type<Rectangle>( posX + (k mod RAYGUI_ICON_SIZE)*pixelSize, posY + y*pixelSize, pixelSize, pixelSize ), 0, BLANK, color_)
            
            end if

            if ((k = 15) OR (k = 31)) then
                y += 1
            end if
        next k
    next i
end sub

' Set icon drawing size
sub GuiSetIconScale(byval scale as long)
    if (scale >= 1) then
        guiIconScale = scale
    end if
end sub

#endif      ' notRAYGUI_NO_ICONS

'----------------------------------------------------------------------------------
' Module specific Functions Definition
'----------------------------------------------------------------------------------

' Load style from memory
' WARNING: Binary files only
sub GuiLoadStyleFromMemory(byval fileData as const ubyte ptr, byval dataSize as long)

    var fileDataPtr = fileData

    dim as zstring * 5 signature
    dim as short version = 0
    dim as short reserved = 0
    var propertyCount = 0l

    memcpy(@signature, fileDataPtr, 4)
    memcpy(@version, fileDataPtr + 4, sizeof(short))
    memcpy(@reserved, fileDataPtr + 4 + 2, sizeof(short))
    memcpy(@propertyCount, fileDataPtr + 4 + 2 + 2, sizeof(long))
    fileDataPtr += 12

    if ((signature[0] = asc("r")) AND _
        (signature[1] = asc("G")) AND _
        (signature[2] = asc("S")) AND _
        (signature[3] = asc(" "))) then
    
        dim as short controlId = 0
        dim as short propertyId = 0
        dim as ulong propertyValue = 0

        for i as integer = 0 to propertyCount -1 
            memcpy(@controlId, fileDataPtr, sizeof(short))
            memcpy(@propertyId, fileDataPtr + 2, sizeof(short))
            memcpy(@propertyValue, fileDataPtr + 2 + 2, sizeof(ulong))
            fileDataPtr += 8

            if (controlId = 0) then ' DEFAULT control
            
                ' If a DEFAULT property is loaded, it is propagated to all controls
                ' NOTE: All DEFAULT properties should be defined first in the file
                GuiSetStyle(0, propertyId, propertyValue)

                if (propertyId < RAYGUI_MAX_PROPS_BASE) then
                    for n as integer = 1 to RAYGUI_MAX_CONTROLS - 1
                        GuiSetStyle(n, propertyId, propertyValue)
                    next N
                end if
            
            else 
                GuiSetStyle(controlId, propertyId, propertyValue)
            end if
        next i

        ' Font loading is highly dependant on raylib API to load font_ data and image


        ' Load custom font_ if available
        var fontDataSize = 0l
        memcpy(@fontDataSize, fileDataPtr, sizeof(long))
        fileDataPtr += 4

        if (fontDataSize > 0) then
        
            dim as Font font_
            var fontType_ = 0l   ' 0-Normal, 1-SDF

            memcpy(@font_.baseSize, fileDataPtr, sizeof(long))
            memcpy(@font_.glyphCount, fileDataPtr + 4, sizeof(long))
            memcpy(@fontType_, fileDataPtr + 4 + 4, sizeof(long))
            fileDataPtr += 12

            ' Load font_ white rectangle
            dim as Rectangle fontWhiteRec 
            memcpy(@fontWhiteRec, fileDataPtr, sizeof(Rectangle))
            fileDataPtr += 16

            ' Load font_ image parameters
            var fontImageUncompSize = 0l
            var fontImageCompSize = 0l
            memcpy(@fontImageUncompSize, fileDataPtr, sizeof(long))
            memcpy(@fontImageCompSize, fileDataPtr + 4, sizeof(long))
            fileDataPtr += 8

            dim as Image imFont
            imFont.mipmaps = 1
            memcpy(@imFont.width_, fileDataPtr, sizeof(long))
            memcpy(@imFont.height, fileDataPtr + 4, sizeof(long))
            memcpy(@imFont.format_, fileDataPtr + 4 + 4, sizeof(long))
            fileDataPtr += 12

            if ((fontImageCompSize > 0) AND (fontImageCompSize <> fontImageUncompSize)) then
            
                ' Compressed font_ atlas image data (DEFLATE), it requires DecompressData()
                var dataUncompSize = 0l
                dim as ubyte ptr compData = malloc(fontImageCompSize)
                memcpy(compData, fileDataPtr, fontImageCompSize)
                fileDataPtr += fontImageCompSize

                imFont.data_ = DecompressData(compData, fontImageCompSize, @dataUncompSize)

                ' Security check, dataUncompSize must match the provided fontImageUncompSize
                if (dataUncompSize <> fontImageUncompSize) then
                    TraceLog(LOG_WARNING, "RAYGUI: Uncompressed font_ atlas image data could be corrupted")
                end if

                free(compData)
            
            else
            
                ' Font atlas image data is not compressed
                imFont.data_ = malloc(fontImageUncompSize)
                memcpy(imFont.data_, fileDataPtr, fontImageUncompSize)
                fileDataPtr += fontImageUncompSize
            end if

            if (font_.texture.id <> GetFontDefault().texture.id) then
                UnloadTexture(font_.texture)
            end if
            font_.texture = LoadTextureFromImage(imFont)

            free(imFont.data_)

            ' Validate font_ atlas texture was loaded correctly
            if (font_.texture.id <> 0) then
            
                ' Load font_ recs data
                var recsDataSize = font_.glyphCount*sizeof(Rectangle)
                var recsDataCompressedSize = 0l

                ' WARNING: Version 400 adds the compression size parameter
                if (version >= 400) then
                
                    ' RGS files version 400 support compressed recs data
                    memcpy(@recsDataCompressedSize, fileDataPtr, sizeof(long))
                    fileDataPtr += sizeof(long)
                end if

                if ((recsDataCompressedSize > 0) AND (recsDataCompressedSize <> recsDataSize)) then
                
                    ' Recs data is compressed, uncompress it
                    dim as ubyte ptr recsDataCompressed = malloc(recsDataCompressedSize)

                    memcpy(recsDataCompressed, fileDataPtr, recsDataCompressedSize)
                    fileDataPtr += recsDataCompressedSize

                    var recsDataUncompSize = 0l
                    font_.recs = cast(Rectangle ptr,DecompressData(recsDataCompressed, recsDataCompressedSize, @recsDataUncompSize))

                    ' Security check, data uncompressed size must match the expected original data size
                    if (recsDataUncompSize <> recsDataSize) then
                        TraceLog(LOG_WARNING, "RAYGUI: Uncompressed font_ recs data could be corrupted")
                    end if

                    free(recsDataCompressed)
                
                else
                
                    ' Recs data is uncompressed
                    font_.recs = calloc(font_.glyphCount, sizeof(Rectangle))
                    for i as integer = 0 to font_.glyphCount - 1
                        memcpy(@font_.recs[i], fileDataPtr, sizeof(Rectangle))
                        fileDataPtr += sizeof(Rectangle)
                    next i
                end if

                ' Load font_ glyphs info data
                var glyphsDataSize = font_.glyphCount*16    ' 16 bytes data per glyph
                var glyphsDataCompressedSize = 0l

                ' WARNING: Version 400 adds the compression size parameter
                if (version >= 400) then
                    ' RGS files version 400 support compressed glyphs data
                    memcpy(@glyphsDataCompressedSize, fileDataPtr, sizeof(long))
                    fileDataPtr += sizeof(long)
                end if

                ' Allocate required glyphs space to fill with data
                font_.glyphs = calloc(font_.glyphCount, sizeof(GlyphInfo))

                if ((glyphsDataCompressedSize > 0) AND (glyphsDataCompressedSize <> glyphsDataSize)) then
                
                    ' Glyphs data is compressed, uncompress it
                    dim as ubyte ptr glypsDataCompressed = malloc(glyphsDataCompressedSize)

                    memcpy(glypsDataCompressed, fileDataPtr, glyphsDataCompressedSize)
                    fileDataPtr += glyphsDataCompressedSize

                    var glyphsDataUncompSize = 0l
                    var glyphsDataUncomp = DecompressData(glypsDataCompressed, glyphsDataCompressedSize, @glyphsDataUncompSize)

                    ' Security check, data uncompressed size must match the expected original data size
                    if (glyphsDataUncompSize <> glyphsDataSize) then
                        TraceLog(LOG_WARNING, "RAYGUI: Uncompressed font_ glyphs data could be corrupted")
                    end if

                    var glyphsDataUncompPtr = glyphsDataUncomp

                    for i as integer = 0 to font_.glyphCount - 1
                        memcpy(@font_.glyphs[i].value, glyphsDataUncompPtr, sizeof(long))
                        memcpy(@font_.glyphs[i].offsetX, glyphsDataUncompPtr + 4, sizeof(long))
                        memcpy(@font_.glyphs[i].offsetY, glyphsDataUncompPtr + 8, sizeof(long))
                        memcpy(@font_.glyphs[i].advanceX, glyphsDataUncompPtr + 12, sizeof(long))
                        glyphsDataUncompPtr += 16
                    next i

                    free(glypsDataCompressed)
                    free(glyphsDataUncomp)
                
                else
                
                    ' Glyphs data is uncompressed
                    for i as integer = 0 to font_.glyphCount - 1
                        memcpy(@font_.glyphs[i].value, fileDataPtr, sizeof(long))
                        memcpy(@font_.glyphs[i].offsetX, fileDataPtr + 4, sizeof(long))
                        memcpy(@font_.glyphs[i].offsetY, fileDataPtr + 8, sizeof(long))
                        memcpy(@font_.glyphs[i].advanceX, fileDataPtr + 12, sizeof(long))
                        fileDataPtr += 16
                    next i
                end if
            
            else 
                font_ = GetFontDefault()   ' Fallback in case of errors loading font_ atlas texture
            end if

            GuiSetFont(font_)

            ' Set font_ texture source rectangle to be used as white texture to draw shapes
            ' NOTE: It makes possible to draw shapes and text (full UI) in a single draw call
            if ((fontWhiteRec.x > 0) AND _
                (fontWhiteRec.y > 0) AND _
                (fontWhiteRec.width_ > 0) AND _
                (fontWhiteRec.height > 0)) then
            
                    SetShapesTexture(font_.texture, fontWhiteRec)
            end if
        end if

    end if
end sub

' Gui get text width_ considering icon
function GetTextWidth(byval text as const zstring ptr) as long

    #ifndef ICON_TEXT_PADDING
        #define ICON_TEXT_PADDING   4
    #endif

    dim as Vector2 textSize 
    var textIconOffset = 0l

    if ((text <> NULL) ANDALSO (text[0] <> 0)) then
    
        if (text[0] = asc("#")) then
            var i = 1
            while (i < 5 AND text[i] <> 0)
                if (text[i] = asc("#")) then
                
                    textIconOffset = i
                    exit while
                end if
                i += 1
            wend
        end if

        text += textIconOffset

        ' Make sure guiFont is set, GuiGetStyle() initializes it lazynessly
        var fontSize = GuiGetStyle(DEFAULT, TEXT_SIZE)

        ' Custom MeasureText() implementation
        if ((guiFont.texture.id > 0) ANDALSO (text <> NULL)) then
        
            ' Get size in bytes of text, considering end of line and line break
            var size = 0l
            for i as integer = 0 to MAX_LINE_BUFFER_SIZE - 1
                if ((text[i] <> 0) ANDALSO (text[i] <> 13)) then
                    size += 1
                else 
                    exit for
                end if
            next i

            var scaleFactor = csng(fontSize/guiFont.baseSize)
            textSize.y = guiFont.baseSize*scaleFactor
            var glyphWidth = 0.0f

            var codepointSize = 0l
            var i = 0
            while (i < size)
                var codepoint = GetCodepointNext(@text[i], @codepointSize)
                var codepointIndex = GetGlyphIndex(guiFont, codepoint)

                if (guiFont.glyphs[codepointIndex].advanceX = 0) then
                    glyphWidth = (guiFont.recs[codepointIndex].width_*scaleFactor)
                else 
                    glyphWidth = (guiFont.glyphs[codepointIndex].advanceX*scaleFactor)
                end if

                textSize.x += (glyphWidth + GuiGetStyle(DEFAULT, TEXT_SPACING))

                i += codepointSize
            wend
        end if

        if (textIconOffset > 0) then
            textSize.x += (RAYGUI_ICON_SIZE - ICON_TEXT_PADDING)
        end if
    end if

    return clng(textSize.x)
end function

' Get text bounds considering control bounds
function GetTextBounds(byval control as long, byval bounds as Rectangle) as Rectangle

    var textBounds = bounds

    textBounds.x = bounds.x + GuiGetStyle(control, BORDER_WIDTH)
    textBounds.y = bounds.y + GuiGetStyle(control, BORDER_WIDTH) + GuiGetStyle(control, TEXT_PADDING)
    textBounds.width_ = bounds.width_ - 2*GuiGetStyle(control, BORDER_WIDTH) - 2*GuiGetStyle(control, TEXT_PADDING)
    textBounds.height = bounds.height - 2*GuiGetStyle(control, BORDER_WIDTH) - 2*GuiGetStyle(control, TEXT_PADDING)    ' NOTE: Text is processed line per linenot

    ' Depending on control, TEXT_PADDING and TEXT_ALIGNMENT properties could affect the text-bounds
    select case (control)
    
        ' TODO: Special cases (no label): COMBOBOX, DROPDOWNBOX, LISTVIEW
        ' TODO: More special cases (label on side): SLIDER_, CHECKBOX, VALUEBOX, SPINNER_
        case COMBOBOX OR DROPDOWNBOX OR LISTVIEW OR SLIDER_ OR CHECKBOX OR VALUEBOX OR SPINNER_
            
        case else
        
            ' TODO: WARNING: TEXT_ALIGNMENT is already considered in GuiDrawText()
            if (GuiGetStyle(control, TEXT_ALIGNMENT) = TEXT_ALIGN_RIGHT) then
                textBounds.x -= GuiGetStyle(control, TEXT_PADDING)
            else 
                textBounds.x += GuiGetStyle(control, TEXT_PADDING)
            end if
        
    end select

    return textBounds
end function

' Get text icon if provided and move text cursor
' NOTE: We support up to 999 values for iconId
function GetTextIcon(byval text as const zstring ptr, byval iconId as long ptr) as const zstring ptr

#ifndef RAYGUI_NO_ICONS
    *iconId = -1
    if (text[0] = asc("#")) then     ' Maybe we have an iconnot
    
        dim as zstring * 4 iconValue  ' Maximum length for icon value: 3 digits + '\0'

        var pos_ = 1l
        while ((pos_ < 4) AND (text[pos_] >= asc("0")) AND (text[pos_] <= asc("9")))
        
            iconValue[pos_ - 1] = text[pos_]
            pos_ += 1
        wend

        if (text[pos_] = asc("#")) then
        
            *iconId = TextToInteger(iconValue)

            ' Move text pointer after icon
            ' WARNING: If only icon provided, it could point to EOL character: '\0'
            if (*iconId >= 0) then
                text += (pos_ + 1)
            end if
        end if
    end if
#endif

    return text
end function

' Get text divided into lines (by line-breaks '\n')
function GetTextLines(byval text as const zstring ptr, byval count as long ptr) as const zstring ptr ptr

    #define RAYGUI_MAX_TEXT_LINES   128

    static as zstring ptr lines( 0 to RAYGUI_MAX_TEXT_LINES - 1)
    for i as integer = 0 to RAYGUI_MAX_TEXT_LINES - 1
        lines(i) = NULL    ' Init NULL pointers to substrings
    next I

    var textSize = strlen(text)

    lines(0) = cast(zstring ptr, text)
    var len_ = 0l
    *count = 1

    var k = 0l
    var i = 0l
    while ((i < textSize) AND (*count < RAYGUI_MAX_TEXT_LINES))
        if (text[i] = 13) then ' \n
        
            'lineSize = len
            k += 1
            lines(k) = cast(zstring ptr, @text[i + 1])     ' WARNING: next value is valid?
            len_ = 0
            *count += 1
        
        else 
            len_ += 1
        end if
        i += 1
    wend

    return @lines(0)
end function

' Get text width_ to next space for provided string
function GetNextSpaceWidth(byval text as const zstring ptr, byval nextSpaceIndex as long ptr) as single

    var width_ = 0f
    var codepointByteCount = 0l
    var codepoint = 0l
    var index = 0l
    var glyphWidth = 0f
    var scaleFactor = csng(GuiGetStyle(DEFAULT, TEXT_SIZE)/guiFont.baseSize)

    var i = 0l
    while (text[i] <> 0)
        if (text[i] <> asc(" ")) then
        
            codepoint = GetCodepoint(@text[i], @codepointByteCount)
            index = GetGlyphIndex(guiFont, codepoint)
            glyphWidth = iif((guiFont.glyphs[index].advanceX = 0), guiFont.recs[index].width_*scaleFactor , guiFont.glyphs[index].advanceX*scaleFactor)
            width_ += (glyphWidth + GuiGetStyle(DEFAULT, TEXT_SPACING))
        
        else
        
            *nextSpaceIndex = i
            exit while
        end if
        i += 1
    wend

    return width_
end function

' Gui draw text using default font_
sub GuiDrawText(byval text as const zstring ptr, byval textBounds as Rectangle, byval alignment as long, byval tint as RayColor)

    #define TEXT_VALIGN_PIXEL_OFFSET(h)  (clng(h mod 2))     ' Vertical alignment for pixel perfect

    #ifndef ICON_TEXT_PADDING
        #define ICON_TEXT_PADDING   4
    #endif

    if ((text = NULL) ORELSE (text[0] = 0)) then
        return    ' Security check
    end if

    ' PROCEDURE:
    '   - Text is processed line per line
    '   - For every line, horizontal alignment is defined
    '   - For all text, vertical alignment is defined (multiline text only)
    '   - For every line, wordwrap mode is checked (useful for GuitextBox(), read-only)

    ' Get text lines (using '\n' as delimiter) to be processed individually
    ' WARNING: We can't use GuiTextSplit() function because it can be already used
    ' before the GuiDrawText() call and its buffer is static, it would be overriden :(
    var lineCount = 0l
    var lines = GetTextLines(text, @lineCount)

    ' Text style variables
    'byval alignment as long = GuiGetStyle(DEFAULT, TEXT_ALIGNMENT)
    var alignmentVertical = GuiGetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL)
    var wrapMode = GuiGetStyle(DEFAULT, TEXT_WRAP_MODE)    ' Wrap-mode only available in read-only mode, no for text editing

    ' TODO: WARNING: This totalHeight is not valid for vertical alignment in case of word-wrap
    var totalHeight = csng(lineCount*GuiGetStyle(DEFAULT, TEXT_SIZE) + (lineCount - 1)*GuiGetStyle(DEFAULT, TEXT_SIZE)/2)
    var posOffsetY = 0.0f

    for i as integer = 0 to lineCount - 1
        var iconId = 0l
        lines[i] = GetTextIcon(lines[i], @iconId)      ' Check text for icon and move cursor

        ' Get text position depending on alignment and iconId
        '---------------------------------------------------------------------------------
        var textBoundsPosition = type<Vector2>( textBounds.x, textBounds.y )

        ' NOTE: We get text size after icon has been processed
        ' WARNING: GetTextWidth() also processes text icon to get width_not -> Really needed?
        var textSizeX = GetTextWidth(lines[i])

        ' If text requires an icon, add size to measure
        if (iconId >= 0) then
        
            textSizeX += RAYGUI_ICON_SIZE*guiIconScale

            ' WARNING: If only icon provided, text could be pointing to EOF character: '\0'
#ifndef RAYGUI_NO_ICONS
            if ((lines[i] <> NULL) AND (lines[i][0] <> 0)) then
                textSizeX += ICON_TEXT_PADDING
            end if
#endif
        end if

        ' Check guiTextAlign global variables
        select case (alignment)
        
            case TEXT_ALIGN_LEFT 
                textBoundsPosition.x = textBounds.x 
            case TEXT_ALIGN_CENTER: 
                textBoundsPosition.x = textBounds.x +  textBounds.width_/2 - textSizeX/2 
            case TEXT_ALIGN_RIGHT 
                textBoundsPosition.x = textBounds.x + textBounds.width_ - textSizeX 
            
        end select

        select case (alignmentVertical)
        
            ' Only valid in case of wordWrap = 0
            case TEXT_ALIGN_TOP 
                textBoundsPosition.y = textBounds.y + posOffsetY 
            case TEXT_ALIGN_MIDDLE
                textBoundsPosition.y = textBounds.y + posOffsetY + textBounds.height/2 - totalHeight/2 + TEXT_VALIGN_PIXEL_OFFSET(textBounds.height) 
            case TEXT_ALIGN_BOTTOM
                textBoundsPosition.y = textBounds.y + posOffsetY + textBounds.height - totalHeight + TEXT_VALIGN_PIXEL_OFFSET(textBounds.height) 
            
        end select

        ' NOTE: Make sure we get pixel-perfect coordinates,
        ' In case of decimals we got weird text positioning
        textBoundsPosition.x = clng(textBoundsPosition.x)
        textBoundsPosition.y = clng(textBoundsPosition.y)
        '---------------------------------------------------------------------------------

        ' Draw text (with icon if available)
        '---------------------------------------------------------------------------------
#ifndef RAYGUI_NO_ICONS
        if (iconId >= 0) then
        
            ' NOTE: We consider icon height, probably different than text size
            GuiDrawIcon(iconId, textBoundsPosition.x, clng(textBounds.y + textBounds.height/2 - RAYGUI_ICON_SIZE*guiIconScale/2 + TEXT_VALIGN_PIXEL_OFFSET(textBounds.height)), guiIconScale, tint)
            textBoundsPosition.x += (RAYGUI_ICON_SIZE*guiIconScale + ICON_TEXT_PADDING)
        end if
#endif
        ' Get size in bytes of text,
        ' considering end of line and line break
        var lineSize = 0l
        var c = 0l
            
        while (lines[i][c] <> 0) AND (lines[i][c] <> 13) AND (lines[i][c] <> 10)
            c +=1
            lineSize += 1
        wend
        var scaleFactor = GuiGetStyle(DEFAULT, TEXT_SIZE)/guiFont.baseSize

        var textOffsetY = 0l
        var textOffsetX = 0.0f
        var glyphWidth = 0.0f
        c = 0l
        var codepointSize = 0l
        while (c < lineSize)

            var codepoint = GetCodepointNext(@lines[i][c], @codepointSize)
            var index = GetGlyphIndex(guiFont, codepoint)

            ' NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return &h3f)
            ' but we need to draw all of the bad bytes using the '?' symbol moving one byte
            if (codepoint = &h3f) then
                codepointSize = 1       ' TODO: Review not recognized codepoints size
            end if

            ' Wrap mode text measuring to space to validate if it can be drawn or
            ' a new line is required
            if (wrapMode = TEXT_WRAP_CHAR) then
            
                ' Get glyph width_ to check if it goes out of bounds
                if (guiFont.glyphs[index].advanceX = 0) then
                    glyphWidth = (guiFont.recs[index].width_*scaleFactor)
                else 
                    glyphWidth = guiFont.glyphs[index].advanceX*scaleFactor
                end if

                ' Jump to next line if current character reach end of the box limits
                if ((textOffsetX + glyphWidth) > textBounds.width_) then
                
                    textOffsetX = 0.0f
                    textOffsetY += GuiGetStyle(DEFAULT, TEXT_LINE_SPACING)
                end if
            
            elseif (wrapMode = TEXT_WRAP_WORD) then
            
                ' Get width_ to next space in line
                var nextSpaceIndex = 0l
                var nextSpaceWidth = GetNextSpaceWidth(lines[i] + c, @nextSpaceIndex)

                if ((textOffsetX + nextSpaceWidth) > textBounds.width_) then
                
                    textOffsetX = 0.0f
                    textOffsetY += GuiGetStyle(DEFAULT, TEXT_LINE_SPACING)
                end if

                ' TODO: Consider case: (nextSpaceWidth >= textBounds.width_)
            end if

            if (codepoint = 13 /' \r '/) then
                exit while   ' WARNING: Lines are already processed manually, no need to keep drawing after this codepoint

            else
            
                ' TODO: There are multiple types of spaces in Unicode, 
                ' maybe it's a good idea to add support for more: http:'jkorpela.fi/chars/spaces.html
                if ((codepoint <> asc(" ")) AND (codepoint <> 9 /' TAB '/)) then     ' Do not draw codepoints with no glyph
                
                    if (wrapMode = TEXT_WRAP_NONE) then
                    
                        ' Draw only required text glyphs fitting the textBounds.width_
                        if (textOffsetX <= (textBounds.width_ - glyphWidth)) then
                        
                            DrawTextCodepoint(guiFont, codepoint, type<Vector2>( textBoundsPosition.x + textOffsetX, textBoundsPosition.y + textOffsetY ), GuiGetStyle(DEFAULT, TEXT_SIZE), GuiFade(tint, guiAlpha))
                        end if
                    
                    elseif ((wrapMode = TEXT_WRAP_CHAR) OR (wrapMode = TEXT_WRAP_WORD)) then
                    
                        ' Draw only glyphs inside the bounds
                        if ((textBoundsPosition.y + textOffsetY) <= (textBounds.y + textBounds.height - GuiGetStyle(DEFAULT, TEXT_SIZE))) then
                        
                            DrawTextCodepoint(guiFont, codepoint, type<Vector2>( textBoundsPosition.x + textOffsetX, textBoundsPosition.y + textOffsetY ), GuiGetStyle(DEFAULT, TEXT_SIZE), GuiFade(tint, guiAlpha))
                        end if
                    end if
                end if

                if (guiFont.glyphs[index].advanceX = 0) then
                    textOffsetX += (guiFont.recs[index].width_*scaleFactor + GuiGetStyle(DEFAULT, TEXT_SPACING))
                else 
                    textOffsetX += (guiFont.glyphs[index].advanceX*scaleFactor + GuiGetStyle(DEFAULT, TEXT_SPACING))
                end if
            end if
            c += codepointSize
        wend

        if (wrapMode = TEXT_WRAP_NONE) then
            posOffsetY += GuiGetStyle(DEFAULT, TEXT_LINE_SPACING)
        elseif ((wrapMode = TEXT_WRAP_CHAR) OR (wrapMode = TEXT_WRAP_WORD)) then
            posOffsetY += (textOffsetY + GuiGetStyle(DEFAULT, TEXT_LINE_SPACING))
        end if
        '---------------------------------------------------------------------------------
    next i

#ifdef RAYGUI_DEBUG_TEXT_BOUNDS
    GuiDrawRectangle(textBounds, 0, WHITE, Fade(BLUE, 0.4f))
#endif
end sub

' Gui draw rectangle using default raygui plain style with borders
sub GuiDrawRectangle(byval rec as Rectangle, byval borderWidth as long, byval borderColor as RayColor, byval color_ as RayColor)

    if (color_.a > 0) then
    
        ' Draw rectangle filled with color_
        DrawRectangle(clng(rec.x), clng(rec.y), clng(rec.width_), clng(rec.height), GuiFade(color_, guiAlpha))
    end if

    if (borderWidth > 0) then
    
        ' Draw rectangle border lines with color_
        DrawRectangle(rec.x, rec.y, rec.width_, borderWidth, GuiFade(borderColor, guiAlpha))
        DrawRectangle(rec.x, rec.y + borderWidth, borderWidth, rec.height - 2*borderWidth, GuiFade(borderColor, guiAlpha))
        DrawRectangle(rec.x + rec.width_ - borderWidth, rec.y + borderWidth, borderWidth, rec.height - 2*borderWidth, GuiFade(borderColor, guiAlpha))
        DrawRectangle(rec.x, rec.y + rec.height - borderWidth, rec.width_, borderWidth, GuiFade(borderColor, guiAlpha))
    end if

#ifdef RAYGUI_DEBUG_RECS_BOUNDS
    DrawRectangle(rec.x, rec.y, rec.width_, rec.height, Fade(RED, 0.4f))
#endif
end sub

' Draw tooltip using control bounds
sub GuiTooltip(byval controlRec as Rectangle)

    if ((not guiLocked) AND cbool(guiTooltip_) AND cbool(guiTooltipPtr <> NULL) AND (not guiSliderDragging)) then
    
        var textSize = MeasureTextEx(GuiGetFont(), guiTooltipPtr, GuiGetStyle(DEFAULT, TEXT_SIZE), GuiGetStyle(DEFAULT, TEXT_SPACING))

        if ((controlRec.x + textSize.x + 16) > GetScreenWidth()) then 
            controlRec.x -= (textSize.x + 16 - controlRec.width_)
        end if

        GuiPanel(type<Rectangle>( controlRec.x, controlRec.y + controlRec.height + 4, textSize.x + 16, GuiGetStyle(DEFAULT, TEXT_SIZE) + 8.f ), NULL)

        var textPadding = GuiGetStyle(LABEL, TEXT_PADDING)
        var textAlignment = GuiGetStyle(LABEL, TEXT_ALIGNMENT)
        GuiSetStyle(LABEL, TEXT_PADDING, 0)
        GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER)
        GuiLabel(type<Rectangle>( controlRec.x, controlRec.y + controlRec.height + 4, textSize.x + 16, GuiGetStyle(DEFAULT, TEXT_SIZE) + 8.f ), guiTooltipPtr)
        GuiSetStyle(LABEL, TEXT_ALIGNMENT, textAlignment)
        GuiSetStyle(LABEL, TEXT_PADDING, textPadding)
    end if
end sub

' Split controls text into multiple strings
' Also check for multiple columns (required by GuiToggleGroup())
function GuiTextSplit(byval text as const zstring ptr, byval delimiter as ubyte, byval count as long ptr, byval textRow as long ptr) as const zstring ptr ptr

    ' NOTE: Current implementation returns a copy of the provided string with '\0' (string end delimiter)
    ' inserted between strings defined by "delimiter" parameter. No memory is dynamically allocated,
    ' all used memory is static... it has some limitations:
    '      1. Maximum number of possible split strings is set by RAYGUI_TEXTSPLIT_MAX_ITEMS
    '      2. Maximum size of text to split is RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE
    ' NOTE: Those definitions could be externally provided if required

    ' TODO: HACK: GuiTextSplit() - Review how textRows are returned to user
    ' textRow is an externally provided array of integers that stores row number for every splitted string

    #ifndef RAYGUI_TEXTSPLIT_MAX_ITEMS
        #define RAYGUI_TEXTSPLIT_MAX_ITEMS          128
    #endif
    #ifndef RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE
        #define RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE     1024
    #endif

    static result(0 to RAYGUI_TEXTSPLIT_MAX_ITEMS -1) as const zstring ptr   ' String pointers array (points to buffer data)
    static buffer as zstring * RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE         ' Buffer data (text input copy with '\0' added)
    memset(@buffer, 0, RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE)

    result(0) = @buffer
    var counter = 1

    if (textRow <> NULL) then
        textRow[0] = 0
    end if

    ' Count how many substrings we have on text and point to every one
    for i as integer = 0 to RAYGUI_TEXTSPLIT_MAX_TEXT_SIZE - 1

        buffer[i] = text[i]
        if (buffer[i] = 0) then
            exit for
        elseif ((buffer[i] = delimiter) OR (buffer[i] = 10)) then
        
            result(counter) = cast(zstring ptr, @(buffer[i + 1]))

            if (textRow <> NULL) then
            
                if (buffer[i] = 10) then
                    textRow[counter] = textRow[counter - 1] + 1
                else 
                    textRow[counter] = textRow[counter - 1]
                end if
            end if

            buffer[i] = 0   ' Set an end of string at this point

            counter += 1
            if (counter = RAYGUI_TEXTSPLIT_MAX_ITEMS) then
                exit for
            end if
        end if
    next i

    *count = counter

    return @result(0)
end function

' Convert color_ data from RGB to HSV
' NOTE: RayColor data should be passed normalized
function ConvertRGBtoHSV(byval rgb_ as Vector3) as Vector3

    dim hsv as Vector3 
    var min = 0.0f
    var max = 0.0f
    var delta = 0.0f

    min = iif((rgb_.x < rgb_.y), rgb_.x , rgb_.y)
    min = iif((min < rgb_.z), min , rgb_.z)

    max = iif((rgb_.x > rgb_.y), rgb_.x , rgb_.y)
    max = iif((max > rgb_.z), max , rgb_.z)

    hsv.z = max            ' Value
    delta = max - min

    if (delta < 0.00001f) then
    
        hsv.y = 0.0f
        hsv.x = 0.0f           ' Undefined, maybe NAN?
        return hsv
    end if

    if (max > 0.0f) then
    
        ' NOTE: If max is 0, this divide would cause a crash
        hsv.y = (delta/max)    ' Saturation
    
    else
    
        ' NOTE: If max is 0, then r = g = b = 0, s = 0, h is undefined
        hsv.y = 0.0f
        hsv.x = 0.0f           ' Undefined, maybe NAN?
        return hsv
    end if

    ' NOTE: Comparing float values could not work properly
    if (rgb_.x >= max) then
        hsv.x = (rgb_.y - rgb_.z)/delta    ' Between yellow & magenta
    else
    
        if (rgb_.y >= max) then
            hsv.x = 2.0f + (rgb_.z - rgb_.x)/delta  ' Between cyan & yellow
        else 
            hsv.x = 4.0f + (rgb_.x - rgb_.y)/delta      ' Between magenta & cyan
        end if
    end if

    hsv.x *= 60.0f     ' Convert to degrees

    if (hsv.x < 0.0f) then
        hsv.x += 360.0f
    end if

    return hsv
end function

' Convert color_ data from HSV to RGB
' NOTE: RayColor data should be passed normalized
function ConvertHSVtoRGB(byval hsv as Vector3) as Vector3

    dim rgb_ as Vector3
    var hh = 0.0f, p = 0.0f, q = 0.0f, t = 0.0f, ff = 0.0f
    var i = 0l

    ' NOTE: Comparing float values could not work properly
    if (hsv.y <= 0.0f) then
    
        rgb_.x = hsv.z
        rgb_.y = hsv.z
        rgb_.z = hsv.z
        return rgb_
    end if

    hh = hsv.x
    if (hh >= 360.0f) then
        hh = 0.0f
    end if
    hh /= 60.0f

    i = clng(hh)
    ff = hh - i
    p = hsv.z*(1.0f - hsv.y)
    q = hsv.z*(1.0f - (hsv.y*ff))
    t = hsv.z*(1.0f - (hsv.y*(1.0f - ff)))

    select case (i)
        case 0
        
            rgb_.x = hsv.z
            rgb_.y = t
            rgb_.z = p
        
        case 1
        
            rgb_.x = q
            rgb_.y = hsv.z
            rgb_.z = p
        
        case 2
        
            rgb_.x = p
            rgb_.y = hsv.z
            rgb_.z = t
        
        case 3
        
            rgb_.x = p
            rgb_.y = q
            rgb_.z = hsv.z
        
        case 4
        
            rgb_.x = t
            rgb_.y = p
            rgb_.z = hsv.z
        
        case else
            rgb_.x = hsv.z
            rgb_.y = p
            rgb_.z = q

    end select

    return rgb_
end function

' Scroll bar control (used by GuiScrollPanel())
function GuiScrollBar(byval bounds as Rectangle, byval value as long, byval minValue as long, byval maxValue as long) as long
    var state = guiState_

    ' Is the scrollbar horizontal or vertical?
    var isVertical = iif((bounds.width_ > bounds.height), false , true)

    ' The size (width_ or height depending on scrollbar type) of the spinner buttons
    var spinnerSize = iif( GuiGetStyle(SCROLLBAR_, ARROWS_VISIBLE), iif(isVertical, clng(bounds.width_) - 2*GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) , clng(bounds.height) - 2*GuiGetStyle(SCROLLBAR_, BORDER_WIDTH)) , 0)

    ' Arrow buttons [<] [>] [∧] [∨]
    dim as Rectangle arrowUpLeft
    dim as Rectangle arrowDownRight

    ' Actual area of the scrollbar excluding the arrow buttons
    dim as Rectangle scrollbar

    ' Slider bar that moves     --['/]-----
    dim as Rectangle slider

    ' Normalize value
    if (value > maxValue) then
        value = maxValue
    end if
    if (value < minValue) then
        value = minValue
    end if

    var valueRange = maxValue - minValue
    var sliderSize = GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_SIZE)

    ' Calculate rectangles for all of the components
    arrowUpLeft = type<Rectangle>( _
        bounds.x + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), _
        bounds.y + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), _
        spinnerSize, _ 
        spinnerSize _
    )

    if (isVertical) then
    
        arrowDownRight = type<Rectangle>( bounds.x + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), bounds.y + bounds.height - spinnerSize - GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), spinnerSize, spinnerSize )
        scrollbar = type<Rectangle>( bounds.x + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_PADDING), arrowUpLeft.y + arrowUpLeft.height, bounds.width_ - 2*(GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_PADDING)), bounds.height - arrowUpLeft.height - arrowDownRight.height - 2*GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) )

        ' Make sure the slider won't get outside of the scrollbar
        sliderSize = iif((sliderSize >= scrollbar.height), (clng(scrollbar.height) - 2) , sliderSize)
        slider = type<Rectangle>( _
            bounds.x + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_PADDING), _
            scrollbar.y + (((value - minValue)/valueRange)*(scrollbar.height - sliderSize)), _
            bounds.width_ - 2*(GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_PADDING)), _
            sliderSize _
        )
    
    else    ' horizontal
    
        arrowDownRight = type<Rectangle>( bounds.x + bounds.width_ - spinnerSize - GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), bounds.y + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), spinnerSize, spinnerSize )
        scrollbar = type<Rectangle>( arrowUpLeft.x + arrowUpLeft.width_, bounds.y + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_PADDING), bounds.width_ - arrowUpLeft.width_ - arrowDownRight.width_ - 2*GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), bounds.height - 2*(GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_PADDING)) )

        ' Make sure the slider won't get outside of the scrollbar
        sliderSize = iif((sliderSize >= scrollbar.width_), (scrollbar.width_ - 2) , sliderSize)
        slider = type<Rectangle>( _
            scrollbar.x + (((value - minValue)/valueRange)*(scrollbar.width_ - sliderSize)), _
            bounds.y + GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_PADDING), _
            sliderSize, _
            bounds.height - 2*(GuiGetStyle(SCROLLBAR_, BORDER_WIDTH) + GuiGetStyle(SCROLLBAR_, SCROLL_SLIDER_PADDING)) _
        )
    end if

    ' Update control
    '--------------------------------------------------------------------
    if ((state <> STATE_DISABLED) AND (not guiLocked)) then
    
        var mousePoint = GetMousePosition()

        if (guiSliderDragging) then ' Keep dragging outside of bounds
        
            if (IsMouseButtonDown(MOUSE_LEFT_BUTTON) AND _
                not(CheckCollisionPointRec(mousePoint, arrowUpLeft)) AND _
                not(CheckCollisionPointRec(mousePoint, arrowDownRight))) then
            
                if (CHECK_BOUNDS_ID(bounds, guiSliderActive)) then
                
                    state = STATE_PRESSED

                    if (isVertical) then
                        value = (((mousePoint.y - scrollbar.y - slider.height/2)*valueRange)/(scrollbar.height - slider.height) + minValue)
                    else 
                        value = (((mousePoint.x - scrollbar.x - slider.width_/2)*valueRange)/(scrollbar.width_ - slider.width_) + minValue)
                    end if
                end if
            
            else
            
                guiSliderDragging = false
                guiSliderActive = type<Rectangle>( 0, 0, 0, 0 )
            end if
        
        elseif (CheckCollisionPointRec(mousePoint, bounds)) then
        
            state = STATE_FOCUSED

            ' Handle mouse wheel
            var wheel = clng(GetMouseWheelMove())
            if (wheel <> 0) then
                value += wheel
            end if

            ' Handle mouse button down
            if (IsMouseButtonPressed(MOUSE_LEFT_BUTTON)) then
            
                guiSliderDragging = true
                guiSliderActive = bounds ' Store bounds as an identifier when dragging starts

                ' Check arrows click
                if (CheckCollisionPointRec(mousePoint, arrowUpLeft)) then
                    value -= valueRange/GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                elseif (CheckCollisionPointRec(mousePoint, arrowDownRight)) then
                    value += valueRange/GuiGetStyle(SCROLLBAR_, SCROLL_SPEED)
                elseif (not(CheckCollisionPointRec(mousePoint, slider))) then
                
                    ' If click on scrollbar position but not on slider, place slider directly on that position
                    if (isVertical) then
                        value = (((mousePoint.y - scrollbar.y - slider.height/2)*valueRange)/(scrollbar.height - slider.height) + minValue)
                    else 
                        value = (((mousePoint.x - scrollbar.x - slider.width_/2)*valueRange)/(scrollbar.width_ - slider.width_) + minValue)
                    end if
                end if

                state = STATE_PRESSED
            end if

        end if

        ' Normalize value
        if (value > maxValue) then
            value = maxValue
        end if
        if (value < minValue) then
            value = minValue
        end if
    end if
    '--------------------------------------------------------------------

    ' Draw control
    '--------------------------------------------------------------------
    GuiDrawRectangle(bounds, GuiGetStyle(SCROLLBAR_, BORDER_WIDTH), GetColor(GuiGetStyle(LISTVIEW, BORDER + state*3)), GetColor(GuiGetStyle(DEFAULT, BORDER_COLOR_DISABLED)))   ' Draw the background

    GuiDrawRectangle(scrollbar, 0, BLANK, GetColor(GuiGetStyle(BUTTON, BASE_COLOR_NORMAL)))     ' Draw the scrollbar active area background
    GuiDrawRectangle(slider, 0, BLANK, GetColor(GuiGetStyle(SLIDER_, BORDER + state*3)))         ' Draw the slider bar

    ' Draw arrows (using icon if available)
    if (GuiGetStyle(SCROLLBAR_, ARROWS_VISIBLE)) then
    
#ifdef RAYGUI_NO_ICONS
        GuiDrawText(iif(isVertical, "^" , "<"), _
            type<Rectangle>( arrowUpLeft.x, arrowUpLeft.y, iif(isVertical, bounds.width_ , bounds.height), iif(isVertical, bounds.width_ , bounds.height) ), _
            TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_ + (state*3))))
        GuiDrawText(iif(isVertical, "v" , ">"), _
            type<Rectangle>( arrowDownRight.x, arrowDownRight.y, iif(isVertical, bounds.width_ , bounds.height), iif(isVertical, bounds.width_ , bounds.height) ), _
            TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(DROPDOWNBOX, TEXT_ + (state*3))))
#else
        GuiDrawText(iif(isVertical, "#121#" , "#118#"), _
            type<Rectangle>( arrowUpLeft.x, arrowUpLeft.y, iif(isVertical, bounds.width_ , bounds.height), iif(isVertical, bounds.width_ , bounds.height) ), _
            TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(SCROLLBAR_, TEXT_ + state*3)))   ' ICON_ARROW_UP_FILL / ICON_ARROW_LEFT_FILL
        GuiDrawText(iif(isVertical, "#120#" , "#119#"), _
            type<Rectangle>( arrowDownRight.x, arrowDownRight.y, iif(isVertical, bounds.width_ , bounds.height), iif(isVertical, bounds.width_ , bounds.height) ), _
            TEXT_ALIGN_CENTER, GetColor(GuiGetStyle(SCROLLBAR_, TEXT_ + state*3)))   ' ICON_ARROW_DOWN_FILL / ICON_ARROW_RIGHT_FILL
#endif
    end if
    '--------------------------------------------------------------------

    return value
end function

' RayColor fade-in or fade-out, alpha goes from 0.0f to 1.0f
' WARNING: It multiplies current alpha by alpha scale factor
function GuiFade(byval color_ as RayColor, byval alpha as single) as RayColor

    if (alpha < 0.0f) then
        alpha = 0.0f
    elseif (alpha > 1.0f) then
        alpha = 1.0f
    end if

    var result = type<RayColor>( color_.r, color_.g, color_.b, cubyte(color_.a*alpha) )

    return result
end function


#endif      ' RAYGUI_IMPLEMENTATION