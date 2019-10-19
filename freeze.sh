#!/bin/sh

##### BEG - GET GNL PROJECT PATH

PROJECT_PATH_CONFIG_FILE=project_path.config

if [ -f "${PROJECT_PATH_CONFIG_FILE}" ]
then
	PROJECT_PATH=$(<${PROJECT_PATH_CONFIG_FILE})
fi
if [ ! -d "${PROJECT_PATH}" ]
then
	rm ${PROJECT_PATH_CONFIG_FILE}
	while [ ! -d "${PROJECT_PATH}" ]
	do
		if [ "${PROJECT_PATH}" ]
		then
			echo ${PROJECT_PATH} directory not found.
		fi
		echo Type in your GNL project path. It will be stored in ./${PROJECT_PATH_CONFIG_FILE} file.
		echo  \(EXAMPLE: ../get_next_line\):
		read PROJECT_PATH
	done
	echo ${PROJECT_PATH} > ${PROJECT_PATH_CONFIG_FILE}
fi

##### END - GET GNL PROJECT PATH


