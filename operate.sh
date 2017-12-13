#!/bin/bash
#

#CONTAINER_PROD_NAME="pigen_work"
#CONTAINER_TEST_NAME="pigen_test"
ANS_ARGS=""

usage() {
    echo $"Usage: $0 {play|try|ping|setup} {playbook}"
	echo $"Always localhost"
    exit 1
}

_set_verbose() {
	ANS_ARGS="$ANS_ARGS -vv"
}

ansible_play() {
	local PLAYBOOK_PATH=$1
	local ANS_EXEC="ansible-playbook"
	
	ANS_ARGS="$ANS_ARGS --connection=local --ask-sudo-pass"

	_set_verbose
	ANS_ARGS="${PLAYBOOK_PATH} $ANS_ARGS"

	echo "Exec... '${ANS_EXEC} ${ANS_ARGS}'"
	${ANS_EXEC} ${ANS_ARGS}
}

ansible_try() {
	local PLAYBOOK_PATH=$1
	local ANS_EXEC="ansible-playbook"

	ANS_ARGS="$ANS_ARGS --connection=local --ask-sudo-pass"

	ANS_ARGS="$ANS_ARGS -C "
	
	_set_verbose
	
	ANS_ARGS="${PLAYBOOK_PATH} $ANS_ARGS"

	echo "Exec... '${ANS_EXEC} ${ANS_ARGS}'"
	${ANS_EXEC} ${ANS_ARGS}
}


ansible_setup() {
	local PLAYBOOK_PATH=operate-setup-all.yml
	local ANS_EXEC="ansible"

	ANS_ARGS="$ANS_ARGS --connection=local --ask-sudo-pass"

	_set_verbose

	ANS_ARGS="$ANS_ARGS -m setup all"

	echo "Exec... '${ANS_EXEC} ${ANS_ARGS}'"
	${ANS_EXEC} ${ANS_ARGS}
}

case "$1" in
	play)
		ansible_play $2 $3
		;;
	try)
	    ansible_try $2 $3
	    ;;
	setup)
		ansible_setup $2
		;;
	*)  
	    usage
	    ;;
esac

