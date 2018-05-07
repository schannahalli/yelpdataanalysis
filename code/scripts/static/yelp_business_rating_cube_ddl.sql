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

create database if not exists yelp_cubes ;

create table if not exists yelp_cubes.yelp_business_rating_cube(
      name string,
      postal_code string,
      stars string
)
partitioned by (state string)
stored as orc
;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table yelp_cubes.yelp_business_rating_cube partition(state)
select name,postal_code,stars,state from ( select name,postal_code,state,stars,business_type from yelp_staging.stg_yelp_business_object lateral view explode (categories) exploded_table as business_type ) t where upper(t.business_type) like '%PIZZA%' ;


