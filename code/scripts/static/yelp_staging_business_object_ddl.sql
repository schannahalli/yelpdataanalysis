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
stored as orc;
