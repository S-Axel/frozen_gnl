#!/bin/bash





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





##### RUN TESTS #####

MAIN_TEST_DIR=${SCRIPT_PATH}/tests
for TEST_DIR in ${MAIN_TEST_DIR}/*
do
	echo -n $(basename ${TEST_DIR})
	cd ${TEST_DIR}
	ERRORS=""
	BUFFER_SIZE=$(<buffer_size)
	make re PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null 2>> errors
	rm user_output
	./gnl_test 1> user_output 2>> errors
	make fclean -C ${TEST_DIR} PATH="${PROJECT_PATH}" 1> /dev/null 2>> errors
	DIFF_RESULT=$(diff expected_output user_output)
	ERRORS=$(<errors)
	rm errors
	if [ "${DIFF_RESULT}" -o "${ERRORS}" ]
	then
		putstr_red " KO"
		echo -e "\n"
		if [ -f description ]
		then
			echo " description:"; putstr_magenta "$(cat -e description)"
			echo -e "\n\n"
		fi
		putstr_cyan " buffer size:"; echo; putstr_magenta "$(cat -e buffer_size)"
		echo -e "\n\n"
		putstr_cyan " file to read:"; echo; putstr_magenta "$(cat -e file_to_read)"
		echo -e "\n\n"
		putstr_cyan " expected output:"; echo; putstr_magenta "$(cat -e expected_output)"
		echo -e "\n\n"
		putstr_cyan " your output:"; echo; putstr_magenta "$(cat -e user_output)"
		echo -e "\n\n"
		if [ "${ERRORS}" ]
		then
			echo "${ERRORS}"
		else
			putstr_cyan " diff:"; echo; putstr_magenta "${DIFF_RESULT}"
			echo -e "\n"
		fi
	else
		putstr_green " OK"; echo
	fi
done

