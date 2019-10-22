#!/bin/bash





##### COLOR FUNCTIONS #####

putstr_red()
{
	echo -n $(tput setaf 1) $@ $(tput setaf 9) 
}

putstr_green()
{
	echo -n $(tput setaf 2) $@ $(tput setaf 9) 
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
	if [ -d ${TEST_DIR} ]
	then
		BUFFER_SIZE=<${TEST_DIR}/buffer_size
		echo ++++++${BUFFER_SIZE}
		#make fclean -C ${TEST_DIR} PATH="${PROJECT_PATH}" 1> /dev/null
		#make -C ${TEST_DIR} PATH="${PROJECT_PATH}" BUFFER_SIZE="32" 1> /dev/null
		#cd ${TEST_DIR}; ./gnl_test 1> user_output
		#make fclean -C ${TEST_DIR} PATH="${PROJECT_PATH}" 1> /dev/null
		#RESULT=$(diff expected_output user_output)
		#if [ ${RESULT} ]
		#then
	#		echo -n $(basename ${TEST_DIR}); putstr_red " KO"; echo
	#	else
	#		echo -n $(basename ${TEST_DIR}); putstr_green " OK"; echo
	#	fi
	fi
done

