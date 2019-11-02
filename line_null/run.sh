#!/bin/bash

echo -e "\n" \#\#\#\#\# LINE NULL \#\#\#\#\# "\n"


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





##### PREPARE TESTS ######

display_test_description()
{
	if [ -f ${1}/description ]
	then
		putstr_cyan " description:"; echo; putstr_magenta "$(cat -e ${1}/description)"
		echo -e "\n\n"
	fi
	putstr_cyan " buffer size:"; echo; putstr_magenta "$(cat -e ${1}/buffer_size)"
	echo -e "\n\n"
	putstr_cyan " file to read:"; echo; putstr_magenta "$(cat -e ${1}/file_to_read)"
	echo -e "\n\n"
	putstr_cyan " expected output:"; echo; putstr_magenta "$(cat -e ${1}/expected_output)"
	echo -e "\n\n"
}

run_test()
{
	echo -n $(basename ${1})
	ERRORS=""
	BUFFER_SIZE=$(<${1}/buffer_size)
	make re  BUFFER_SIZE="${BUFFER_SIZE}" 2>> errors 1> /dev/null
	rm -f user_output
	./gnl_test ${1}/file_to_read 2>> errors 1> user_output
	make fclean   2>> errors 1> /dev/null
	DIFF_RESULT=$(diff ${1}/expected_output user_output)
	ERRORS=$(<errors)
	rm -f errors
	if [ "${DIFF_RESULT}" -o "${ERRORS}" ]
	then
		putstr_red " KO"
		echo -e "\n"
		display_test_description ${1}
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
	BUFFER_SIZE=$(<tests/${2}/buffer_size)
	make fclean PATH="${PROJECT_PATH}" 1> /dev/null
	make debug PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null
	lldb ./gnl_test tests/${2}/file_to_read
	make fclean PATH="${PROJECT_PATH}" 1> /dev/null
	exit
fi





##### DESCRIPTION OPTION #####

if [ "${1}" = "-description" -a "${2}" ]
then
	display_test_description tests/${2}
	exit
elif [ "${1}" = "-description" ]
then
	for TEST_DIR in tests/*
	do
		echo -ne $(basename ${TEST_DIR}) "\n"
		display_test_description ${TEST_DIR}
	done
	exit
fi





##### SPECIFIC TEST OPTION #####

if [ "${1}" = "-test" -a "${2}" ]
then
	if [ -d "tests/${2}" ]
	then
		run_test tests/${2}
	fi
	exit
fi





##### VALGRIND OPTION #####

# if [ "${1}" = "-valgrind" -a "${2}" ]
# then
# 	cd ${MAIN_TEST_DIR}/${2}
# 	BUFFER_SIZE=$(<buffer_size)
# 	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
# 	make debug PATH="${PROJECT_PATH}" BUFFER_SIZE="${BUFFER_SIZE}" 1> /dev/null
# 	rm user_output
# 	valgrind --leak-check=yes ./gnl_test
# 	make fclean  PATH="${PROJECT_PATH}" 1> /dev/null
# 	exit
# fi





##### UNKNOWN OPTION #####

if [ "${1}" ]
then
	echo "unknomn options: " ${@}
	exit
fi




	
##### RUN TESTS #####

for TEST_DIR in tests/*
do
	run_test ${TEST_DIR}
done
