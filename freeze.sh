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





##### PREPARE TESTS ######

MAIN_TEST_DIR=${SCRIPT_PATH}/tests

display_test_description()
{
	if [ -f description ]
	then
		putstr_cyan " description:"; echo; putstr_magenta "$(cat -e description)"
		echo -e "\n\n"
	fi
	putstr_cyan " buffer size:"; echo; putstr_magenta "$(cat -e buffer_size)"
	echo -e "\n\n"
	putstr_cyan " file to read:"; echo; putstr_magenta "$(cat -e file_to_read)"
	echo -e "\n\n"
	putstr_cyan " expected output:"; echo; putstr_magenta "$(cat -e expected_output)"
	echo -e "\n\n"
}

run_test()
{
	ERRORS=""
	BUFFER_SIZE=$(<buffer_size)
	make re PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 2>> errors 1> /dev/null
	rm user_output
	./gnl_test 2>> errors 1> user_output
	make fclean  PATH="${PROJECT_PATH}" 2>> errors 1> /dev/null
	DIFF_RESULT=$(diff expected_output user_output)
	ERRORS=$(<errors)
	rm errors
	if [ "${DIFF_RESULT}" -o "${ERRORS}" ]
	then
		putstr_red " KO"
		echo -e "\n"
		display_test_description
		putstr_cyan " your output:"; echo; putstr_magenta "$(cat -e user_output)"
		echo -e "\n\n"
		if [ "${ERRORS}" ]
		then
			putstr_cyan " errors:"; echo; putstr_magenta "${ERRORS}"
		else
			putstr_cyan " diff:"; echo; putstr_magenta "${DIFF_RESULT}"
		fi
		echo -e "\n"
	else
		putstr_green " OK"; echo
	fi
}





##### DEBUG OPTION #####

if [ "${1}" = "-debug" -a "${2}" ]
then
	cd ${MAIN_TEST_DIR}/${2}
	BUFFER_SIZE=$(<buffer_size)
	make fclean PATH="${PROJECT_PATH}"
	make debug PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}"
	lldb ./gnl_test
	make fclean PATH="${PROJECT_PATH}"
	exit
fi





##### DESCRIPTION OPTION #####

if [ "${1}" = "-description" -a "${2}" ]
then
	cd ${MAIN_TEST_DIR}/${2}
	display_test_description
	exit
elif [ "${1}" = "-description" ]
then
	for TEST_DIR in ${MAIN_TEST_DIR}/*
	do
		echo -ne $(basename ${TEST_DIR}) "\n"
		cd ${TEST_DIR}
		display_test_description
	done
	exit
fi





##### SPECIFIC TEST OPTION #####

if [ "${1}" = "-test" -a "${2}" ]
then
	cd ${MAIN_TEST_DIR}/${2}
	echo -n ${2}
	run_test
	exit
fi





##### STDIN OPTION #####

if [ "${1}" = "-stdin" ]
then
	cd stdin_test
	read -p "BUFFER_SIZE: " -e BUFFER_SIZE
	make re PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null
	./gnl_test
	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
	exit
fi





##### VALGRIND OPTION #####

if [ "${1}" = "-valgrind" -a "${2}" ]
then
	cd ${MAIN_TEST_DIR}/${2}
	BUFFER_SIZE=$(<buffer_size)
	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
	make debug PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null
	rm user_output
	valgrind --leak-check=yes ./gnl_test
	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
	exit
fi





##### UNKNOWN OPTION #####

if [ "${1}" ]
then
	echo "unknomn options: " ${@}
	exit
fi




	
##### RUN TESTS #####

for TEST_DIR in ${MAIN_TEST_DIR}/*
do
	cd ${TEST_DIR}
	echo -n $(basename ${TEST_DIR})
	run_test
done
