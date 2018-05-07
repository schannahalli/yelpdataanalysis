#!/bin/bash
set -x 

fetch_event_state_directory(){
    return 0 	
}


is_event_registered(){
    EVENT_NAME=$1
    ##check if the event is registered for publishing
    ##return 0 if true else 1
    return 0
}

publish_event(){

    _event_name=$1
    ##accepted values of event state RUNNING,FAILED,SUCCEDED
    _event_state=$2
    ##event timestamp 
    _event_time=`date '+%Y%m%d'`

    ##check if the event is registered
    is_event_registered $1
	
    ##check the status of event.
    echo ${_event_state}
    if [ "${_event_state}" != "RUNNING" ] && [  "${_event_state}" != "FAILED" ] && [  "${_event_state}" != "SUCCEDED" ]
    then
       echo "Event state - ${_event_state} incorrect "
    exit 1
    fi

    export AWS_ACCESS_KEY_ID=AKIAJS2GENQR35MLOE5A
    export AWS_SECRET_ACCESS_KEY=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

    ##fetch the base directory for saving event states    
    _event_state_directory="s3://markev-developer-test/devtest-sharat/repository/event_state/${_event_name}"
    _tmp_file="/tmp/${_event_state}_${_event_time}"
    `touch ${_tmp_file}`
    retval=$?
    if [ "${retval}" -eq "0" ]; then
       echo "success touching the file"
    else
       echo "failed touching the file"
    fi

#    _command="aws s3 cp ${_tmp_file} ${_event_state_directory}"
    _command='aws s3 cp'" ${_tmp_file} ${_event_state_directory}/"

    echo "${_command}"

    eval "${_command}"

    retval=$?
    if [ "${retval}" -eq "0" ]; then
     	echo "Successfully published"
    else
     	echo "Event publishing unsuccessfull"
    fi
    ##create a new file under basedir/event/
 
    return 0    
}

notify_event(){
    EVENT_NAME=

    ##fetch event handler from the configuration
    EVENT_HANDLER=
    
    ##invoke the event

}


## check for input arguments
