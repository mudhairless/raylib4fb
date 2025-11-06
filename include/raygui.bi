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

#inclib "raygui"

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
' WARNING: We only have 8 slots for those properties by default!!! -> New global control: TEXT_?
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

'----------------------------------------------------------------------------------
' Module Functions Declaration
'----------------------------------------------------------------------------------

extern "C"

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

declare sub GuiSetIconScale(byval scale as long)                      ' Set default icon drawing size
declare function GuiGetIcons() as ulong ptr                      ' Get raygui icons data pointer
declare function GuiLoadIcons(byval fileName as const zstring ptr, byval loadIconsName as boolean) as zstring ptr ptr ' Load raygui icons file (.rgi) into internal icons data
declare sub GuiDrawIcon(byval iconId as long, byval posX as long, byval posY as long, byval pixelSize as long, byval color_ as RayColor) ' Draw icon using pixel size at specified position


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

end extern

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

#endif ' RAYGUI_BI
