#!/bin/bash
set -x 

declare -a events=("ingest_yelp_business_data" "validate_yelp_business_data" "generate_yelp_business_stage_data" "generate_yelp_business_rating_cube" "validate_yelp_business_rating_cube" "export_yelp_business_rating_cube" )
declare -A executable=([ingest_yelp_business_data]="validate_yelp_business_data.sh"  [validate_yelp_business_data]="generate_yelp_business_stage_data.sh" [generate_yelp_business_stage_data]="generate_yelp_business_rating_cube.sh" [export_yelp_business_rating_cube]="")

state_dir="/home/ec2-user/tmp/states/"
base_script_dir="/home/ec2-user/yelpdataanalysis/code/scripts/events"
for i in "${events[@]}"
do
   echo "checking notifications for $i"
   notification_dir="s3://markev-developer-test/devtest-sharat/repository/event_state/$i/"
   command="aws s3 ls ${notification_dir}"
   _dir=`${command}|tail -n 1`
   tmp="$(cut -d' ' -f4 <<<${_dir})"
   `touch ${state_dir}/${i}`
   last_event_state=`cat ${state_dir}/${i}`   
   echo "executable is ${executable[${i}]}"
   if [ "$last_event_state" = "$tmp" ]; then
       echo "no change in state for ${i}"
   else
       echo "state changed for ${i}"
       command="${base_script_dir}/${executable[${i}]} ${base_script_dir} ${base_script_dir}"
       echo ${command}
       eval ${command}
       `echo "${tmp}" > ${state_dir}/${i}`
   fi
break
done

