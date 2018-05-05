add jar s3://markev-developer-test/devtest-sharat/jars/json-serde-1.3.6-jar-with-dependencies.jar;


create database if not exists yelp_incoming_files ;


create external table if not exists yelp_incoming_files.ext_yelp_business_object(
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
ROW FORMAT SERDE 
  'org.openx.data.jsonserde.JsonSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3n://markev-developer-test/devtest-sharat/repository/ETL/db/yelp_incoming_files/yelp_business_object'
;

