julia_install_image:
	docker build . --file julia_install_image.Dockerfile -t julia_install_image:latest

julia_install_binary_dl:
	docker build . --file julia_install_binary_dl.Dockerfile -t julia_install_binary_dl:latest

julia_install_juliaup:
	docker build . --file julia_install_juliaup.Dockerfile -t julia_install_juliaup:latest


project_1_no_precompile:
	docker build . --file project_1_no_precompile.Dockerfile \
		-t project_1_no_precompile:latest
project_2_precompile_no_cache:
	docker build . --file project_2_precompile_no_cache.Dockerfile \
		-t project_2_precompile_no_cache:latest
project_3_precompile_2_steps_cache:
	docker build . --file project_3_precompile_2_steps_cache.Dockerfile \
		-t project_3_precompile_2_steps_cache:latest
project_4_precompile_1_step_cache_relocatability:
	docker build . --file project_4_precompile_1_step_cache_relocatability.Dockerfile \
		-t project_4_precompile_1_step_cache_relocatability:latest
project_5_precompile_1_step_cache_symlinks:
	docker build . --file project_5_precompile_1_step_cache_symlinks.Dockerfile \
		-t project_5_precompile_1_step_cache_symlinks:latest
project_6_precompile_2_steps_mvdepot:
	docker build . --file project_6_precompile_2_steps_mvdepot.Dockerfile \
		-t project_6_precompile_2_steps_mvdepot:latest
project_7_sysimage:
	docker build . --file project_7_sysimage.Dockerfile \
		-t project_7_sysimage:latest


run_project_1_no_precompile:
	docker run --rm project_1_no_precompile:latest
run_project_2_precompile_no_cache:
	docker run --rm project_2_precompile_no_cache:latest
run_project_3_precompile_2_steps_cache:
	docker run --rm project_3_precompile_2_steps_cache:latest
run_project_4_precompile_1_step_cache_relocatability:
	docker run --rm project_4_precompile_1_step_cache_relocatability:latest
run_project_5_precompile_1_step_cache_symlinks:
	docker run --rm project_5_precompile_1_step_cache_symlinks:latest
run_project_6_precompile_2_steps_mvdepot:
	docker run --rm project_6_precompile_2_steps_mvdepot:latest
run_project_7_sysimage:
	docker run --rm project_7_sysimage:latest

all: \
	julia_install_image \
	julia_install_binary_dl \
	julia_install_juliaup \
	project_1_no_precompile \
	project_2_precompile_no_cache \
	project_3_precompile_2_steps_cache \
	project_4_precompile_1_step_cache_relocatability \
	project_5_precompile_1_step_cache_symlinks \
	project_6_precompile_2_steps_mvdepot \
	project_7_sysimage
