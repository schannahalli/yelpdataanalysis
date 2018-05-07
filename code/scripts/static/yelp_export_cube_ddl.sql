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

drop table yelp_outgoing_cubes.ext_yelp_business_rating_cube2 ;
CREATE TABLE  if not exists yelp_outgoing_cubes.ext_yelp_business_rating_cube2(
      name string,
      postal_code int,
      stars double
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION 's3n://markev-developer-test/devtest-sharat/repository/ETL/db/yelp_outgoing_files/ext_yelp_business_rating_cube2';


insert overwrite table yelp_outgoing_cubes.ext_yelp_business_rating_cube2 
select name,postal_code,rating from (select name,cast(postal_code as int) as postal_code,cast(stars as double) as rating ,rank() over (partition by name,postal_code order by datestr desc) as rank from yelp_cubes.yelp_business_rating_cube where (nvl(postal_code,'x') !='x' or trim(postal_code) != '' and postal_code rlike '[^0-9]') or (nvl(name,'x') !='x' or trim(name) != '') or (nvl(stars,'x') !='x' or trim(stars) != '' and stars rlike '[^0-9.]')) t where t.rank = 1 ;

