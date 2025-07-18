julia_install_image:
	docker build . --file julia_install_1_image.Dockerfile -t julia_install_image:latest

julia_install_binary_dl:
	docker build . --file julia_install_2_binary_dl.Dockerfile -t julia_install_binary_dl:latest

julia_install_juliaup:
	docker build . --file julia_install_3_juliaup.Dockerfile -t julia_install_juliaup:latest

project_precompile_no_precompile: 
	docker build . --file project_precompile_1_no_precompile.Dockerfile -t project_precompile_no_precompile:latest
project_precompile_precompile: 
	docker build . --file project_precompile_2_precompile.Dockerfile -t project_precompile_precompile:latest
project_precompile_cache: 
	docker build . --file project_precompile_3_cache.Dockerfile -t project_precompile_cache:latest
project_precompile_mvdepot: 
	docker build . --file project_precompile_4_mvdepot.Dockerfile -t project_precompile_mvdepot:latest
project_precompile_w_sysimage: 
	docker build . --file project_precompile_5_w_sysimage.Dockerfile -t project_precompile_w_sysimage:latest
project_precompile_cache_doesnt_work: 
	docker build . --file project_precompile_6_cache_doesnt_work.Dockerfile -t project_precompile_cache_doesnt_work:latest
project_precompile_cache_should_work: 
	docker build . --file project_precompile_7_cache_seems_to_work.Dockerfile -t project_precompile_cache_seems_to_work:latest


all: julia_install_image \
	julia_install_binary_dl \
	julia_install_juliaup \
	project_precompile_no_precompile \
	project_precompile_precompile \
	project_precompile_cache \
	project_precompile_mvdepot \
	project_precompile_w_sysimage \
	project_precompile_cache_doesnt_work

run_project_precompile_no_precompile: 	
	docker run --rm  project_precompile_no_precompile:latest
run_project_precompile_precompile: 	
	docker run --rm  project_precompile_precompile:latest
run_project_precompile_cache: 	
	docker run --rm  project_precompile_cache:latest
run_project_precompile_mvdepot: 	
	docker run --rm  project_precompile_mvdepot:latest
run_project_precompile_w_sysimage: 	
	docker run --rm  project_precompile_w_sysimage:latest
run_project_precompile_cache_doesnt_work: 	
	docker run --rm  project_precompile_cache_doesnt_work:latest
run_project_precompile_cache_seems_to_work:
	docker run --rm  project_precompile_cache_seems_to_work:latest
