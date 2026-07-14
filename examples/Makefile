FBCC := fbc
FBC_OPTS := -i ../include -p ../lib/lin64 -w all -exx -g

all : 2d_camera 2d_camera_platformer 2d_camera_split_screen 3d_camera_first_person 3d_camera_free 3d_camera_mode 3d_camera_split_screen 3d_picking basic basic_screen_manager bullet_hell delta_time input_gamepad_info kaleidoscope models_animation models_billboard models_bone_socket models_box_collisions models_first_person_maze raygui_control_test_suite raygui_simple rres_load_image scissor_test shaders_basic_lighting smooth_pixel_perfect

2d_camera : 2d_camera.bas
	@$(FBCC) $(FBC_OPTS) $<

2d_camera_platformer : 2d_camera_platformer.bas
	@$(FBCC) $(FBC_OPTS) $<

2d_camera_split_screen : 2d_camera_split_screen.bas
	@$(FBCC) $(FBC_OPTS) $<

3d_camera_first_person : 3d_camera_first_person.bas
	@$(FBCC) $(FBC_OPTS) $<

3d_camera_free : 3d_camera_free.bas
	@$(FBCC) $(FBC_OPTS) $<

3d_camera_mode : 3d_camera_mode.bas
	@$(FBCC) $(FBC_OPTS) $<

3d_camera_split_screen : 3d_camera_split_screen.bas
	@$(FBCC) $(FBC_OPTS) $<

3d_picking : 3d_picking.bas
	@$(FBCC) $(FBC_OPTS) $<

basic : basic.bas
	@$(FBCC) $(FBC_OPTS) $<

basic_screen_manager : basic_screen_manager.bas
	@$(FBCC) $(FBC_OPTS) $<

bullet_hell : bullet_hell.bas
	@$(FBCC) $(FBC_OPTS) $<

delta_time : delta_time.bas
	@$(FBCC) $(FBC_OPTS) $<

input_gamepad_info : input_gamepad_info.bas
	@$(FBCC) $(FBC_OPTS) $<

kaleidoscope : kaleidoscope.bas
	@$(FBCC) $(FBC_OPTS) $<

models_animation : models_animation.bas
	@$(FBCC) $(FBC_OPTS) $<

models_billboard : models_billboard.bas
	@$(FBCC) $(FBC_OPTS) $<

models_bone_socket : models_bone_socket.bas
	@$(FBCC) $(FBC_OPTS) $<

models_box_collisions : models_box_collisions.bas
	@$(FBCC) $(FBC_OPTS) $<

models_first_person_maze : models_first_person_maze.bas
	@$(FBCC) $(FBC_OPTS) $<

raygui_control_test_suite : raygui_control_test_suite.bas
	@$(FBCC) $(FBC_OPTS) $<

raygui_simple : raygui_simple.bas
	@$(FBCC) $(FBC_OPTS) $<

rres_load_image : rres_load_image.bas
	@$(FBCC) $(FBC_OPTS) $<

scissor_test : scissor_test.bas
	@$(FBCC) $(FBC_OPTS) $<

shaders_basic_lighting : shaders_basic_lighting.bas
	@$(FBCC) $(FBC_OPTS) $<

smooth_pixel_perfect : smooth_pixel_perfect.bas
	@$(FBCC) $(FBC_OPTS) $<

.PHONY clean :
	@-rm 2d_camera 2d_camera_platformer 2d_camera_split_screen 3d_camera_first_person 3d_camera_free 3d_camera_mode 3d_camera_split_screen 3d_picking basic basic_screen_manager bullet_hell delta_time input_gamepad_info kaleidoscope models_animation models_billboard models_bone_socket models_box_collisions models_first_person_maze raygui_control_test_suite raygui_simple rres_load_image scissor_test shaders_basic_lighting smooth_pixel_perfect
