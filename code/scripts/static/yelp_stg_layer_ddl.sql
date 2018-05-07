add jar s3://markev-developer-test/devtest-sharat/jars/json-serde-1.3.6-jar-with-dependencies.jar;

set hive.exec.dynamic.partition.mode=nonstrict;
set mapreduce.map.memory.mb=5120; 
set mapreduce.reduce.memory.mb=5120; 
set mapreduce.map.java.opts=-Xmx4096M; 
set mapreduce.reduce.java.opts=-Xmx4096M; 
set mapred.job.shuffle.input.buffer.percent=0.70; 
set mapreduce.task.io.sort.mb=1024; 
set hive.auto.convert.join.noconditionaltask=true; 
set mapreduce.input.fileinputformat.split.minsize=33554432; 
set hive.compute.query.using.stats=true; 
set mapred.task.timeout=60000000; 
set mapred.input.dir.recursive=true; 
set hive.mapred.supports.subdirectories=true; 
set mapreduce.jobtracker.split.metainfo.maxsize=-1; 
set mapred.reduce.tasks=-1; 
set hive.optimize.sort.dynamic.partition=true; 
set mapred.compress.map.output=true; 
set hive.exec.compress.intermediate=true;

create database if not exists yelp_staging ;
create table if not exists yelp_staging.stg_yelp_business_object(
        business_id string,
        name string,
        neighborhood string,
        address string,
        city string,
        state string,
        postal_code string,
        latitude string,
        longitude string,
        stars string,
        review_count string,
        is_open int,
        attributes struct< RestaurantsTakeOut:string,BusinessParking:struct<garage:boolean,street:boolean,validated:boolean,lot:boolean,valet:boolean>>,
        categories array<string>,
        hours struct< Monday:string , Tuesday:string,Friday:string,Wednesday:string,Thursday:string,Sunday:string,Saturday:string>
)
partitioned by (datestr string) 
stored as orc ;

insert overwrite table yelp_staging.stg_yelp_business_object partition(datestr)
select * from yelp_incoming_files.ext_yelp_business_object ;
