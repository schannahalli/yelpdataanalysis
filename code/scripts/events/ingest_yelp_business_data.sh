#!/bin/bash
set -x 

__event_name='ingest_yelp_business_data'
_run_time=`date '+%Y%m%d%H%M%S'`

function usage() {
    echo "Need to pass base dir followed by input dir path"
}

if [ $# != 2 ]; then
	usage
	echo "Passed # of arguments $#"
	echo "Failed to pass right arguments at invocation time - ${_run_time}"
	exit 1
fi

_base_dir=$1
_input_dir=$2

source $_base_dir/event_driven_library_function.sh

_state='RUNNING'

publish_event ${__event_name} ${_state}
retval=$?

if [ "$retval" -eq "0" ]; then
	echo "Event ${__event_name} registered successfully"
else
	echo "Event ${__event_name} failed to register at ${_run_time}"
	exit 1
fi

export AWS_ACCESS_KEY_ID=AKIAJS2GENQR35MLOE5A
export AWS_SECRET_ACCESS_KEY=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

_date_str=`date '+%Y%m%d'`
_file_in='s3://markev-developer-test/devtest-sharat/incoming/tmp/'
_file_out='s3://markev-developer-test/devtest-sharat/repository/ETL/db/yelp_incoming_files/yelp_business_object/datestr='$_date_str'/'

_command='aws s3 cp ${_file_in} ${_file_out}'
`${command}`
retval=$?
if [ "$retval" -eq "0" ]; then
	echo "Copy from ${_file_in} to ${_file_out} was successfull"
else
	echo "Copy from ${_file_in} to ${_file_out} failed"
	_state=FAILED
	publish_event ${__event_name} ${_state}
	exit 1
fi

_state=SUCCEDED
publish_event ${__event_name} ${_state}
if [ "$retval" -eq "0" ]; then
	echo "Event ${__event_name} registered successfully with state ${_state}"
else
	echo "Event ${__event_name} failed to register at ${_run_time}"
	exit 1
fi

