#!/bin/bash

## TODO

### Add a timeout
### Add a flag to stop at first error or to diplay only first error



##### COLOR FUNCTIONS #####

putstr_red()
{
	echo -ne "$(tput setaf 1)$@$(tput setaf 7)"
}

putstr_green()
{
	echo -ne "$(tput setaf 2)$@$(tput setaf 7)"
}

putstr_cyan()
{
	echo -ne "$(tput setaf 6)$@$(tput setaf 7)"
}

putstr_magenta()
{
	echo -ne "$(tput setaf 5)$@$(tput setaf 7)"
}





##### GET CURRENT SCRIPT PATH #####

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"





##### GET GNL PROJECT PATH #####

PROJECT_PATH_CONFIG_FILE=${SCRIPT_PATH}/gnl_path.config

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
		read -p "(EXAMPLE: ../get_next_line): " -e PROJECT_PATH
		PROJECT_PATH="$(cd "$(dirname "${PROJECT_PATH}")"; pwd)/$(basename "${PROJECT_PATH}")"
	done
	echo ${PROJECT_PATH} > ${PROJECT_PATH_CONFIG_FILE}
fi





##### REGULAR TESTS #####

regular_tests()
{
	cd ${SCRIPT_PATH}/regular_tests
	cp ${PROJECT_PATH}/get_next_line.c .
	cp ${PROJECT_PATH}/get_next_line_utils.c .
	cp ${PROJECT_PATH}/get_next_line.h .
	./run.sh ${1} ${2}
}

if [ "${1}" = "regular_tests" ]
then
	regular_tests ${2} ${3}
fi





##### LINE NULL #####

line_null()
{
	cd ${SCRIPT_PATH}/line_null
	cp ${PROJECT_PATH}/get_next_line.c .
	cp ${PROJECT_PATH}/get_next_line_utils.c .
	cp ${PROJECT_PATH}/get_next_line.h .
	./run.sh ${1} ${2}
}

if [ "${1}" = "line_null" ]
then
	line_null ${2} ${3}
	exit
fi





##### NEGATIVE FD #####

negative_fd()
{
	cd ${SCRIPT_PATH}/negative_fd
	cp ${PROJECT_PATH}/get_next_line.c .
	cp ${PROJECT_PATH}/get_next_line_utils.c .
	cp ${PROJECT_PATH}/get_next_line.h .
	./run.sh ${1} ${2}
}

if [ "${1}" = "negative_fd" ]
then
	negative_fd ${2} ${3}
	exit
fi





##### STDIN TEST #####

stdin_test()
{
	echo -e "\n" \#\#\#\#\# STDIN TEST \#\#\#\#\# "\n"
	cd ${SCRIPT_PATH}/stdin_test
	read -p "BUFFER_SIZE: " -e BUFFER_SIZE
	make re PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null
	./gnl_test
	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
}

if [ "${1}" = "stdin_test" ]
then
	stdin_test
	exit
fi





##### IF NO OPTION -> TEST ALL #####

if [ "${1}" = "" ]
then
	regular_tests
	line_null
	negative_fd
	stdin_test
fi
