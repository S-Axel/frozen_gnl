#!/bin/sh

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"

##### BEG - GET GNL PROJECT PATH

PROJECT_PATH_CONFIG_FILE=${SCRIPT_PATH}/project_path.config

if [ -f "${PROJECT_PATH_CONFIG_FILE}" ]
then
	PROJECT_PATH=$(<${PROJECT_PATH_CONFIG_FILE})
fi
if [ ! -d "${PROJECT_PATH}" ]
then
	rm ${PROJECT_PATH_CONFIG_FILE} &> /dev/null
	while [ ! -d "${PROJECT_PATH}" ]
	do
		if [ "${PROJECT_PATH}" ]
		then
			echo ${PROJECT_PATH} directory not found.
		fi
		echo Type in your GNL project path. It will be stored in ${PROJECT_PATH_CONFIG_FILE} file.
		echo  \(EXAMPLE: ../get_next_line\):
		read PROJECT_PATH
		PROJECT_PATH="$(cd "$(dirname "${PROJECT_PATH}")"; pwd)/$(basename "${PROJECT_PATH}")"
	done
	echo ${PROJECT_PATH} > ${PROJECT_PATH_CONFIG_FILE}
fi

##### END - GET GNL PROJECT PATH

make -C ${SCRIPT_PATH}/tests/test01 PATH="${PROJECT_PATH}"
make clean -C ${SCRIPT_PATH}/tests/test01 PATH="${PROJECT_PATH}"
${SCRIPT_PATH}/tests/test01/gnl_test

