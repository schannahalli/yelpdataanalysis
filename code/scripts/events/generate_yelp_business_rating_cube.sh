#!/bin/bash

_sql_base_dir="/home/ec2-user/yelpdataanalysis/code/scripts/static/"
_sql_script="yelp_business_rating_cube_ddl.sql"
_base_dir="/home/ec2-user/yelpdataanalysis/code/scripts/events"

source $_base_dir/event_driven_library_function.sh
__event_name="generate_yelp_business_rating_cube"


_state=RUNNING
publish_event ${__event_name} ${_state}
_retval=$?
if [ "$_retval" -eq "0" ]; then
        echo "Event ${__event_name} registered successfully"
else
        echo "Event ${__event_name} failed to register at ${_run_time}"
        exit 1
fi

_command="hive -f ${_sql_base_dir}/${_sql_script}"
echo "Exceuting ${_command}"
eval ${_command}
_retval=$?
if [ "${retval}" = "0" ]; then
    echo "successfully executed cube"
    _state=SUCCEDED
else
    echo "failed to executed cube"
    _state=FAILED
fi

publish_event ${__event_name} ${_state}
_retval=$?
if [ "$_retval" -eq "0" ]; then
        echo "Event ${__event_name} registered successfully"
else
        echo "Event ${__event_name} failed to register at ${_run_time}"
        exit 1
fi
exit 0 
